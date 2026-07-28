
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
	MpAuditTrail_0();
	
END_PROGRAM

PROGRAM _CYCLIC
	MpAuditTrail_0();
	
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
							(* Odwrócenie planszy do góry nogami, aby odczyt z kamry by³ zgodny z widokiem ze stania na wprost robota *)
							IF Convert[gBoardActual[BoardSpaces + 1 - i, BoardSpaces + 1 - j]] <> gBoardCamera[i, j] THEN
								Match := FALSE;
							END_IF;
						END_FOR;
					END_FOR;
					IF Match THEN
						BoardGit := TRUE;
						gStep := RobotMove;
					ELSE
						gAlarm.InncorrectBoard := TRUE;
						gStep := ErrorState;
					END_IF;
				END_IF;
					
			GameMove:
				(* Zaczêcie -> synga³ do silnika bool TRUE bez resetu
				   Zakoñczenie -> synga³ z silnika bool TRUE bez resetu
				   Po odbieorze sygna³u zakoñczenia, tu reset obu zmiennych*)
				;
					
			RobotMove:
				(* Patrz RobotMove::Main.st *);
			
			ErrorState:
				IF gAlarm.InncorrectBoard = FALSE THEN
					gStep := PhotoCheck;
				END_IF;
			
			EndState:
				;
		
		END_CASE
	ELSE
		;	
	END_IF
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

