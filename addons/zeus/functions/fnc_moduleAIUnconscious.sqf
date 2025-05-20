#include "..\script_component.hpp"
/*
 * Author: kymckay, ALien314
 * Enables the unconscious state for the AI unit the module is placed on.
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
 * [LOGIC, [bob, kevin], true] call ace_zeus_fnc_moduleAIUnconscious
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
				// Get whether unit AIUncon variable is enabled
				private _specified = (_unit getVariable [QEGVAR(medical_statemachine,AIUnconsciousness), false]);

				private _unconscious = GETVAR(_unit,ACE_isUnconscious,false);

				// Set true on wakeup, to make permanent if unit was knocked out with the other module
				if (_unconscious) exitWith {
					[{!(GETVAR(_this,ACE_isUnconscious,false))}, {
						[{_this setVariable [QEGVAR(medical_statemachine,AIUnconsciousness), true, true];}, _this, 0.1] call CBA_fnc_waitAndExecute;
					}, _unit] call CBA_fnc_waitUntilAndExecute;
                    [
                        [format[LSTRING(showAIUnconVar_hint), name _unit, ELSTRING(Common,Enabled)]],
                    true] call CBA_fnc_notify;
				};
				_unit setVariable [QEGVAR(medical_statemachine,AIUnconsciousness), ([true,nil] select _specified), true];
                [
                    [format[LSTRING(showAIUnconVar_hint), name _unit, ([ELSTRING(Common,Enabled),ELSTRING(Common,Disabled)] select _specified)]],
                true] call CBA_fnc_notify;
            };
        };
    };
};

deleteVehicle _logic;
