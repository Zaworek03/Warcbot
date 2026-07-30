
PROGRAM _INIT
	gStep := Idle;
	BoardGit := FALSE;

	MpAuditTrail_0.Enable := TRUE; 
	MpAuditTrail_0.MpLink := ADR(gAuditTrail); 
	MpAuditTrail_0.DeviceName := ADR('AUDIT'); 
	MpAuditTrail_0.FileName := ADR('AuditList'); 
	MpAuditTrail_0();
	
	MpReportCore_0.Enable := TRUE; 
	MpReportCore_0.MpLink := ADR(gReport); 
	MpReportCore_0.DeviceName := ADR('CF'); 
	MpReportCore_0.FileName := ADR('GameReport'); 
	MpReportCore_0.ReportID := ADR('MyReport'); 
	MpReportCore_0.Language := ADR('en'); 
	MpReportCore_0(); 
	
	gMotionInterface.BlackPilePos.X := 395.4;
	gMotionInterface.BlackPilePos.Y := -293;
	gMotionInterface.BlackPilePos.Z := 286.4;
	
	gMotionInterface.WhitePilePos.X := 395.4;
	gMotionInterface.WhitePilePos.Y := -293;
	gMotionInterface.WhitePilePos.Z := 286.4;
	
END_PROGRAM

