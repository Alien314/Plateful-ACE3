#include "..\script_component.hpp"
/*
 * Author: commy2 and esteldunedain
 * Calculate and apply backblast damage to potentially affected local units
 * Handles the "overpressure" event.
 *
 * Arguments:
 * 0: Unit that fired <OBJECT>
 * 1: Pos ASL of the projectile <ARRAY>
 * 2: Direction of the projectile (reversed for launcher backblast) <ARRAY>
 * 3: Weapon fired <STRING>
 * 4: Magazine <STRING>
 * 5: Ammo <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [tank, [1727.57,5786.15,7.24899], [-0.982474,-0.185998,-0.0122501], "cannon_125mm", "24Rnd_125mm_APFSDS_T_Green", "Sh_125mm_APFSDS_T_Green"] call ace_overpressure_fnc_overpressureDamage
 *
 * Public: No
 */

params ["_firer", "_posASL", "_direction", "_weapon", "_magazine", "_ammo"];

// Retrieve overpressure values
private _opValues = [_weapon, _ammo, _magazine] call FUNC(getOverPressureValues);

_opValues params ["_overpressureAngle", "_overpressureRange", "_overpressureDamage"];
TRACE_3("cache",_overpressureAngle,_overpressureRange,_overpressureDamage);

{
    if (local _x && {_x != _firer} && {vehicle _x == _x}) then {
        private _targetPositionASL = eyePos _x;
        private _relativePosition = _targetPositionASL vectorDiff _posASL;
        private _axisDistance = _relativePosition vectorDotProduct _direction;
        private _distance = vectorMagnitude _relativePosition;
        private _angle = acos (_axisDistance / _distance);

        private _line = [_posASL, _targetPositionASL, _firer, _x];
        private _line2 = [_posASL, _targetPositionASL];
        TRACE_4("Affected:",_x,_axisDistance,_distance,_angle);

        if (_angle < _overpressureAngle && {_distance < _overpressureRange} && {!lineIntersects _line} && {!terrainIntersectASL _line2}) then {
            TRACE_2("",isDamageAllowed _unit,_unit getVariable [ARR_2(QEGVAR(medical,allowDamage),true)]);

            // Skip damage if not allowed
            if (isDamageAllowed _x && {_x getVariable [QEGVAR(medical,allowDamage), true]}) then {
                private _alpha = sqrt (1 - _distance / _overpressureRange);
                private _beta = sqrt (1 - _angle / _overpressureAngle);

                private _damage = _alpha * _beta * _overpressureDamage;
                TRACE_1("",_damage);

                // If the target is the ACE_player
                if (_x isEqualTo ACE_player) then {
                    [_damage * 100] call BIS_fnc_bloodEffect;
                };

                if (["ace_medical"] call EFUNC(common,isModLoaded)) then {
                    [_x, _damage, "body", "backblast", _firer] call EFUNC(medical,addDamageToUnit);
                } else {
				  if (GVAR(APSLoaded) && {GVAR(APSBackblast) < 4}) then {
				    [_x, _damage, "", _firer] call diw_armor_plates_main_fnc_receiveDamage;
				    if (GVAR(APSBackblast) == 0) exitWith {};
				    if (GVAR(APSBackblast) == 2 && {lifeState _x isEqualTo "INCAPACITATED"}) exitWith {
				      _x setDamage 1};
				    if (GVAR(APSBackblast) == 3 && {damage _x > 0.94} || {!(side _firer isEqualTo side _x)}) then {_x setDamage 1};
				  } else { _x setDamage (damage _x + _damage);
			        [_x, _firer]  spawn { params ["_affected", _firer];
						sleep 0.5;
						if (alive _affected && {GVAR(APSLoaded)}) then {
							_affected setVariable ["diw_armor_plates_main_hp", linearConversion [1, 0, damage _affected, 0,_affected getVariable ["diw_armor_plates_main_maxHp",[diw_armor_plates_main_maxAiHP, diw_armor_plates_main_maxPlayerHP] select (isPlayer _unit)], true], true ];
							_affected call diw_armor_plates_main_fnc_updateHPUi;
						};
					};
				  };
                };
            };

            #ifdef DEBUG_MODE_FULL
            //Shows damage lines in green
            [   _posASL,
            _targetPositionASL,
            [0,1,0,1]
            ] call EFUNC(common,addLineToDebugDraw);
            #endif
        };
    };
} forEach ((ASLtoAGL _posASL) nearEntities ["CAManBase", _overpressureRange]);
