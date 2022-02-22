#include "script_component.hpp"

/*
 * Author: Seb
 * Force a vehicle to traverse its turret to the given target
 *
 * Arguments:
 * 0: Vehicle to traverse turret <OBJECT>
 * 1: Target <OBJECT, POSITION AGL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [vehicle player, [3000, 3000 ,0]] call CTO_main_fnc_vehicleTraverseTurret
 *
 * Public: Yes
 */

params ["_vehicle", "_target"];

private _currentUnit = call CBA_fnc_currentUnit;
private _currentGunner = gunner _vehicle;
private _hasGunner = !(isNull _currentGunner);
private _currentUnitIsGunner = _currentGunner == _currentUnit;
if (_hasGunner && !_currentUnitIsGunner) exitWith {_currentGunner lookAt _target }; // AI is gunner.

_vehicle lockCameraTo [_target, [0], true];

private _turretCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "MainTurret";
if (_currentUnitIsGunner) then {
    QGVAR(overrideCutText) cutText [
        format [
            "<t color='#ff0000' font='PuristaBold' size='2'>%1</t>",
            LLSTRING(OverrideMessage)
        ], 
        "PLAIN DOWN", 
        0.25, 
        false, 
        true
    ];
}
