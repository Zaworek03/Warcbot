
PROGRAM _INIT
	WinOrLose;
	EndGame;
	gPlayerColor;
	gDifficultyLevel;
	gStart;
	gBoardActual;
	j;
	i;
	whiteOnBoard;
	blackOnBoard;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gStart THEN
		whiteOnBoard := 0;
		blackOnBoard := 0;

		FOR i := 1 TO 8 DO
			FOR j := 1 TO 8 DO
				CASE gBoardActual[i, j] OF
					1, 3:  whiteOnBoard := whiteOnBoard + 1;
					2, 4:  blackOnBoard := blackOnBoard + 1;
				END_CASE;
			END_FOR;
		END_FOR;

		DeadWhitePiece := 12 - whiteOnBoard;
		DeadBlackPiece := 12 - blackOnBoard;
	END_IF

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

