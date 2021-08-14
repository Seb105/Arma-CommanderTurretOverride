#include "script_component.hpp"

/*
 * Author: Seb
 * Makes the current gunner look at the given target. Call exit function when target is reached.
 *
 * Arguments:
 * 0: Vehicle doing the traversal <OBJECT>
 * 1: Target to traverse to <OBJECT, posAGL>
 * 2: Gunner: this may be a dummy or a player <OBJECT>
 * 3: CameraView the cameraview of the client when the turret started traversing <STRING>
 * 4: The current unit the client is controlling <OBJECT>
 * 5: Is the current unit the gunner of this vehicle? <BOOL>
 * 6: The maximum amount of time it should take for the turret to reach its target <NUMBER>
 * 7: Dummy unit created to either store the player, or move into the vehicle and traverse the turret <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * _this call CTO_main_fnc_dummyDoWatch
 *
 * Public: No
 */

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