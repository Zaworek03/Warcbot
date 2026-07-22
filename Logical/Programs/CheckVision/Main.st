
PROGRAM _INIT
	gBoardActual;
	BoardConverted;
	 
	i;
	j;
END_PROGRAM

PROGRAM _CYCLIC
	
	FOR i := 1 TO 8 DO
		FOR j := 1 TO 8 DO
			CASE gBoardActual[i, j] OF
				1:  BoardConverted[i, j] := 1;
				2:	BoardConverted[i, j] := 2; 
				3:  BoardConverted[i, j] := 1;
				4:  BoardConverted[i, j] := 2;
			END_CASE;
		END_FOR;
	END_FOR;	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

