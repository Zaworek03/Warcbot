
PROGRAM _INIT

	FOR i := 0 TO 63 DO
		gBoard[i] := 0;
	END_FOR;
	gBoard[0] := 2;
	gBoard[2] := 2;
	gBoard[4] := 2;
	gBoard[6] := 2;

	gBoard[9] := 2;
	gBoard[11] := 2;
	gBoard[13] := 2;
	gBoard[15] := 2;

	gBoard[16] := 2;
	gBoard[18] := 2;
	gBoard[20] := 2;
	gBoard[22] := 2;

	gBoard[41] := 1;
	gBoard[43] := 1;
	gBoard[45] := 1;
	gBoard[47] := 1;

	gBoard[48] := 1;
	gBoard[50] := 1;
	gBoard[52] := 1;
	gBoard[54] := 1;

	gBoard[57] := 1;
	gBoard[59] := 1;
	gBoard[61] := 1;
	gBoard[63] := 1;
	gGraStart := FALSE;
	gJakiKolor := FALSE;
	gCzyjaTura := 1;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	gTest;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

