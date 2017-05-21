params ["_budget_field"];

private _side = playerSide;
private _side_Budget = if (_side == west) then {opt_west_budget} else {opt_east_budget};

private _txt = if (_side_Budget > 1e6-1) then {
	format ["Budget: %1 Mio. €", str(_side_Budget / 1e6)];	// psycho: budget muss numerisch reduziert werden um Darstellung aufrecht zu erhalten
} else {
	format ["Budget: %1 €", str(_side_Budget)];
};

// Warnung, wenn Budget niedrig wird
if (_side_Budget < 4e5) then {
	_budget_field ctrlSetTextColor [0.97, 0.63, 0.02, 1];
};

// Falls Budget negativ: Zeige Dispo
if (_side_Budget < 0) then {
	_txt = format["Dispo: %1 €", str(_side_Budget)];
	_budget_field ctrlSetTextColor [1,0,0,1];
};

_budget_field ctrlSetText _txt;