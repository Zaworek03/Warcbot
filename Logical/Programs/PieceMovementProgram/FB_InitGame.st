
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_InitGame
	IF Execute THEN

		MovesWithoutCapture := 0;
		PlayerColor := WHITE_COLOR;
		Winner := NONE;
		GameState := CHECKING_BOARD;

		Done := TRUE;

	ELSE
		Done := FALSE;
	END_IF;
END_FUNCTION_BLOCK
