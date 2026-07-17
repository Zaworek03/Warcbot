
PROGRAM _INIT
	bEnable := FALSE;
	bTrigger := FALSE;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF NOT bEnable THEN
		bTrigger := FALSE;
	END_IF;
    
	IF bTrigger AND bAcquisitionDone THEN
		bTrigger := FALSE; 
	END_IF;

	IF bCameraAlarm > 0 THEN
		
	END_IF;
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

