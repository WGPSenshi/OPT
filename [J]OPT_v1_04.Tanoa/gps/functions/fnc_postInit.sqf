/**
* Author: James
* initialize gps system and all variables
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_postInit.sqf;
*
*/
#include "script_component.hpp"

GVAR(mode) = 0;

#ifdef __SHOW_ALL_UNITS__
    if (OPT_PARAM_SHOW_ALL_UNITS == 1) then {
        GVAR(showAll) = true;
    } else {
        GVAR(showAll) = false;
    };
#endif

//Modus
//_all=Schalter;
if (leader player == player) then {
    GVAR(mode)=1;
};
if (((player isKindOf "OPT_NATO_Offizier_T") or (player isKindOf "OPT_CSAT_Offizier_T")) and GVAR(showAll)) then {
    GVAR(mode)=2;
};
	
GVAR(eh_map) = addMissionEventHandler ["Map", {
    params ["_mapIsOpened", "_mapIsForced"];
    if (_mapIsOpened) then {
        // no sheduled environment -> create one
        /* Triggered when map is opened or closed either by user action or script command openMap. */
        [] spawn {
            waitUntil{ [] call FUNC(updateMarker); not visibleMap};
        };
    };
}];

// delete old marker if unit disconnects
if (isServer) then {
    GVAR(eh_PlayerDisconnected) = addMissionEventHandler ["PlayerDisconnected", {
        /*
            id: Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
            uid: String - getPlayerUID of the leaving client. The same as Steam ID (same as _uid param)
            name: String - profileName of the leaving client (same as _name param)
            jip: Boolean - didJIP of the leaving client (same as _jip param)
            owner: Number - owner id of the leaving client (same as _owner param)
        */
        params ["_id", "_uid", "_name", "_jip", "_owner"];

        private _marker =  format["%1_%2", QGVAR(unitMarker), _name];
        private _id = allMapMarkers find _marker;
        if (_id != -1) then {
            deleteMarker _marker;

        };
    }];
};