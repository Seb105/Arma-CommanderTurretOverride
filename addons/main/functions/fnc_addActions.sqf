#include "script_component.hpp"
/*
 * Author: Seb
 * Adds actions to allow the vehicle gunner to lock their turret and forbid commander override.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [vehicle player] call CTO_main_fnc_addActions
 *
 * Public: No
 */

params ["_vehicle"];

_vehicle addAction [
    LLSTRING(LockTurretControl),	// title
    {
        params ["_target", "_caller", "_actionId"]; // script
        _target setVariable [QGVAR(turretControlLocked), true, true];
    },
    nil,		// arguments
    1.5,		// priority
    true,		// showWindow
    true,		// hideOnUse
    "",			// shortcut
    "_this == gunner _originalTarget && !(_originalTarget getVariable ['CTO_main_turretControlLocked', false])", 	// condition
    5,			// radius
    false,		// unconscious
    "",			// selection
    ""			// memoryPoint
];

_vehicle addAction [
    LLSTRING(UnlockTurretControl),	// title
    {
        params ["_target", "_caller", "_actionId"]; // script
        _target setVariable [QGVAR(turretControlLocked), false, true];
    },
    nil,		// arguments
    1.5,		// priority
    true,		// showWindow
    true,		// hideOnUse
    "",			// shortcut
    "_this == gunner _originalTarget && (_originalTarget getVariable ['CTO_main_turretControlLocked', false])", 	// condition
    5,			// radius
    false,		// unconscious
    "",			// selection
    ""			// memoryPoint
];