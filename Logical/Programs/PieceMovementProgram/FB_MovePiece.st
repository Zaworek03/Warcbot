FUNCTION_BLOCK FB_MovePiece
	
	IF Execute THEN
		(* Zast¹p gBoardBoard przez Board *)
		Piece := Board[FromRow, FromColumn];
		Board[ToRow, ToColumn] := Piece;
		Board[FromRow, FromColumn] := EMPTY;
		Done := TRUE;
	END_IF;
	
END_FUNCTION_BLOCK
