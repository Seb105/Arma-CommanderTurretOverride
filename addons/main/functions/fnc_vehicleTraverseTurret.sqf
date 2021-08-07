#include "script_component.hpp"

params ["_vehicle", "_target"];

private _currentUnit = call CBA_fnc_currentUnit;
private _currentGunner = gunner _vehicle;
if (_currentGunner getVariable [QGVAR(overrideInProgress), false]) exitWith {};
private _hasGunner = !(isNull _currentGunner);
_currentUnitIsGunner = (_currentGunner == _currentUnit);
if (_hasGunner && !_currentUnitIsGunner) exitWith { _currentGunner lookAt _target }; // AI is gunner.

private _turretCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "MainTurret";
private _horRotSpeed = [_turretCfg,"maxHorizontalRotSpeed", nil] call BIS_fnc_returnConfigEntry;
private _turretAngularSpeed = 45 * (_horRotSpeed call BIS_fnc_parseNumber);     // degrees/sec
_traverseDist = abs ([_vehicle, _target] call TCO_fnc_getMainTurretAngleTo);    // Direction to target 0-180
private _traverseTime = 3 max (_traverseDist / _turretAngularSpeed) * 2;        // * 2 for breathing room, should exit earlier than this.

private _dummy = createAgent ["B_RangeMaster_F", [-1000, -1000], [], 0, "NONE"];
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
    _currentUnit setVariable [QGVAR(isRemoteControlled), player != _currentUnit];
    if (_currentUnit getVariable QGVAR(isRemoteControlled)) then {
        objNull remoteControl _currentUnit;
    } else {
        selectPlayer _dummy;
        _currentUnit switchCamera _cameraView;
    };
    
    _currentUnit
} else {
    _dummy moveInGunner _vehicle;
    _dummy
};

_gunner setVariable [QGVAR(overrideInProgress), true, true];

[{
    params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
    _gunner in _vehicle
}, {
    _this call FUNC(dummyDoWatch);
},
[_vehicle, _target, _gunner, _cameraView, _currentUnit, _currentUnitIsGunner, _traverseTime, _dummy],
3,
{
    // Cleanup if some problem occured
    _this call FUNC(gunnerTargetReached);
}] call CBA_fnc_waitUntilAndExecute;

