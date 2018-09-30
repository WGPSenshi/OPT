/**
* Author: James
* open beam dialog
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_openDialog.sqf;
*
*/
#include "script_component.hpp"

private _cond = (
    !dialog and 
    !(player getVariable ["ace_dragging_isDragging", false]) and 
    !(player getVariable ["ace_dragging_isCarrying", false])
);

if (_cond) then {
    createDialog "DialogBeam";
};