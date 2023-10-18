#include "..\script_component.hpp"
/*
 * Author: Alien314
 * addAction pat down for use without ACE med
 *
 * Arguments:
 * 0: Character to add action to <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * player call ace_fire_fnc_patDownActions
 *
 * Public: Yes?
 */
params ["_unit"];

if (GVAR(aceMedLoaded)) exitWith { };

  if (_unit getVariable [QGVAR(patInit), false]) exitWith { };
  
  private _id = _unit addAction
  [
    "<img image='\A3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_put_down_ca.paa' size='1.8' shadow=2 />",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _caller setVariable [QGVAR(patting), true];
		private _selfPat = (_target isEqualTo _caller);
		private _medicAnim = [[QEGVAR(gestures,forward), "gestureCeaseFire"],["gestureFollow", QEGVAR(gestures,cover)]] 	select _selfPat;
		private _animLgth = [[1, 2],[1, 1.4]] select _selfPat;
		[_caller, _medicAnim, _animLgth] spawn {
            params ["_caller", "_gestureSet", "_animLgth"];
            while {_caller getVariable [QGVAR(patting), false] && { alive _caller && {lifeState _caller isNotEqualTo "INCAPACITATED"} } } do {
		        private _index = round (Random 1);
		        private _gesture = (_gestureSet select _index);
		        [_caller, _gesture] call EFUNC(common,doGesture);
			    sleep (_animLgth select _index);
		    };
        };
        [_target, _caller] spawn {
          params ["_target", "_caller"];
          sleep 5;
          _caller setVariable [QGVAR(patting), false];
          if (!alive _target || {!alive _caller || {lifeState _caller isEqualTo "INCAPACITATED"}}) exitWith { };
          private _intensity = _target getVariable [QGVAR(intensity), 0];
          _intensity = _intensity * (4/5);
          _target setVariable [QGVAR(intensity), _intensity, true];
        };
    },
    nil,
    10,
    true,
    true,
    "", 
	format ["_target getVariable ['%1',false] && {!(_this getVariable ['%2',false]) }", QGVAR(burning), QGVAR(patting)],
	4
  ];
  _unit setUserActionText [_id, LLSTRING(Actions_PatDown), "<img image='\A3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_put_down_ca.paa' size='1.8' shadow=2 />"];
 
if (player getVariable [QGVAR(patInit), false]) exitWith { };
private _action = [LLSTRING(Actions_PatDown),
  LLSTRING(Actions_PatDown),
  "\A3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_put_down_ca.paa",
  {
    params ["_target", "_caller"];
    _caller setVariable [QGVAR(patting), true];
	private _medicAnim = [QEGVAR(gestures,forward), "gestureCeaseFire"];
	private _animLgth = [1, 2];
	[_caller, _medicAnim, _animLgth] spawn {
        params ["_caller", "_gestureSet", "_animLgth"];
        while {_caller getVariable [QGVAR(patting), false] && { alive _caller && {lifeState _caller isNotEqualTo "INCAPACITATED"} } } do {
	        private _index = round (Random 1);
		    private _gesture = (_gestureSet select _index);
		    [_caller, _gesture] call EFUNC(common,doGesture);
		    sleep (_animLgth select _index);
		};
    };
    [_target, _caller] spawn {
        params ["_target", "_caller"];
        sleep 5;
        _caller setVariable [QGVAR(patting), false];
        if (!alive _target || {!alive _caller || {lifeState _caller isEqualTo "INCAPACITATED"}}) exitWith { };
        private _intensity = _target getVariable [QGVAR(intensity), 0];
        _intensity = _intensity * (4/5);
        _target setVariable [QGVAR(intensity), _intensity, true];
    };
  },
  {
      _target getVariable [QGVAR(burning), false] && {!(_player getVariable [QGVAR(patting), false])}
  },
  {},
  [],
  [0,0,0],
  4,
  [false,true,false,false,false]
  ] call ace_interact_menu_fnc_createAction;
  ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
  
  _unit setVariable [QGVAR(patInit), true];