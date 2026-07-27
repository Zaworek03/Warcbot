
PROGRAM _INIT
	gStep := Idle;
	gAlarm;
	gESTOP;
	gStart;
	gBoardCamera;
	BoardConverted;
	BoardGit := FALSE;
	Match;
	gCameraEnd;
	RobotMoveMarker;
	
	i;
	j;
	
	MpAuditTrail_0.Enable := TRUE; 
	MpAuditTrail_0.MpLink := ADR(gAuditTrail); 
	MpAuditTrail_0.DeviceName := ADR('AUDIT'); 
	MpAuditTrail_0.FileName := ADR('AuditList'); 
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF TRUE THEN
		CASE gStep OF
			Idle:
				IF gStart THEN
					gStep := PhotoCheck;
				END_IF
				
			PhotoCheck:
				gCameraTrigger := TRUE;
				IF gCameraEnd THEN
					gCameraTrigger := FALSE;
					Match := TRUE;
					FOR i := 1 TO BoardSpaces DO
						FOR j := 1 TO BoardSpaces DO
							IF Convert[gBoardActual[BoardSpaces + 1 - i, BoardSpaces + 1 - j]] <> gBoardCamera[i, j] THEN
								Match := FALSE;
							END_IF;
						END_FOR;
					END_FOR;
					IF Match THEN
						BoardGit := TRUE;
						gStep := RobotMove;
					ELSE
						gAlarm.InncorrectBoard := 1;
						gStep := Idle;
					END_IF;
				END_IF;
					
			GameMove:
				;
					
			RobotMove:
				;
		
		END_CASE
	ELSE
		;	
	END_IF
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

