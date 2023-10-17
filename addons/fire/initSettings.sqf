[
    QGVAR(enabled), "CHECKBOX",
    [ELSTRING(common,Enabled), LSTRING(Setting_Description)],
    LSTRING(Category_DisplayName),
    true, // default value
    true, // isGlobal
    {[QGVAR(fireEnabled), _this] call EFUNC(common,cbaSettings_settingChanged)},
    true // Needs mission restart
] call CBA_fnc_addSetting;

[
    QGVAR(enableFlare), "CHECKBOX",
    [LSTRING(Setting_FlareEnable), LSTRING(Setting_FlareDescription)],
    LSTRING(Category_DisplayName),
    false, // default value
    true, // isGlobal
    {[QGVAR(flareEnabled), _this] call EFUNC(common,cbaSettings_settingChanged)},
    true // Needs mission restart
] call CBA_fnc_addSetting;

[
    QGVAR(dropWeapon), "LIST",
    [LSTRING(Setting_DropWeapon), LSTRING(Setting_DropWeapon_Description)],
    LSTRING(Category_DisplayName),
    [
        [0,1,2],
        [localize "STR_A3_OPTIONS_DISABLED", ELSTRING(common,aiOnly), ELSTRING(common,playersAndAI)],
        1
    ],
    true // isGlobal
] call CBA_fnc_addSetting;

[
    QGVAR(enableScreams), "CHECKBOX",
    [LSTRING(Setting_EnableScreams), LSTRING(Setting_EnableScreams_Description)],
    LSTRING(Category_DisplayName),
    true,
    false // isGlobal
] call CBA_fnc_addSetting;

[
    QGVAR(fireMult), "SLIDER",
    [LSTRING(Setting_NonMedBurnMult), LSTRING(Setting_NonMedBurnMult_Description)],
    LSTRING(Category_DisplayName),
    [0, 10, 0.5, 2, false],
    true,
    {[QGVAR(fireMult), _this, true] call EFUNC(common,cbaSettings_settingChanged)}
] call CBA_fnc_addSetting;

GVAR(aceMedLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
GVAR(APSLoaded) = isClass(configFile >> "CfgPatches" >> "diw_armor_plates_main");