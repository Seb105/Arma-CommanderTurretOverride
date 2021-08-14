#include "script_component.hpp"

/*
 * Author: Seb
 * Cleans up, making sure the player is in the correct body and deleting the dummy at the end of a turret override.
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
 * _this call CTO_main_fnc_gunnerTargetReached
 *
 * Public: No
 */

params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
if (_currentUnitIsGunner) then {
    selectPlayer _currentUnit;
    QGVAR(overrideCutText) cutFadeOut 0.25;
    _currentUnit switchCamera _cameraView;
};
_gunner setVariable [QGVAR(timeOnTarget), nil];
_gunner setVariable [QGVAR(overrideInProgress), nil, true];
deleteVehicle _dummy;