#include "script_component.hpp"
        // blow off turret effect
        /*
        Disabled temporarily due to issues with being able to repair tanks after death. Needs work
        */
        ["Tank", "killed", { params ["_vehicle"];
            if (GVAR(turretPop) && {random 1 < 0.15}) then {
                _vehicle call FUNC(blowOffTurret);
                [{ params ["_vehicle"];
                  _vehicle enableSimulationGlobal false;
                }, _vehicle, 6] call CBA_fnc_waitAndExecute;
            };
        }, true, [], true] call CBA_fnc_addClassEventHandler;

["ace_settingsInitialized", {
    TRACE_1("settings init",GVAR(enabled));
    if (GVAR(enabled)) then {
        [QGVAR(bailOut), {
            params ["_center", "_crewman", "_vehicle"];
            TRACE_3("bailOut",_center,_crewman,_vehicle);

            if (isPlayer _crewman) exitWith {};
            if (!alive _crewman || { !( [_crewman] call EFUNC(common,isAwake))} ) exitWith {};

            unassignVehicle _crewman;
            _crewman leaveVehicle _vehicle;
            doGetOut _crewman;

            private _angle = floor (random 360);
            private _dist = (30 + (random 10));
            private _escape = _center getPos [_dist, _angle];

            _crewman doMove _escape;
            _crewman setSpeedMode "FULL";
        }] call CBA_fnc_addEventHandler;

        ["Tank", "init", LINKFUNC(addEventHandler), true, [], true] call CBA_fnc_addClassEventHandler;
        ["Wheeled_APC_F", "init", LINKFUNC(addEventHandler), true, [], true] call CBA_fnc_addClassEventHandler;

        if (GVAR(enableCarDamage)) then {
            ["Car", "init", LINKFUNC(addEventHandler), true, [], true] call CBA_fnc_addClassEventHandler;
        };

        // event to add a turret to a curator if the vehicle already belonged to that curator
        if (isServer) then {
            [QGVAR(addTurretToEditable), {
                params ["_vehicle", "_turret"];

                {
                    _x addCuratorEditableObjects [[_turret], false];
                } forEach (objectCurators _vehicle);
            }] call CBA_fnc_addEventHandler;
        };
    };
    [QGVAR(plateDamage), {
        _this call diw_armor_plates_main_fnc_receiveDamage;
    }] call CBA_fnc_addEventHandlerArgs;

    // init eject from destroyed vehicle
    {
        [_x, "init", {
            params ["_vehicle"];
            if (!alive _vehicle) exitWith {};
            TRACE_2("ejectIfDestroyed init",_vehicle,typeOf _vehicle);
            _vehicle addEventHandler ["HandleDamage", {call FUNC(handleDamageEjectIfDestroyed)}];
        }, true, [], true] call CBA_fnc_addClassEventHandler;
    } forEach EJECT_IF_DESTROYED_VEHICLES;
}] call CBA_fnc_addEventHandler;
