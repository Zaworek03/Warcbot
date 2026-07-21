
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_PromotePiece
	
	IF Execute THEN

		CASE Board[Row, Column] OF

			WHITE:

				IF Row = 8 THEN
					Board[Row, Column] := WHITE_KING;
				END_IF;

			BLACK:

				IF Row = 1 THEN
					Board[Row, Column] := BLACK_KING;
				END_IF;

		END_CASE;

		Done := TRUE;

	ELSE

		Done := FALSE;

	END_IF;
	
END_FUNCTION_BLOCK
