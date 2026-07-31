PROGRAM _INIT
	gStep := Idle;
	BoardGit := FALSE;

	MpAuditTrail_0.Enable := TRUE; 
	MpAuditTrail_0.MpLink := ADR(gAuditTrail); 
	MpAuditTrail_0.DeviceName := ADR('AUDIT'); 
	MpAuditTrail_0.FileName := ADR('AuditList'); 
	MpAuditTrail_0();
END_PROGRAM

PROGRAM _CYCLIC
	MpAuditTrail_0();
	
	gStop := NOT gStart;
	
	IF gESTOP = FALSE THEN
		gMotionInterface.Enable := FALSE;
	END_IF;

	IF gStart = FALSE THEN
		gStep := Idle;
		gRobotMoveVar.RTRMove := FALSE;
		MoveStep := IdleRM;
	END_IF;
		
	CASE gStep OF
		Idle:
			IF gStart THEN
				SetBoardTrigger := TRUE;
				gStep := ResetRobotPos;
				SetBoardStep := SetBoardBusy;
				gMotionInterface.Enable := TRUE;
				gMotionInterface.RequestManualMode := FALSE;
			END_IF;
				
		PhotoCheck:
			gCameraTrigger := TRUE;
			IF gCameraEnd THEN
				gCameraTrigger := FALSE;
				Match := TRUE;
				DrawCount := 0;
				DiscardCount := 0;
				ColorCount[1] := 0;
				ColorCount[2] := 0;
				
				FOR i := 1 TO BOARD_SPACES DO
					FOR j := 1 TO BOARD_SPACES DO
						(* Odwrócenie planszy do góry nogami, aby odczyt z kamery by³ zgodny z widokiem ze stania na wprost robota *)
						SimBoardValue := CONVERT_BOARD[gBoardActual[i, j]];
						CameraBoardValue := gBoardCamera[BOARD_SPACES + 1 - i, BOARD_SPACES + 1 - j];
						
						ColorCount[CameraBoardValue] := ColorCount[CameraBoardValue] + 1;
						
						IF SimBoardValue <> CameraBoardValue THEN
							Match := FALSE;
							
							IF SetBoardTrigger THEN
								IF CameraBoardValue = 0 THEN
									(* Inkrementujemy najpierw, aby zacz¹æ od indeksu 1 *)
									DrawCount := DrawCount + 1;
									PiecesToDraw[DrawCount].Index.x := i;
									PiecesToDraw[DrawCount].Index.y := j;
									PiecesToDraw[DrawCount].Color := SimBoardValue;
								ELSIF SimBoardValue = 0 THEN
									(* Inkrementujemy najpierw, aby zacz¹æ od indeksu 1 *)
									DiscardCount := DiscardCount + 1;
									PiecesToDiscard[DiscardCount].Index.x := i;
									PiecesToDiscard[DiscardCount].Index.y := j;
									PiecesToDiscard[DiscardCount].Color := CameraBoardValue;
								ELSE
									(* Zarówno w symulacji, jak i w kamerze jest pionek, ale RÓ¯NYCH KOLORÓW -> ZAMIANA! *)
									(* 1. Najpierw usuwamy to, co fizycznie stoi na planszy (widzi to kamera) *)
									DiscardCount := DiscardCount + 1;
									PiecesToDiscard[DiscardCount].Index.x := i;
									PiecesToDiscard[DiscardCount].Index.y := j;
									PiecesToDiscard[DiscardCount].Color := CameraBoardValue;
                    
									(* 2. Nastêpnie stawiamy to, co powinno tam byæ zgodnie z symulacj¹ *)
									DrawCount := DrawCount + 1;
									PiecesToDraw[DrawCount].Index.x := i;
									PiecesToDraw[DrawCount].Index.y := j;
									PiecesToDraw[DrawCount].Color := SimBoardValue;
								END_IF;
							END_IF;
						END_IF;
					END_FOR;
				END_FOR;
				
				IF Match THEN
					BoardGit := TRUE;
					gStep := GameMove;
				ELSE
					IF SetBoardTrigger THEN
						gStep := SetBoardPrep;
					ELSE
						gAlarm.InncorrectBoard := TRUE;
						gStep := ErrorState;
					END_IF;
				END_IF;
			END_IF;
					
		GameMove:
			(* GameMove -> wykonywany jest ruch warcabowy, gGameRound = TRUE -> ruch cz³owieka *)
			gPlayerMove := (gGameRound = TRUE);	
			IF RobotMoveMarker AND gRobotMoveVar.RTRMove THEN
				gPlayerMove := FALSE;
				MoveStep := IdleRM;
				gStep := RobotMove;
				RobotMoveMarker := FALSE;
			END_IF;
					
		RobotMove:
			IF gESTOP THEN
				CASE MoveStep OF
					IdleRM:
						IF gRobotMoveVar.RTRMove THEN
							MoveStep := MoveExecute;
						END_IF;
				
					MoveExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_START_END;
							gMotionInterface.StartPos := COORD_POSITION[gRobotMoveVar.StartPoint.y, gRobotMoveVar.StartPoint.x];
							gMotionInterface.EndPos := COORD_POSITION[gRobotMoveVar.EndPoint.y, gRobotMoveVar.EndPoint.x];
							gMotionInterface.Execute := TRUE;
							MoveStep := MoveBusy;
						END_IF;
			
					MoveBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							IF gRobotMoveVar.Capture THEN
								MoveStep := DiscardExecute;
							ELSE
								MoveStep := HomeExecute;
							END_IF;
						END_IF;
			
					DiscardExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_START_END;
							gMotionInterface.EndPos := BUFOR_POSITION[gRobotMoveVar.DiscardColor, 12 - ColorCount[gRobotMoveVar.DiscardColor] + 1];
							ColorCount[gRobotMoveVar.DiscardColor] := ColorCount[gRobotMoveVar.DiscardColor] - 1;
							gMotionInterface.StartPos := COORD_POSITION[gRobotMoveVar.DiscardPoint.y, gRobotMoveVar.DiscardPoint.x];
							gMotionInterface.Execute := TRUE;
							MoveStep := DiscardBusy;
						END_IF;
			
					DiscardBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							MoveStep := HomeExecute;
						END_IF;
						
					HomeExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_HOME;
							gMotionInterface.StartPos := DEFAULT_POSITION;
							gMotionInterface.EndPos := DEFAULT_POSITION;
							gMotionInterface.Execute := TRUE;
							MoveStep := HomeBusy;
						END_IF;
						
					HomeBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							MoveStep := EndRM;
						END_IF;
			
					EndRM:
						MoveStep := IdleRM;
						gStep := PhotoCheck;
						gRobotMoveVar.RTRMove := FALSE;
				END_CASE;
			ELSE
				gStep := ResetRobotPos;
				SetBoardStep := SetBoardBusy;
				gRobotMoveVar.RTRMove := FALSE;
				MoveStep := IdleRM;
			END_IF;

		ErrorState:
			gMotionInterface.Enable := FALSE;
			IF gAlarm.InncorrectBoard = FALSE THEN
				gMotionInterface.Enable := TRUE;
				gStep := PhotoCheck;
			END_IF;
			
		ResetRobotPos:
			IF gESTOP THEN
				RRPTrigger := TRUE;
				IF RRPConfirm THEN
					CASE SetBoardStep OF
						SetBoardBusy:
							gMotionInterface.Enable := TRUE;
							SetBoardStep := SetBoardHomeExecute;
							
						SetBoardHomeExecute:
							IF gMotionInterface.Ready THEN
								gMotionInterface.Command := MOVE_HOME;
								gMotionInterface.StartPos := DEFAULT_POSITION;
								gMotionInterface.EndPos := DEFAULT_POSITION;
								gMotionInterface.Execute := TRUE;
								SetBoardStep := SetBoardHomeBusy;
							END_IF;
					
						SetBoardHomeBusy:
							IF gMotionInterface.Done THEN
								gMotionInterface.Execute := FALSE;
								RRPConfirm := FALSE;
								RRPTrigger := FALSE;
								SetBoardStep := SetBoardExecute;
								gStep := PhotoCheck;
							END_IF;
					END_CASE;
				ELSIF RRPCancel THEN
					gStart := FALSE;
					RRPCancel := FALSE;
					RRPTrigger := FALSE;
				END_IF;
			ELSE
				RRPConfirm := FALSE;
				RRPCancel := FALSE;
				RRPTrigger := FALSE;
			END_IF;
			
		SetBoardPrep:
			SetBoardTrigger := FALSE;
			
			(* Obliczanie aktualnego stanu bufora *)
			BuforLastPieceIndex[1] := 12 - ColorCount[1];
			BuforLastPieceIndex[2] := 12 - ColorCount[2];
			
			(* Zerowanie tablic flag *)
			FOR i := 1 TO 24 DO
				DrawHandled[i] := FALSE;
				DiscardHandled[i]:= FALSE;
			END_FOR;
			
			IF DrawCount > 0 OR DiscardCount > 0 THEN
				CommandCount := 0;
				
				(* KROK 1: Przesuniêcia bezpoœrednie z logik¹ antykolizyjn¹ *)
				IF DiscardCount > 0 THEN
					FOR i := 1 TO DiscardCount DO
						IF NOT DiscardHandled[i] THEN
							MatchFound := FALSE;
							
							(* Szukamy wolnego miejsca o TAKIM SAMYM KOLORZE na planszy *)
							IF DrawCount > 0 THEN
								FOR j := 1 TO DrawCount DO
									IF NOT DrawHandled[j] AND (PiecesToDiscard[i].Color = PiecesToDraw[j].Color) THEN
										MatchFound := TRUE;
										
										(* --- LOGIKA ANTYKOLIZYJNA --- *)
										(* Sprawdzamy, czy na polu docelowym (PiecesToDraw[j]) fizycznie stoi jakiœ inny b³êdny pionek *)
										FOR k := 1 TO DiscardCount DO
											IF (NOT DiscardHandled[k]) AND 
												(PiecesToDiscard[k].Index.x = PiecesToDraw[j].Index.x) AND 
												(PiecesToDiscard[k].Index.y = PiecesToDraw[j].Index.y) THEN
												
												(* ZNALEZIONO KOLIZJÊ! Najpierw odk³adamy blokuj¹cy pionek do bufora *)
												CommandCount := CommandCount + 1;
												CommandList[CommandCount].StartPos := COORD_POSITION[PiecesToDiscard[k].Index.x, PiecesToDiscard[k].Index.y];
												
												IF BuforLastPieceIndex[PiecesToDiscard[k].Color] < 12 THEN
													BuforLastPieceIndex[PiecesToDiscard[k].Color] := BuforLastPieceIndex[PiecesToDiscard[k].Color] + 1;
												END_IF;
												
												CommandList[CommandCount].EndPos := BUFOR_POSITION[PiecesToDiscard[k].Color, BuforLastPieceIndex[PiecesToDiscard[k].Color]];
												
												(* Zaznaczamy, ¿e ten blokuj¹cy pionek zosta³ ju¿ obs³u¿ony *)
												DiscardHandled[k] := TRUE; 
											END_IF;
										END_FOR;
										(* ----------------------------- *)
										
										(* Teraz pole docelowe jest NA PEWNO puste. Robimy ruch bezpoœredni. *)
										CommandCount := CommandCount + 1;
										CommandList[CommandCount].StartPos := COORD_POSITION[PiecesToDiscard[i].Index.x, PiecesToDiscard[i].Index.y];
										CommandList[CommandCount].EndPos := COORD_POSITION[PiecesToDraw[j].Index.x, PiecesToDraw[j].Index.y];
										
										(* Oznaczamy jako obs³u¿one *)
										DiscardHandled[i] := TRUE;
										DrawHandled[j] := TRUE;
										EXIT; (* Przerywamy pêtlê szukaj¹c¹ pary dla tego pionka *)
									END_IF;
								END_FOR;
							END_IF;
							
							(* Jeœli nie znaleŸliœmy miejsca na planszy dla tego pionka (MatchFound = FALSE) -> zrzucamy do bufora *)
							IF NOT MatchFound THEN
								CommandCount := CommandCount + 1;
								CommandList[CommandCount].StartPos := COORD_POSITION[PiecesToDiscard[i].Index.x, PiecesToDiscard[i].Index.y];
								
								IF BuforLastPieceIndex[PiecesToDiscard[i].Color] < 12 THEN
									BuforLastPieceIndex[PiecesToDiscard[i].Color] := BuforLastPieceIndex[PiecesToDiscard[i].Color] + 1;
								END_IF;
								
								CommandList[CommandCount].EndPos := BUFOR_POSITION[PiecesToDiscard[i].Color, BuforLastPieceIndex[PiecesToDiscard[i].Color]];
								DiscardHandled[i] := TRUE;
							END_IF;
						END_IF;
					END_FOR;
				END_IF;

				(* KROK 2: Uzupe³nianie brakuj¹cych miejsc (tych, które nie znalaz³y pary) z bufora *)
				IF DrawCount > 0 THEN
					FOR j := 1 TO DrawCount DO
						IF NOT DrawHandled[j] THEN
							CommandCount := CommandCount + 1;
							
							IF BuforLastPieceIndex[PiecesToDraw[j].Color] > 0 THEN
								CommandList[CommandCount].StartPos := BUFOR_POSITION[PiecesToDraw[j].Color, BuforLastPieceIndex[PiecesToDraw[j].Color]];
								BuforLastPieceIndex[PiecesToDraw[j].Color] := BuforLastPieceIndex[PiecesToDraw[j].Color] - 1;
							ELSE
								CommandList[CommandCount].StartPos := BUFOR_POSITION[PiecesToDraw[j].Color, 1];
							END_IF;
							
							CommandList[CommandCount].EndPos := COORD_POSITION[PiecesToDraw[j].Index.x, PiecesToDraw[j].Index.y];
							DrawHandled[j] := TRUE;
						END_IF;
					END_FOR;
				END_IF;
				
				CommandDoneCount := 0;
				gStep := SetBoard;
				SetBoardStep := SetBoardExecute;
			ELSE
				gStep := PhotoCheck;
			END_IF;
			
		SetBoard:
			IF gESTOP THEN
				CASE SetBoardStep OF
					SetBoardExecute:
						IF gMotionInterface.Ready THEN
							CommandDoneCount := CommandDoneCount + 1;
							gMotionInterface.Command := MOVE_START_END;
							gMotionInterface.StartPos := CommandList[CommandDoneCount].StartPos;
							gMotionInterface.EndPos := CommandList[CommandDoneCount].EndPos;
							gMotionInterface.Execute := TRUE;
							SetBoardStep := SetBoardBusy;
						END_IF;
					
					SetBoardBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							
							IF CommandDoneCount < CommandCount THEN
								SetBoardStep := SetBoardExecute;
							ELSE
								SetBoardStep := SetBoardHomeExecute;
							END_IF;
						END_IF;
					
					SetBoardHomeExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_HOME;
							gMotionInterface.StartPos := DEFAULT_POSITION;
							gMotionInterface.EndPos := DEFAULT_POSITION;
							gMotionInterface.Execute := TRUE;
							SetBoardStep := SetBoardHomeBusy;
						END_IF;
					
					SetBoardHomeBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							SetBoardStep := SetBoardExecute;
							gStep := PhotoCheck;
						END_IF;
				END_CASE;
			ELSE
				SetBoardTrigger := FALSE;
				gStep := ResetRobotPos;
				SetBoardStep := SetBoardBusy;
			END_IF;
	END_CASE;
END_PROGRAM

PROGRAM _EXIT
	(* Miejsce na kod wywo³ywany przy zatrzymaniu zadania *)
END_PROGRAM