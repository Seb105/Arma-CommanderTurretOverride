#include "script_component.hpp"

params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
_gunner lookAt _target;
[{
    params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
    _traverseDist = abs ([_vehicle, _target] call FUNC(getMainTurretAngleTo));
    if (_traverseDist < 1) then {
        _gunner setVariable [
            QGVAR(timeOnTarget),
            _gunner getVariable [QGVAR(timeOnTarget), diag_tickTime]
        ];
        private _timeOnTarget = diag_tickTime - (_gunner getVariable QGVAR(timeOnTarget));
        _timeOnTarget > 0.5
    } else {
        _gunner setVariable [QGVAR(timeOnTarget), nil];
        false
    }
}, {
    _this call FUNC(gunnerTargetReached);
}, 
_this,
_traverseTime,
{
    // Timeout does the same thing as success, cleans up.
    _this call FUNC(gunnerTargetReached);
}] call CBA_fnc_waitUntilAndExecute;