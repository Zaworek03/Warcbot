
(* TODO: Add your comment here *)
FUNCTION CheckMove
	
	CheckMove := FALSE;

	(* Sprawdzenie zakresu planszy *)
	IF (FromRow < 1) OR (FromRow > 8) OR
		(FromColumn < 1) OR (FromColumn > 8) OR
		(ToRow < 1) OR (ToRow > 8) OR
		(ToColumn < 1) OR (ToColumn > 8) THEN
		RETURN;
	END_IF;

	(* Pole pocz¹tkowe nie mo¿e byæ puste *)
	IF Piece = EMPTY THEN
		RETURN;
	END_IF;

	(* Pole docelowe musi byæ puste *)
	IF Board[ToRow, ToColumn] <> EMPTY THEN
		RETURN;
	END_IF;

	RowDiff := ToRow - FromRow;
	ColDiff := ToColumn - FromColumn;

	CASE Piece OF

		WHITE:

			IF (RowDiff = 1) AND
				((ColDiff = 1) OR (ColDiff = -1)) THEN
				CheckMove := TRUE;
			END_IF;

		BLACK:

			IF (RowDiff = -1) AND
				((ColDiff = 1) OR (ColDiff = -1)) THEN
				CheckMove := TRUE;
			END_IF;
			
		WHITE_KING,
		BLACK_KING:

			IF ((RowDiff = 1) OR (RowDiff = -1)) AND
				((ColDiff = 1) OR (ColDiff = -1)) THEN
				CheckMove := TRUE;
			END_IF;
		
	END_CASE;
	
END_FUNCTION
