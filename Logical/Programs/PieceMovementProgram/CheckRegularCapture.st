
(* TODO: Add your comment here *)
FUNCTION CheckRegularCapture
	
	CheckRegularCapture := FALSE;

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

			IF (RowDiff = 2) AND
				((ColDiff = 2) OR (ColDiff = -2)) THEN

				MiddleRow := FromRow + 1;
				MiddleColumn := FromColumn + (ColDiff / 2);

				MiddlePiece := Board[MiddleRow, MiddleColumn];

				IF (MiddlePiece = BLACK) OR
					(MiddlePiece = BLACK_KING) THEN
					CheckRegularCapture := TRUE;
				END_IF;

			END_IF;

		BLACK:

			IF (RowDiff = -2) AND
				((ColDiff = 2) OR (ColDiff = -2)) THEN

				MiddleRow := FromRow - 1;
				MiddleColumn := FromColumn + (ColDiff / 2);

				MiddlePiece := Board[MiddleRow, MiddleColumn];

				IF (MiddlePiece = WHITE) OR
					(MiddlePiece = WHITE_KING) THEN
					CheckRegularCapture := TRUE;
				END_IF;

			END_IF;
		
			WHITE_KING,
		BLACK_KING:

			IF ((RowDiff = 2) OR (RowDiff = -2)) AND
				((ColDiff = 2) OR (ColDiff = -2)) THEN

				MiddleRow := (FromRow + ToRow) / 2;
				MiddleColumn := (FromColumn + ToColumn) / 2;

				MiddlePiece := Board[MiddleRow, MiddleColumn];

				IF ((Piece = WHITE_KING) AND
					((MiddlePiece = BLACK) OR (MiddlePiece = BLACK_KING)))
					OR
					((Piece = BLACK_KING) AND
					((MiddlePiece = WHITE) OR (MiddlePiece = WHITE_KING))) THEN

					CheckRegularCapture := TRUE;

				END_IF;

			END_IF;

	END_CASE;
	
END_FUNCTION
