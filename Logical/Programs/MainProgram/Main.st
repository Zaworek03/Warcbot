PROGRAM _INIT
	gAlarm;
	gESTOP;
	gStart;
	gBoardCamera;
	BoardConverted;
	BoardGit := FALSE;
	Match;
	gCameraEnd;
	Vision;
	
	i;
	j;
	
	MpAuditTrail_0.Enable := TRUE; 
	MpAuditTrail_0.MpLink := ADR(gAuditTrail); 
	MpAuditTrail_0.DeviceName := ADR('AUDIT'); 
	MpAuditTrail_0.FileName := ADR('AuditList'); 
	
	
	 
END_PROGRAM

PROGRAM _CYCLIC
	MpAuditTrail_0();
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

