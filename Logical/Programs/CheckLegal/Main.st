
PROGRAM _INIT
	MoveLegal := FALSE;
	PlayerColor := WHITE_COLOR;
	gTest := FALSE;
END_PROGRAM

PROGRAM _CYCLIC
	IF gTest THEN

		MoveLegal := CanPlayerCapture(
		PlayerColor := PlayerColor,
		Board := gBoardBoard);

		gTest := FALSE;

	END_IF;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

