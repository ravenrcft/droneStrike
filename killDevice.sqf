private _towns = nearestLocations [getPosATL player, ["NameVillage","NameCity","NameCityCapital"], 25000];
private _startPos = selectRandom _towns;
private _idArray = _towns find _startPos;
_towns deleteAt _idArray;


private _center = (position _startPos);
private _minDist = 0;
private _maxDist = 200;
private _objDist = 10;
private _waterMode = 0;
private _maxGrad = 0.25;
private _shoreMode = 0;
private _blacklistPos = [];
private _defaultPos = [[0,0,0],[0,0,0]];

private _startPos = [_center, _minDist, _maxDist, _objDist, _waterMode, _maxGrad, _shoreMode, _blacklistPos, _defaultPos] call BIS_fnc_findSafePos;


// Spawn Enemy Vehicle with crew and officer
private	_vehicleArray = ["O_MRAP_02_F","O_LSV_02_AT_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_LSV_02_armed_F","O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_02_transport_F","O_Truck_02_covered_F"];
private _device = (selectRandom _vehicleArray) createVehicle _startPos;
private _group = createVehicleCrew _device;
//private _unit = _group createUnit ["O_officer_F", _startPos, [], 2, "NONE"];
//_unit moveInAny _device;


// Create waypoints
private _wp = _group addWaypoint [_startPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 50;

for [{private _i = 0}, {_i < 2}, {_i = _i + 1}] do {
	_randomPos = selectRandom _towns;
	_idArray = _towns find _randomPos;
	_towns deleteAt _idArray;

	_wp = _group addWaypoint [position _randomPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 50;
};

private _wp = _group addWaypoint [_startPos, 0];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius 50;

// Junk for random Task ID
private _suffixArray = ["a","b","d","e","f","g","h","i","j","k","l","m","n","o","p",'q',"r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
private _taskID = "killDevice_" + (selectRandom _suffixArray) + (selectRandom _suffixArray) + (selectRandom _suffixArray);
private _taskExists = [_taskID] call BIS_fnc_taskExists;
if (_taskExists) then {[_taskID] call BIS_fnc_deleteTask;};

// Create objective and assign to player
private _owner = west;
private _description = ["Kill the moving vehicle", "Kill Vehicle", ""];
private _destination = getPosASL _device;
private _state = "AUTOASSIGNED";
private _priority = 0;
private _showNote = true;
private _type = "destroy";
private _3D = true;

[_owner, _taskID, _description, _destination, _state, _priority, _showNote, _type, _3D] call BIS_fnc_taskCreate;
[_taskID, [_device, true]] call BIS_fnc_taskSetDestination;


////////////////////////////////////////////////////////////
// TRIGGER

waitUntil {sleep 3; !alive _device};
[_taskID,'SUCCEEDED'] call BIS_fnc_taskSetState;

sleep 1;
private _restart = createTrigger ["EmptyDetector", getPos player, true];
_restart setTriggerText "New Task";
_restart setTriggerActivation ["ALPHA", "NOT PRESENT", false];
_restart setTriggerStatements ["this", "0 = execVM 'killDevice.sqf'",""];