
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_MovePiece
	Piece := gBoardBoard[gCurrentMove.FromRow, gCurrentMove.FromColumn];
	gBoardBoard[gCurrentMove.ToRow, gCurrentMove.ToColumn] := Piece;
	gBoard[gCurrentMove.FromRow, gCurrentMove.FromColumn] := EMPTY;
	gMoveCounter := gMoveCounter + 1;
END_FUNCTION_BLOCK
