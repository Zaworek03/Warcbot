
PROGRAM _INIT
	gTrudnosc := 0;
	gBoard[0,1] := 2;
	gBoard[0,3] := 2;
	gBoard[0,5] := 2;
	gBoard[0,7] := 2;
	
	gBoard[1,0] := 2;
	gBoard[1,2] := 2;
	gBoard[1,4] := 2;
	gBoard[1,6] := 2;
	
	gBoard[2,1] := 2;
	gBoard[2,3] := 2;
	gBoard[2,5] := 2;
	gBoard[2,7] := 2;
	
	gBoard[5,0] := 1;
	gBoard[5,2] := 1;
	gBoard[5,4] := 1;
	gBoard[5,6] := 1;
	
	gBoard[6,1] := 1;
	gBoard[6,3] := 1;
	gBoard[6,5] := 1;
	gBoard[6,7] := 1;
	
	gBoard[7,0] := 1;
	gBoard[7,2] := 1;
	gBoard[7,4] := 1;
	gBoard[7,6] := 1;
	gGraStart := FALSE;
	gJakiKolor := FALSE;

	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	gTest;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

