
PROGRAM _INIT
	(* Insert code here *)
	(* Wyczyszczenie planszy *)
	gBoardBoard[2,2] := EMPTY;
	gBoardBoard[3,3] := EMPTY;

	(* Ustawienie bia³ego pionka *)
	gBoardBoard[2,2] := WHITE;

	(* Definicja ruchu *)
	gCurrentMove.FROM_ROW := 2;
	gCurrentMove.FROM_COLUMN := 2;

	gCurrentMove.TO_ROW := 3;
	gCurrentMove.TO_COLUMN := 3;

	MoveLegal := FALSE;

	gTest := FALSE;
END_PROGRAM

PROGRAM _CYCLIC
	IF gTest THEN

		Piece := gBoardBoard[
		gCurrentMove.FROM_ROW,
		gCurrentMove.FROM_COLUMN];

		MoveLegal := CheckRegularCapture(
		FromRow := gCurrentMove.FROM_ROW,
		FromColumn := gCurrentMove.FROM_COLUMN,
		ToRow := gCurrentMove.TO_ROW,
		ToColumn := gCurrentMove.TO_COLUMN,
		Piece := Piece,
		Board := gBoardBoard);

		gTest := FALSE;

	END_IF;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

