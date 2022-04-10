private _support = createTrigger ["EmptyDetector", getPos player, true];
_support setTriggerText "Rearm Aircraft";
_support setTriggerActivation ["CHARLIE", "NOT PRESENT", false];
_support setTriggerStatements ["this", "0 = execVM 'refill.sqf'",""];