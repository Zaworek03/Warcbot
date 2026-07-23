
PROGRAM _INIT
	gStep := 7;
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
	
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gESTOP THEN
		CASE gStep OF
			Idle:
				IF gStart THEN
					gStep := PhotoCheck1;
				END_IF
				
			PhotoCheck1:
				CASE Vision OF
					0:
						IF gCameraEnd THEN
							FOR i := 1 TO 8 DO
								FOR j := 1 TO 8 DO
									CASE gBoardActual[i, j] OF
										1:  BoardConverted[i, j] := 1;
										2:  BoardConverted[i, j] := 2;
										3:  BoardConverted[i, j] := 1;
										4:  BoardConverted[i, j] := 2;
									END_CASE;
								END_FOR;
							END_FOR;
							Vision := 1;
						END_IF;

					1:
						Match := TRUE;
						FOR i := 1 TO 8 DO
							FOR j := 1 TO 8 DO
								IF BoardConverted[i, j] <> gBoardCamera[i, j] THEN
									Match := FALSE;
								END_IF;
							END_FOR;
						END_FOR;

						IF Match THEN
							BoardGit := TRUE;
							gStep := RobotMove;
							Vision := 0;
						ELSE
							gStep := CountPiece;
							Vision := 0;
						END_IF;

				END_CASE;
			CountPiece: ;
			
			ArrangeBoard: ;
			
			InncorrectBoard1:
				gAlarm.InncorrectBoard := 1;
			RobotMove: ;
			
			PhotoCheck2: ;
			
			InncorrectBoard2:
				gAlarm.InncorrectRobotMove := 1;
		
			WinOrLoseState: ;
		
		
		END_CASE
	END_IF
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

