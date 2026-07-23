
PROGRAM _INIT
	gStep;
	gAlarm;
	gESTOP;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	CASE gStep OF
		Idle:
			IF gStart THEN
				gStep := PhotoCheck1;
			END_IF
		PhotoCheck1:
			
		CountPiece:
			
		ArrangeBoard:
			
		InncorrectBoard1:
			gAlarm.InncorrectBoard := 1;
		RobotMove:
			
		PhotoCheck2:
			
		InncorrectBoard2:
			gAlarm.InncorrectRobotMove := 1;
		
		WinOrLose:
		
		
	END_CASE
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

