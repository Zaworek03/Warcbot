PROGRAM _INIT

	WinOrLose;
	EndGame;
	gPlayerColor;
	gDifficultyLevel;
	gStart;
	gBoardActual;
	j;
	i;
	whiteOnBoard;
	blackOnBoard;
	gEnablePiece;

	gBoardLast := gBoardActual;
	firstScan := TRUE;
	MoveHistory[1] := '';
	MoveHistory[2] := '';
	MoveHistory[3] := '';
	MoveHistory[4] := '';
	LastMove := '';
	MoveCount := 0;

END_PROGRAM


PROGRAM _CYCLIC

	IF gStart THEN
		IF gGameStats.Load THEN
			MoveHistory := gGameStats.MoveHistory;
			MoveCount := gGameStats.MoveCount;
			gGameStats.Load := FALSE;
		END_IF;

		whiteOnBoard := 0;
		blackOnBoard := 0;

		FOR i := 1 TO 8 DO
			FOR j := 1 TO 8 DO
				CASE gBoardActual[i, j] OF
					1, 3:  whiteOnBoard := whiteOnBoard + 1;
					2, 4:  blackOnBoard := blackOnBoard + 1;
				END_CASE;
			END_FOR;
		END_FOR;

		DeadWhitePiece := 12 - whiteOnBoard;
		DeadBlackPiece := 12 - blackOnBoard;

		IF firstScan THEN
			gBoardLast := gBoardActual;
			firstScan := FALSE;
		ELSE
			fromRow := 0; fromCol := 0;
			toRow := 0;   toCol := 0;
			capCount := 0;
			movedColor := 0;

			FOR i := 1 TO 8 DO
				FOR j := 1 TO 8 DO
					IF gBoardLast[i, j] = 0 AND gBoardActual[i, j] <> 0 THEN
						toRow := i;
						toCol := j;
						IF gBoardActual[i, j] = 1 OR gBoardActual[i, j] = 3 THEN
							movedColor := 1;
						ELSE
							movedColor := 2;
						END_IF;
					END_IF;
				END_FOR;
			END_FOR;

			IF toRow <> 0 THEN
				FOR i := 1 TO 8 DO
					FOR j := 1 TO 8 DO
						IF gBoardLast[i, j] <> 0 AND gBoardActual[i, j] = 0 THEN
							IF gBoardLast[i, j] = 1 OR gBoardLast[i, j] = 3 THEN
								cellColor := 1;
							ELSE
								cellColor := 2;
							END_IF;

							IF cellColor = movedColor THEN
								fromRow := i;
								fromCol := j;
							ELSE
								capCount := capCount + 1;
							END_IF;
						END_IF;
					END_FOR;
				END_FOR;
			END_IF;

			IF toRow <> 0 AND fromRow <> 0 THEN
				
				gRobotMoveVar.StartPoint.x := fromCol;
				gRobotMoveVar.StartPoint.y := fromRow;
				gRobotMoveVar.EndPoint.x := toCol;
				gRobotMoveVar.EndPoint.y := toRow;
				gRobotMoveVar.RTRMove := TRUE;

				pChar ACCESS ADR(LastMove);
				pChar := 64 + fromCol;

				pChar ACCESS ADR(LastMove) + 1;
				pChar := 48 + fromRow;

				pChar ACCESS ADR(LastMove) + 2;
				IF capCount > 0 THEN
					pChar := 120;
					gRobotMoveVar.Capture := TRUE;
					gRobotMoveVar.DiscardPoint.x := (fromCol+toCol)/2;
					gRobotMoveVar.DiscardPoint.y := (fromRow+toRow)/2;
				ELSE
					pChar := 45;
					gRobotMoveVar.Capture := FALSE;
				END_IF;

				pChar ACCESS ADR(LastMove) + 3;
				pChar := 64 + toCol;

				pChar ACCESS ADR(LastMove) + 4;
				pChar := 48 + toRow;

				pChar ACCESS ADR(LastMove) + 5;
				pChar := 0;

				MoveHistory[4] := MoveHistory[3];
				MoveHistory[3] := MoveHistory[2];
				MoveHistory[2] := MoveHistory[1];
				MoveHistory[1] := LastMove;

				MoveCount := MoveCount + 1;

				(* --- AUDIT: kto wykonal ruch i dokad --- *)
				IF movedColor = gPlayerColor THEN
					brsstrcpy(ADR(auditTmp), ADR('Gracz wykonal ruch: '));
				ELSE
					brsstrcpy(ADR(auditTmp), ADR('Robot wykonal ruch: '));
				END_IF;
				brsstrcat(ADR(auditTmp), ADR(LastMove));

				MessageVar := STRING_TO_WSTRING(auditTmp);
				TypeVar    := "GameMove";
				CommentVar := "";

				MpAuditCustomEvent(gAuditTrail, TypeVar, MessageVar, CommentVar);
				(* --- koniec AUDIT --- *)

				gGameStats.MoveHistory := MoveHistory;
				gGameStats.MoveCount := MoveCount;
			END_IF;

			gBoardLast := gBoardActual;
		END_IF;

	ELSE
		DeadWhitePiece := 0;
		DeadBlackPiece := 0;
		whiteOnBoard := 0;
		blackOnBoard := 0;
		MoveCount := 0;
		LastMove := '';
		MoveHistory[1] := '';
		MoveHistory[2] := '';
		MoveHistory[3] := '';
		MoveHistory[4] := '';
		firstScan := TRUE;
		gBoardLast := gBoardActual;
	END_IF

END_PROGRAM


PROGRAM _EXIT
    (* Insert code here *)

END_PROGRAM