#include "script_component.hpp"

params ["_vehicle"];
private _turretCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "MainTurret";
private _gunRotSource = [_turretCfg,"animationSourceBody", nil] call BIS_fnc_returnConfigEntry;
-(deg (_vehicle animationSourcePhase _gunRotSource)) // Dir of gun -180 to 180
