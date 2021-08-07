#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if !(hasInterface) exitWith {};

[
    LLSTRING(CommanderTurretOverride), 
    QGVAR(commanderDesignateKey),
    LLSTRING(CommanderTurretOverrideKey_Display),
    {
        0 = call FUNC(commanderDesignate);
    },
    "",
    [DIK_T, [false, false, true]]
] call CBA_fnc_addKeybind;