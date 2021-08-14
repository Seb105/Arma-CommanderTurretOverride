#include "script_component.hpp"

/*
 * Author: Seb
 * Gets the direction of the turret relative to the model.
 *
 * Arguments:
 * 0: Vehicle doing the traversal <OBJECT>
 *
 * Return Value:
 * Direction of gun -180..180 <NUMBER>
 *
 * Example:
 * [vehicle player] call CTO_main_fnc_getMainTurretDir
 *
 * Public: No
 */

params ["_vehicle"];
private _turretCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "MainTurret";
private _gunRotSource = [_turretCfg,"animationSourceBody", nil] call BIS_fnc_returnConfigEntry;
-(deg (_vehicle animationSourcePhase _gunRotSource)) // Dir of gun -180 to 180
