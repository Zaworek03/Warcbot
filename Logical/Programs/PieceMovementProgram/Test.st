PROGRAM _INIT
	
	gBoardBoard[2,2] := WHITE;

	gCurrentMove.FROM_ROW := 2;
	gCurrentMove.FROM_COLUMN := 2;

	gCurrentMove.TO_ROW := 3;
	gCurrentMove.TO_COLUMN := 3;

	gMoveCounter := 0;
	
	gTest := FALSE;
	gHumanColor := FALSE;
	
END_PROGRAM


PROGRAM _CYCLIC

	IF gTest THEN
		bStartMove := TRUE;
		gTest := FALSE;
	END_IF;

	instMovePiece(
	Execute := bStartMove, 
	FromRow := gCurrentMove.FROM_ROW, 
	FromColumn := gCurrentMove.FROM_COLUMN, 
	ToRow := gCurrentMove.TO_ROW, 
	ToColumn := gCurrentMove.TO_COLUMN, 
	Piece := gPiece, 
	Board := gBoardBoard,       
	MoveCounter := gMoveCounter  
	);

	IF instMovePiece.Done THEN
		bStartMove := FALSE;
	END_IF;

END_PROGRAM


PROGRAM _EXIT

END_PROGRAM
