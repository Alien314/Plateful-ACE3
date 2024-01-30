[
    QGVAR(enabled), "CHECKBOX",
    [ELSTRING(common,Enabled), LSTRING(setting_description)],
    LSTRING(category_displayName),
    false, // default value
    true, // isGlobal
    {[QGVAR(enabled), _this] call EFUNC(common,cbaSettings_settingChanged)},
    true // Needs mission restart
] call CBA_settings_fnc_init;

[
    QGVAR(removeAmmoDuringCookoff), "CHECKBOX",
    [LSTRING(removeAmmoAfterCookoff_setting_enable), LSTRING(removeAmmoAfterCookoff_setting_description)],
    LSTRING(category_displayName),
    true, // default value
    true, // isGlobal
    {[QGVAR(removeAmmoDuringCookoff), _this] call EFUNC(common,cbaSettings_settingChanged)},
    false // Needs mission restart
] call CBA_settings_fnc_init;

[
    QGVAR(enableCarDamage), "CHECKBOX",
    [LSTRING(carDamage_setting_enable), LSTRING(carDamage_setting_description)],
    LSTRING(category_displayName),
    false, // default value
    true, // isGlobal
    {[QGVAR(enableCarDamage), _this] call EFUNC(common,cbaSettings_settingChanged)},
    true // Needs mission restart
] call CBA_settings_fnc_init;

/*[
    QGVAR(enableAirDamage), "CHECKBOX",
    [LSTRING(airDamage_setting_enable), LSTRING(airDamage_setting_description)],
    LSTRING(category_displayName),
    false, // default value
    true, // isGlobal
    {[QGVAR(enableAirDamage), _this] call EFUNC(common,cbaSettings_settingChanged)},
    true // Needs mission restart
] call CBA_settings_fnc_init;*/

[
    QGVAR(turretPop), "CHECKBOX",
    ["Enable Tank turret pop", "Tank turrets have a chance of popping off after destruction(Advanced vic damage not required)."],
    LSTRING(category_displayName),
    false, // default value
    true, // isGlobal
    {[QGVAR(turretPop), _this] call EFUNC(common,cbaSettings_settingChanged)},
    false // Needs mission restart
] call CBA_settings_fnc_init;

GVAR(aceMedLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
GVAR(APSLoaded) = isClass(configFile >> "CfgPatches" >> "diw_armor_plates_main");