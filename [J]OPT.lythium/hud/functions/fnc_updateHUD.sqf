﻿/**
* Author: James
* script for updating HUD information each forEachMember
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_updateHUD.sqf;
*
*/
#include "script_component.hpp"

disableSerialization;
private _currentCutDisplay = uiNamespace getVariable QGVAR(display);

waitUntil{ !isNil QEGVAR(serverclock,startTime)};

while {true} do {
        //--------------------- get settings on whether to display extra labels --------------
        
    //--------------------- update players ------------------------------------------
    private _control = _currentCutDisplay displayCtrl 5101;
    if (GVAR(numberPlayers)) then {

        private _playersStr = format ["Spieler: (N) %1 vs %2 (C)", playersNumber west, playersNumber east];

        // Anzeige updaten
        // Update Text
        _control ctrlSetText _playersStr;    
        _control ctrlShow true;

    } else {

        _control ctrlShow false;
    };

    //--------------------- update Frames ------------------------------------------
    _control = _currentCutDisplay displayCtrl 5102;
    if (GVAR(fps)) then {

        private _frameStr = format ["FPS: %1", round (diag_fps)];

        // Anzeige updaten
        // Update Text
        _control ctrlSetText _frameStr;
        _control ctrlShow true;

    } else {

        _control ctrlShow false;
    };

    //--------------------- update Budget ------------------------------------------
    _control = _currentCutDisplay displayCtrl 5103;
    if (GVAR(budget)) then {

        [_control] call EFUNC(common,renderBudget);
        _control ctrlShow true;

    } else {

        _control ctrlShow false;
    };

    //----------------------- update score --------------------------------------------
    _control = _currentCutDisplay displayCtrl 5104;
    if (GVAR(score)) then {
        
        private _scoreStr = format ["Punkte: (N) %1 : %2 (C)", GVARMAIN(nato_points), GVARMAIN(csat_points)];

        // Anzeige updaten
        // Update Text
        _control ctrlSetText _scoreStr;    
        _control ctrlShow true;

    } else {

        _control ctrlShow false;
    };

    //--------------------- update clock ---------------------------------------
    _control = _currentCutDisplay displayCtrl 5105;
    if (GVAR(timer)) then {
        
        // get time from server
        private _timeElapsed = serverTime - EGVAR(serverclock,startTime);

        private _freezeTime = EGVAR(serverclock,freezeTime) * 60 - _timeElapsed;
        private _truceTime = (EGVAR(serverclock,truceTime) + EGVAR(serverclock,freezeTime)) * 60 - _timeElapsed;
        private _playTime = (EGVAR(serverclock,playTime) + EGVAR(serverclock,freezeTime)) * 60 - _timeElapsed;

        private _timeStr = "";
        private _timeLeft = 0;

        //systemChat format["%1, %2, %3, %4", _timeElapsed, _freezeTime, _truceTime, _playTime];

        if (EGVAR(serverclock,freezeTime) > 0 and !EGVAR(serverclock,truceStarted)) then {
            _timeLeft = [_freezeTime] call CBA_fnc_formatElapsedTime;

            if (_freezeTime > 0) then {

                _timeStr = format ["Ruhephase: %1", _timeLeft];
                _control ctrlSetTextColor [0, 0, 0.7, 1];

            } else {

                _timeStr = "Ruhephase: 00:00";
                _control ctrlSetTextColor [0.7, 0.7, 0.7, 1];

            };

        };

        if (EGVAR(serverclock,truceStarted) and !EGVAR(serverclock,missionStarted)) then {
            _timeLeft = [_truceTime] call CBA_fnc_formatElapsedTime;

            if (_truceTime > 0) then {

                _timeStr = format ["Waffenruhe: %1", _timeLeft];
                _control ctrlSetTextColor [0.6, 0.1, 0, 1];

            } else {

                _timeStr = "Waffenruhe: 00:00";
                _control ctrlSetTextColor [0.7, 0.7, 0.7, 1];

            };

        };

        if (EGVAR(serverclock,missionStarted)) then {

            // Mission gestartet - Zeige verbleibende Spielzeit
            _timeLeft = [_playTime] call CBA_fnc_formatElapsedTime;

            if (_playTime > 0) then {

                _timeStr = format ["Rest-Spielzeit: %1", _timeLeft];
                _control ctrlSetTextColor [0.7, 0.7, 0.7, 1];

            } else {

                _timeStr = "Restspielzeit: 00:00";
                _control ctrlSetTextColor [1, 0, 0, 0.9];

            };
        };
        
        // Anzeige updaten
        // Update Text
        _control ctrlSetText _timeStr;
        // Färbe Uhr in den letzten 5 Minuten rot
        if (_playTime < 300) then {
            _control ctrlSetTextColor [0.9, 0.2, 0.2, 1];
        };

        _control ctrlShow true;

    } else {

        _control ctrlShow false;
    };

    sleep GVAR(updateInterval);
};