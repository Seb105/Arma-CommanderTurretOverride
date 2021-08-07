#include "script_component.hpp"

_currentUnit = call CBA_fnc_currentUnit;
private _vehicle = vehicle _currentUnit;

// Ensure current vehicle supports 
if (_vehicle isEqualTo _currentUnit) exitWith {};
if !(_currentUnit isEqualTo commander _vehicle) exitWith {};
if !(_vehicle call FUNC(vehicleHasTurretOverride)) exitWith {};

private _camPos = eyePos _currentUnit;
private _target = (lineIntersectsSurfaces [
    _camPos, 
    AGLToASL screenToWorld [0.5,0.5],
    _currentUnit,
    _vehicle,
    true,
    1,
    "FIRE",
    "VIEW"
] select 0) select 0;

if (isNil "_target") then {
    _target = cursorObject;
    if (isNull _target) then {
        _target = screenToWorld [0.5,0.5]
    };
} else {
    _target = ASLtoAGL _target;
};
private _gunner = gunner vehicle _currentUnit;
private _turretLocal = if (isNull _gunner) then {
    _vehicle
} else {
    _gunner
};

[_vehicle, _target] remoteExecCall [QFUNC(vehicleTraverseTurret), _turretLocal];