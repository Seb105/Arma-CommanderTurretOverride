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
private _isRemoteControlled = player != _currentUnit && !isNull player;
private _currentGunner = gunner _vehicle;
if (_currentGunner getVariable [QGVAR(overrideInProgress), false]) exitWith {};
private _hasGunner = !(isNull _currentGunner);
private _currentUnitIsGunner = _currentGunner == _currentUnit;
if (_hasGunner && !_currentUnitIsGunner) exitWith {_currentGunner lookAt _target }; // AI is gunner.
if (_currentUnitIsGunner && _isRemoteControlled) exitWith {
    /* 
     * remoteControl is prone to game breaking errors, in mutliplayer so if the client 
     * is currently remote controlling the gunner, then do nothing and print an error message.
     */
    cutText [
        format [
            "<t color='#ff0000' font='PuristaBold' size='2'>%1</t>",
            LLSTRING(RemoteControlFailMessage)
        ],
        "PLAIN DOWN", 
        0.5, 
        false, 
        true
    ];
};

private _turretCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "MainTurret";
private _horRotSpeed = [_turretCfg,"maxHorizontalRotSpeed", nil] call BIS_fnc_returnConfigEntry;
private _turretAngularSpeed = 45 * (_horRotSpeed call BIS_fnc_parseNumber);         // degrees/sec
private _traverseDist = abs ([_vehicle, _target] call FUNC(getMainTurretAngleTo));  // Direction to target 0-180
private _traverseTime = 2 max ((_traverseDist / _turretAngularSpeed) * 2);          // * 2 for breathing room, should exit earlier than this.

private _dummy = createAgent ["B_RangeMaster_F", [-1000, -1000], [], 0, "NONE"];
_dummy disableAI "all";
_dummy enableAI "WEAPONAIM";
[_dummy, true] remoteExec ["hideObjectGlobal", 2];
_dummy allowDamage false;
private _cameraView = cameraView;
private _gunner = if (_currentUnitIsGunner) then {
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
    selectPlayer _dummy;
    _currentUnit switchCamera _cameraView;
    _currentUnit
} else {
    _dummy moveInGunner _vehicle;
    _dummy
};

_gunner setVariable [QGVAR(overrideInProgress), true, true];

// Setup a timeout for putting the player control back where it should be.
[
    {
        _this call FUNC(gunnerTargetReached);
    },
    [_currentUnit, _gunner, _dummy, _currentUnitIsGunner, _cameraView],
    _traverseTime
] call CBA_fnc_waitAndExecute;

// Command turret traversal
[
    {
        params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
        _gunner in _vehicle
    }, 
    {
        _this call FUNC(dummyDoWatch);
    },
    [_vehicle, _target, _gunner, _cameraView, _currentUnit, _currentUnitIsGunner, _traverseTime, _dummy],
    3,
    {
        // Cleanup if some problem occured
        params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
        [_currentUnit, _gunner, _dummy, _currentUnitIsGunner, _cameraView] call FUNC(gunnerTargetReached);
    }
] call CBA_fnc_waitUntilAndExecute;

