FUNCTION_BLOCK FB_MovePiece

	VAR_INPUT
		Execute : BOOL;
		FromRow : INT;
		FromColumn : INT;
		ToRow : INT;
		ToColumn : INT;
		Piece : PieceTypeEnum; (* Dodaj to tutaj! *)
	END_VAR

	VAR_IN_OUT
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
		MoveCounter : INT;
	END_VAR

	VAR_OUTPUT
		Done : BOOL; (* Teraz Done jest poprawnym wyjœciem *)
	END_VAR
	
END_FUNCTION_BLOCK