PROGRAM _CYCLIC
	MpAuditTrail_0();
	MpReportCore_0();
	
	gStop := NOT gStart;

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
			END_IF
				
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
						(* Odwr�cenie planszy do g�ry nogami, aby odczyt z kamry by� zgodny z widokiem ze stania na wprost robota *)
						SimBoardValue := CONVERT_BOARD[gBoardActual[BOARD_SPACES + 1 - i, BOARD_SPACES + 1 - j]];
						CameraBoardValue := gBoardCamera[i, j];
						
						ColorCount[CameraBoardValue] := ColorCount[CameraBoardValue] + 1;
						
						IF SimBoardValue <> CameraBoardValue THEN
							Match := FALSE;
							
							IF SetBoardTrigger THEN
								IF CameraBoardValue = 0 THEN
									PiecesToDraw[DrawCount].Index.x := i;
									PiecesToDraw[DrawCount].Index.y := j;
									PiecesToDraw[DrawCount].Color := SimBoardValue;
									DrawCount := DrawCount + 1;
								ELSIF SimBoardValue = 0 THEN
									PiecesToDiscard[DiscardCount].Index.x := i;
									PiecesToDiscard[DiscardCount].Index.y := j;
									PiecesToDiscard[DiscardCount].Color := CameraBoardValue;
									DiscardCount := DiscardCount + 1;
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
			(* GameMove -> wykonywany jest ruch warcabowy, gGameRound = TRUE -> ruch cz�owieka *)
			gPlayerMove := gGameRound = TRUE;	
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
							gMotionInterface.StartPos := COORD_POSITION[gRobotMoveVar.StartPoint.x,gRobotMoveVar.StartPoint.y];
							gMotionInterface.EndPos := COORD_POSITION[gRobotMoveVar.EndPoint.x,gRobotMoveVar.EndPoint.y];
							gMotionInterface.Execute := TRUE;
							MoveStep := MoveBusy;
						END_IF;
			
					MoveBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							IF gRobotMoveVar.Capture THEN
								MoveStep := DiscardExecute;
							ELSE
								MoveStep := EndRM;
							END_IF;
						END_IF;
			
					DiscardExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_START_END;
							gMotionInterface.EndPos := BUFOR_POSITION[gRobotMoveVar.DiscardColor, 12 - ColorCount[gRobotMoveVar.DiscardColor] + 1];
							ColorCount[gRobotMoveVar.DiscardColor] := ColorCount[gRobotMoveVar.DiscardColor] - 1;
							gMotionInterface.StartPos := COORD_POSITION[gRobotMoveVar.DiscardPoint.x,gRobotMoveVar.DiscardPoint.y];
							
							gMotionInterface.Execute := TRUE;
							MoveStep := DiscardBusy;
						END_IF;
			
					DiscardBusy:
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
				IF RRPConfirm THEN
					(* Dodaj program do resetu robota i powortu do pozycji, gdzie robot nie zas�ania kamery *);
					IF (* Sko�czy� ruch *)FALSE THEN
						gStep := PhotoCheck;
						RRPConfirm := FALSE;
					END_IF;
				ELSIF RRPCancel THEN
					gStart := FALSE;
					RRPCancel := FALSE;
				END_IF;
			ELSE
				RRPConfirm := FALSE;
				RRPCancel := FALSE;
			END_IF;
			
		SetBoardPrep:
			FOR i := 0 TO 11 DO
				DrawHandled[i] := FALSE;
			END_FOR;

			IF DrawCount > 0 OR DiscardCount > 0 THEN
				CommandCount := 0;
				IF DiscardCount > 0 THEN
					FOR i := 0 TO (DiscardCount - 1) DO
						MatchFound := FALSE;
            
						(* Szukamy wolnego miejsca o TAKIM SAMYM KOLORZE *)
						FOR j := 0 TO (DrawCount - 1) DO
							IF NOT DrawHandled[j] AND (PiecesToDiscard[i].Color = PiecesToDraw[j].Color) THEN
                    
								(* ZNALEZIONO DOPASOWANIE! *)
								MatchFound := TRUE;
								DrawHandled[j] := TRUE; (* Odznaczamy to miejsce, by nie u�y� go podw�jnie *)
                    			
								(* >> ZADANIE: PRZENIE� BEZPO�REDNIO NA PLANSZY << 
								Zabierz z: PiecesToDiscard[i].Index
								Od�� na : PiecesToDraw[j].Index
								*)
								CommandList[CommandCount].StartPos := COORD_POSITION[PiecesToDiscard[i].Index.x, PiecesToDiscard[i].Index.y];
								CommandList[CommandCount].EndPos := COORD_POSITION[PiecesToDraw[j].Index.x, PiecesToDraw[j].Index.y];
								CommandCount := CommandCount + 1;
                    
								EXIT; (* Przerywamy wewn�trzn� p�tl�, szukamy dla kolejnego i *)
							END_IF;
						END_FOR;
            
						(* Je�li p�tla si� sko�czy�a i nie znaleziono dopasowania koloru... *)
						IF NOT MatchFound THEN
                
                (* >> ZADANIE: OD�ӯ DO MAGAZYNU << 
                   Zabierz z: PiecesToDiscard[i].Index
                   Od�� do : Magazyn
                *)
							CommandList[CommandCount].StartPos := COORD_POSITION[PiecesToDiscard[i].Index.x, PiecesToDiscard[i].Index.y];
							CommandList[CommandCount].EndPos := BUFOR_POSITION[PiecesToDiscard[i].Color, 12 - ColorCount[PiecesToDiscard[i].Color] + 1];
							ColorCount[PiecesToDiscard[i].Color] := ColorCount[PiecesToDiscard[i].Color] - 1;
							CommandCount := CommandCount + 1;
                
						END_IF;
					END_FOR;
				END_IF;

						(* =================================================================
						KROK 2: Uzupe�nianie pozosta�ych miejsc, dla kt�rych zabrak�o klock�w na planszy
						================================================================= *)
				IF DrawCount > 0 THEN
					FOR j := 0 TO (DrawCount - 1) DO
            
						(* Bierzemy pod uwag� TYLKO te miejsca, kt�rych nie odhaczyli�my w Kroku 1 *)
						IF NOT DrawHandled[j] THEN
                
                (* >> ZADANIE: WE� Z MAGAZYNU << 
                   Bierz z  : Magazyn (kolor okre�la PiecesToDraw[j].Color)
                   Od�� na : PiecesToDraw[j].Index
                *)
							CommandList[CommandCount].StartPos := BUFOR_POSITION[PiecesToDraw[j].Color, 12 - ColorCount[PiecesToDraw[j].Color] + 1];
							CommandList[CommandCount].EndPos := COORD_POSITION[PiecesToDraw[j].Index.x, PiecesToDraw[j].Index.y];
							ColorCount[PiecesToDraw[j].Color] := ColorCount[PiecesToDraw[j].Color] + 1;
							CommandCount := CommandCount + 1;
                
						END_IF;
            
					END_FOR;
				END_IF;
				CommandDoneCount := 0;
				gStep := SetBoard;
				SetBoardStep := SetBoardExecute;
			ELSE
				gStep := PhotoCheck;
				SetBoardTrigger := FALSE;
			END_IF;
			
		SetBoard:
			IF gESTOP THEN
				CASE SetBoardStep OF
					SetBoardExecute:
						IF gMotionInterface.Ready THEN
							gMotionInterface.Command := MOVE_START_END;
							gMotionInterface.StartPos := CommandList[CommandDoneCount].StartPos;
							gMotionInterface.EndPos := CommandList[CommandDoneCount].EndPos;
							gMotionInterface.Execute := TRUE;
							SetBoardStep := SetBoardBusy;
						END_IF;
					
					SetBoardBusy:
						IF gMotionInterface.Done THEN
							gMotionInterface.Execute := FALSE;
							IF (CommandDoneCount + 1) < CommandCount THEN
								SetBoardStep := SetBoardExecute;
								CommandDoneCount := CommandDoneCount + 1;
						
							ELSE
								CommandDoneCount := CommandDoneCount + 1;
								SetBoardTrigger := FALSE;
								SetBoardStep := SetBoardExecute;
								gStep := PhotoCheck;
							END_IF;
						END_IF;
					
				END_CASE;
			ELSE
				SetBoardTrigger := FALSE;
				gStep := ResetRobotPos;
			END_IF;
		
		
	END_CASE;

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

