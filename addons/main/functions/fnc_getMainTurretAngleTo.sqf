#include "script_component.hpp"

/*
 * Author: Seb
 * Like getRelDir, but for the main turret.
 *
 * Arguments:
 * 0: Vehicle doing the traversal <OBJECT>
 * 1: Target to traverse to <OBJECT, posAGL>
 *
 * Return Value:
 * Direction to garget -180..180 <NUMBER>
 *
 * Example:
 * [vehicle player, [3000, 3000 ,0]] call CTO_main_fnc_getMainTurretAngleTo
 *
 * Public: No
 */

params ["_vehicle", "_target"];
private _gunDirRel = [_vehicle] call FUNC(getMainTurretDir);
private _dirTo = _vehicle getRelDir _target;                    //  0....360
_dirTo = if (_dirTo > 180) then {_dirTo - 360} else {_dirTo};   // -180..180
_gunDirRel - _dirTo