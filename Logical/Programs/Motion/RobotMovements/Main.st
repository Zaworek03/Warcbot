
PROGRAM _INIT
	FOR row := 1 TO 8 DO
		FOR col := 1 TO 8 DO
			gPositionMatrix[row, col].X := (row - 1) * 50;
			gPositionMatrix[row, col].Y := (col - 1) * 50;
			gPositionMatrix[row, col].Z := 50;
		END_FOR
	END_FOR
END_PROGRAM

PROGRAM _CYCLIC
	instRobotMove(
		PickPiece := gPickPiece, 
		PickMove := gPickMove, 
		PositionMatrix := gPositionMatrix, 
		Motion := gMotionInterface
		);
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

