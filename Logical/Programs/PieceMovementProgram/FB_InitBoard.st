
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_InitBoard
	IF Execute THEN

		(* Wyczyszczenie planszy *)
		FOR Row := 1 TO 8 DO
			FOR Column := 1 TO 8 DO
				BoardBoard[Row, Column] := EMPTY;
			END_FOR;
		END_FOR;

		(* Ustawienie bia³ych pionków *)
		FOR Column := 1 TO 8 DO

			IF (Column MOD 2) = 1 THEN
				BoardBoard[1, Column] := WHITE;
				BoardBoard[3, Column] := WHITE;
			ELSE
				BoardBoard[2, Column] := WHITE;
			END_IF;

		END_FOR;

		(* Ustawienie czarnych pionków *)
		FOR Column := 1 TO 8 DO

			IF (Column MOD 2) = 0 THEN
				BoardBoard[6, Column] := BLACK;
				BoardBoard[8, Column] := BLACK;
			ELSE
				BoardBoard[7, Column] := BLACK;
			END_IF;

		END_FOR;
		
		GameState := WAITING_PLAYER;

		Done := TRUE;

	ELSE

		Done := FALSE;

	END_IF;
END_FUNCTION_BLOCK
