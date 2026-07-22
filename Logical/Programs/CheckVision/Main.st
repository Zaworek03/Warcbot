
PROGRAM _INIT
	gBoardActual;
	Vision;
	OUT := FALSE;

	Match;
	i;
	j;
	
	Vision.Step := ConvertTable;
	Vision.PhotoTake := FALSE;
END_PROGRAM

PROGRAM _CYCLIC

	CASE Vision.Step OF

		ConvertTable:
			FOR i := 1 TO 8 DO
				FOR j := 1 TO 8 DO
					CASE gBoardActual[i, j] OF
						1:  Vision.BoardConverted[i, j] := 1;
						2:  Vision.BoardConverted[i, j] := 2;
						3:  Vision.BoardConverted[i, j] := 1;
						4:  Vision.BoardConverted[i, j] := 2;
					END_CASE;
				END_FOR;
			END_FOR;

			IF Vision.PhotoTake THEN
				Vision.Step := CheckTable;
			END_IF;

		CheckTable:
			Match := TRUE;
			FOR i := 1 TO 8 DO
				FOR j := 1 TO 8 DO
					IF Vision.BoardConverted[i, j] <> Vision.BoardVision[i, j] THEN
						Match := FALSE;
					END_IF;
				END_FOR;
			END_FOR;

			IF Match THEN
				OUT := TRUE;
				Vision.Step := ConvertTable;
			ELSE
				Vision.Step := ConvertTable;
			END_IF;

	END_CASE

END_PROGRAM


PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

