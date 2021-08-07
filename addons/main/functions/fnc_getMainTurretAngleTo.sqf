#include "script_component.hpp"

params ["_vehicle", "_target"];
private _gunDirRel = [_vehicle] call FUNC(getMainTurretDir);
private _dirTo = _vehicle getRelDir _target;                    //  0....360
_dirTo = if (_dirTo > 180) then {_dirTo - 360} else {_dirTo};   // -180..180
_gunDirRel - _dirTo