private _category = [LELSTRING(common,categoryUncategorized), LLSTRING(DisplayName)];

[
    QGVAR(distanceCoefficient), "SLIDER",
    [LSTRING(distanceCoefficient_displayName), LSTRING(distanceCoefficient_toolTip)],
    _category,
    [-1, 10, 1, 1],
    1
] call CBA_fnc_addSetting;

GVAR(APSLoaded) = isClass(configFile >> "CfgPatches" >> "APS_system");
if (GVAR(APSLoaded)) then {
[
	QGVAR(APSBackblast), "LIST",
	[LSTRING(APSBackblast_displayName),	LSTRING(APSBackblast_toolTip)],
    _category,
	[[0,1,2,3,4],[[LLSTRING(APSBackblast_setDowns)],[LLSTRING(APSBackblast_setPvP)],[LLSTRING(APSBackblast_setKillDown)],[LLSTRING(APSBackblast_setKill)],[LLSTRING(APSBackblast_setNoPlates)]],0],
	true,
	{[QGVAR(APSBackblast), _this, true] call EFUNC(common,cbaSettings_settingChanged)}
] call CBA_fnc_addSetting;
};