
PROGRAM _INIT
	gStep := 7;
	gAlarm;
	gESTOP;
	gStart;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gESTOP THEN
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
		
			WinOrLoseState:
		
		
		END_CASE
	END_IF
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

