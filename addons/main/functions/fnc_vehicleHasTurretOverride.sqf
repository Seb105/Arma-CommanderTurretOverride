#include "script_component.hpp"
params ["_vehicle"];
private _vehicleCfg =  configFile >> "CfgVehicles" >> typeOf _vehicle;
if ([_vehicleCfg, "hasCommanderTurretOverride", 1] call BIS_fnc_returnConfigEntry isNotEqualTo 1) exitWith {false};
private _turretCfg = _vehicleCfg >> "Turrets" >> "MainTurret";
if !(isClass _turretCfg) exitWith {false};
if (isNil {[_turretCfg, "maxHorizontalRotSpeed", nil] call BIS_fnc_returnConfigEntry}) exitWith {false};
true