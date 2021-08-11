#include "script_component.hpp"
params ["_vehicle", "_target", "_gunner", "_cameraView", "_currentUnit", "_currentUnitIsGunner", "_traverseTime", "_dummy"];
if (_currentUnitIsGunner) then {
    selectPlayer _currentUnit;
    QGVAR(overrideCutText) cutFadeOut 0.25;
    _currentUnit switchCamera _cameraView;
};
_gunner setVariable [QGVAR(timeOnTarget), nil];
_gunner setVariable [QGVAR(overrideInProgress), nil, true];
deleteVehicle _dummy;