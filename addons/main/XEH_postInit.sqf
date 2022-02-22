#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if !(hasInterface) exitWith {};
["LandVehicle", "initPost", {
    private _vehicle = (_this select 0);
    private _hasCommander = false;
    private _hasGunner = false;
    {
        _x params ["_unit", "_role", "_cargoIndex", "_turretPath", "_personTurret"];
        switch _role do {
            case "commander":   {_hasCommander = true};
            case "gunner":      {_hasGunner = true};
            default {};
        };
    } forEach (fullCrew [_vehicle, "", true]);
    if (_hasGunner && _hasCommander && (_vehicle call FUNC(vehicleHasTurretOverride))) then {
        _vehicle call FUNC(addActions);
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;

[
    LLSTRING(CommanderTurretOverride), 
    QGVAR(commanderDesignateKey),
    LLSTRING(CommanderTurretOverrideKey_Display),
    {
        call FUNC(commanderDesignate);
    },
    "",
    [DIK_T, [false, false, true]]
] call CBA_fnc_addKeybind;
