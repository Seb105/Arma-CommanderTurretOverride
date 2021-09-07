#include "script_component.hpp"

/*
 * Author: Seb
 * Check if a vehicles config supports Commander Turret Override. It does NOT check if the commander
 * is allowed to do CTO or not, just that the vehicle itself supports it.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Can this vehicle do Commander Turret Override? <BOOL>
 *
 * Example:
 * [vehicle player] call CTO_main_fnc_vehicleHasTurretOverride
 *
 * Public: No
 */

params ["_vehicle"];
private _vehicleCfg =  configFile >> "CfgVehicles" >> typeOf _vehicle;
if ([_vehicleCfg, "hasCommanderTurretOverride", 1] call BIS_fnc_returnConfigEntry isNotEqualTo 1) exitWith {false};
private _turretCfg = _vehicleCfg >> "Turrets" >> "MainTurret";
if !(isClass _turretCfg) exitWith {false};
if (isNil {[_turretCfg, "maxHorizontalRotSpeed", nil] call BIS_fnc_returnConfigEntry}) exitWith {false};
true