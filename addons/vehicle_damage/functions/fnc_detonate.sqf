#include "script_component.hpp"
/*
 * Author: Dani (TCVM)
 * Detonates vehicle ammo and heavily wounds all inside.
 *
 * Arguments:
 * 0: The vehicle <OBJECT>
 * 1: Person who caused detonation <OBJECT> (default: objNull)
 * 2: An array of vehicle ammo in vehicle <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [tank2] call ace_vehicle_damage_fnc_detonate;
 *
 * Public: No
 */

params ["_vehicle", ["_injurer", objNull], ["_vehicleAmmo", []]];

if (_vehicleAmmo isEqualTo []) then {
    _vehicleAmmo = [_vehicle] call EFUNC(cookoff,getVehicleAmmo);
};

([_vehicle] + _vehicleAmmo) call EFUNC(cookoff,detonateAmmunition);

if ((_vehicleAmmo select 1) > 0) then {
    {
        // random amount of injuries        
          if (GVAR(aceMedLoaded)) then {
            for "_i" from 0 to random 5 do {
                [_x, (random 1), selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"], selectRandom ["bullet", "shell", "explosive"], _injurer] call EFUNC(medical,addDamageToUnit); 
            };          
          } else {
            for "_i" from 0 to random 5 do {
            private _woundSelection = selectRandom ["Face", "Neck", "Head", "Pelvis", "Abdomen", "Diaphragm", "Chest", "Arms", "Hands", "Legs"];
            if (GVAR(APSLoaded)) then {
                private _fragLoaded = isClass(configFile >> "CfgPatches" >> "ace_frag");
                private _ammo = (["B_65x39_Caseless","ace_frag_small"] select _fragLoaded);
                [QGVAR(plateDamage), [_x, (random 1), _woundSelection, _injurer, _ammo], _x] call CBA_fnc_targetEvent;
                //[_x, random 1, _woundSelection, _injurer,_ammo] remoteExec ["diw_armor_plates_main_fnc_receiveDamage", _x];
            } else {
                private _newDamage = (_x getHitPointDamage ("hit"+_woundSelection) + (random 1));
                _x setHitPointDamage [("hit"+_woundSelection), _newDamage, true, _injurer]; };
            };
          };
            
    } forEach crew _vehicle;
};
