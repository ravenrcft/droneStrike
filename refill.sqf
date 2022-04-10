hintSilent "Rearming \nRefueling \nRepairing ";

Drone1 setFuel 1;
Drone1 setVehicleAmmo 1;
Drone1 setDamage 0;


////////////////

sleep 10;

support = createTrigger ["EmptyDetector", getPos player, true];
support setTriggerText "Rearm Aircraft";
support setTriggerActivation ["CHARLIE", "NOT PRESENT", false];
support setTriggerStatements ["this", "0 = execVM 'refill.sqf'",""];