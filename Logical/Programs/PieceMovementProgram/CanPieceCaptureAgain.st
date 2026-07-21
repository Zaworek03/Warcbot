
(* TODO: Add your comment here *)
FUNCTION CanPieceCaptureAgain
	CanPieceCaptureAgain := FALSE;

	CASE Piece OF

		WHITE:

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row + 2,
				ToColumn := Column + 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row + 2,
				ToColumn := Column - 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

		BLACK:

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row - 2,
				ToColumn := Column + 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row - 2,
				ToColumn := Column - 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			WHITE_KING,
		BLACK_KING:

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row + 2,
				ToColumn := Column + 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row + 2,
				ToColumn := Column - 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row - 2,
				ToColumn := Column + 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

			IF CheckRegularCapture(
				FromRow := Row,
				FromColumn := Column,
				ToRow := Row - 2,
				ToColumn := Column - 2,
				Piece := Piece,
				Board := Board) THEN

				CanPieceCaptureAgain := TRUE;
				RETURN;

			END_IF;

	END_CASE;
END_FUNCTION
