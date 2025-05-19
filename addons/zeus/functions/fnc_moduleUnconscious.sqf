#include "..\script_component.hpp"
/*
 * Author: kymckay
 * Flips the unconscious state of the unit the module is placed on.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC, [bob, kevin], true] call ace_zeus_fnc_moduleUnconscious
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

if (isNil QEFUNC(medical,setUnconscious)) then {
    [LSTRING(RequiresAddon)] call FUNC(showMessage);
} else {
    private _mouseOver = GETMVAR(bis_fnc_curatorObjectPlaced_mouseOver,[""]);

    if ((_mouseOver select 0) != "OBJECT") then {
        [LSTRING(NothingSelected)] call FUNC(showMessage);
    } else {
        private _unit = effectiveCommander (_mouseOver select 1);

        if !(_unit isKindOf "CAManBase") then {
            [LSTRING(OnlyInfantry)] call FUNC(showMessage);
        } else {
            if !(alive _unit) then {
                [LSTRING(OnlyAlive)] call FUNC(showMessage);
            } else {
				// Get whether global or unit AIUncon variable is enabled
				private _specified = (EGVAR(medical_statemachine,AIUnconsciousness) || {(_unit getVariable [QEGVAR(medical_statemachine,AIUnconsciousness), false])});

                private _unconscious = GETVAR(_unit,ACE_isUnconscious,false);
                if !(_unconscious) then {
					// Set unit AIUncon var if unspecified
                    if !(_specified) then {
						_unit setVariable [QEGVAR(medical_statemachine,AIUnconsciousness), true, true];
					};
                };
                // Function handles locality for me
                [_unit, !_unconscious, 10e10] call EFUNC(medical,setUnconscious);

				// nil unit AIUncon var on wakeup if unspecified
				if !(_specified) then {
					[{!(GETVAR(_this,ACE_isUnconscious,false))}, {_this setVariable [QEGVAR(medical_statemachine,AIUnconsciousness), nil, true];}, _unit] call CBA_fnc_waitUntilAndExecute;
				};
            };
        };
    };
};

deleteVehicle _logic;
