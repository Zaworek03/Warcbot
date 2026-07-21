PROGRAM _INIT
	
	bInitGame := FALSE;
	bInitBoard := FALSE;
	bMovePiece := FALSE;
	bTest := FALSE;
		

END_PROGRAM


PROGRAM _CYCLIC

	instInitGame(
		Execute := bInitGame, 
		MovesWithoutCapture := gMovesWithoutCapture,
		PlayerColor := gPlayerColor, 
		Winner := gWinner,       
		GameState := gGameState  
	);
	
	instInitBoard(
		Execute := bInitBoard, 
		BoardBoard := gBoardBoard,
		GameState := gGameState  
	);		
	
	instMovePiece(
		Execute := bMovePiece,
		FromRow := gCurrentMove.FROM_ROW, 
		FromColumn := gCurrentMove.FROM_COLUMN,
		ToRow := gCurrentMove.TO_ROW,
		ToColumn := gCurrentMove.TO_COLUMN,
		Board := gBoardBoard
	);
	
	IF instMovePiece.Done THEN
		bMovePiece := FALSE; (* Wy³¹czamy trigger, aby nie wykonaæ ruchu ponownie w nastêpnym cyklu *)
	END_IF;
	
	instPromotePiece(
		Execute := TRUE,
		Row := gCurrentMove.TO_ROW,
		Column := gCurrentMove.TO_COLUMN,
		Board := gBoardBoard
	);
	
	IF bTest THEN
		
		stCurrentPiece := gBoardBoard[gCurrentMove.TO_ROW, gCurrentMove.TO_COLUMN];
		
		bCanCaptureAgain := CanPieceCaptureAgain(
		Row := gCurrentMove.TO_ROW,      (* Nowy wiersz po ruchu *)
		Column := gCurrentMove.TO_COLUMN,   (* Nowa kolumna po ruchu *)
		Piece := stCurrentPiece,
		Board := gBoardBoard
		);
		
	END_IF;		

END_PROGRAM


PROGRAM _EXIT

END_PROGRAM
