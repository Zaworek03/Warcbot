
PROGRAM _INIT
	gStep := Idle;
	BoardGit := FALSE;

	MpAuditTrail_0.Enable := TRUE; 
	MpAuditTrail_0.MpLink := ADR(gAuditTrail); 
	MpAuditTrail_0.DeviceName := ADR('AUDIT'); 
	MpAuditTrail_0.FileName := ADR('AuditList'); 
	MpAuditTrail_0();
	
	gMotionInterface.BlackPilePos.X := 395.4;
	gMotionInterface.BlackPilePos.Y := -293;
	gMotionInterface.BlackPilePos.Z := 286.4;
	
	gMotionInterface.WhitePilePos.X := 395.4;
	gMotionInterface.WhitePilePos.Y := -293;
	gMotionInterface.WhitePilePos.Z := 286.4;
	
END_PROGRAM

PROGRAM _CYCLIC
	MpAuditTrail_0();
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
				FOR i := 1 TO BOARD_SPACES DO
					FOR j := 1 TO BOARD_SPACES DO
						(* OdwrÛcenie planszy do gÛry nogami, aby odczyt z kamry by≥ zgodny z widokiem ze stania na wprost robota *)
						SimBoardValue := CONVERT_BOARD[gBoardActual[BOARD_SPACES + 1 - i, BOARD_SPACES + 1 - j]];
						CameraBoardValue := gBoardCamera[i, j];
						
						IF SimBoardValue <> CameraBoardValue THEN
							Match := FALSE;
							
							IF SetBoardTrigger THEN
								IF CameraBoardValue = 0 THEN
									PiecesToDraw[DrawCount].Index.x := i;
									PiecesToDraw[DrawCount].Index.y := j;
									IF SimBoardValue = 1 THEN
										PiecesToDraw[DrawCount].Color := TRUE;
									ELSIF SimBoardValue = 2 THEN
										PiecesToDraw[DrawCount].Color := FALSE;
									END_IF;
									DrawCount := DrawCount + 1;
								ELSIF SimBoardValue = 0 THEN
									PiecesToDiscard[DiscardCount].Index.x := i;
									PiecesToDiscard[DiscardCount].Index.y := j;
									IF CameraBoardValue = 1 THEN
										PiecesToDiscard[DiscardCount].Color := TRUE;
									ELSIF CameraBoardValue = 2 THEN
										PiecesToDiscard[DiscardCount].Color := FALSE;
									END_IF;
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
						gStep := SetBoard;
					ELSE
						gAlarm.InncorrectBoard := TRUE;
						gStep := ErrorState;
					END_IF;
				END_IF;
			END_IF;
					
		GameMove:
			(* GameMove -> wykonywany jest ruch warcabowy, gGameRound = TRUE -> ruch cz≥owieka *)
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
							IF gRobotMoveVar.DiscardColorWhite THEN
								gMotionInterface.Command := DISCARD_WHITE;
							ELSE
								gMotionInterface.Command := DISCARD_BLACK;
							END_IF;
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
			END_IF

		ErrorState:
			gMotionInterface.Enable := FALSE;
			IF gAlarm.InncorrectBoard = FALSE THEN
				gMotionInterface.Enable := TRUE;
				gStep := PhotoCheck;
			END_IF;
			
		ResetRobotPos:
			IF gESTOP THEN
				IF (* Potwierdzenie resretu pozycji *)FALSE THEN
					(* Dodaj program do resetu robota i powortu do pozycji, gdzie robot nie zas≥ania kamery *);
					IF (* SkoÒczy≥ ruch *)FALSE THEN
						gStep := PhotoCheck;
						(* reset stanu potwierdzenia *)
					END_IF;
				ELSIF (* anulowanie, dodaÊ info, øe podda grÍ *) FALSE THEN
					gStart := FALSE;
					(* reset stanu anulowania *)
				END_IF;
			ELSE
				(* reset stanu potwierdzenia i anulowania *);
			END_IF;
			
		SetBoardPrep:
			FOR i := 0 TO 11 DO
				DrawHandled[i] := FALSE;
			END_FOR;

			IF DrawCount > 0 OR DiscardCount > 0 THEN
				IF DiscardCount > 0 THEN
					FOR i := 0 TO (DiscardCount - 1) DO
						MatchFound := FALSE;
            
						(* Szukamy wolnego miejsca o TAKIM SAMYM KOLORZE *)
						FOR j := 0 TO (DrawCount - 1) DO
							IF NOT DrawHandled[j] AND (PiecesToDiscard[i].Color = PiecesToDraw[j].Color) THEN
                    
								(* ZNALEZIONO DOPASOWANIE! *)
								MatchFound := TRUE;
								DrawHandled[j] := TRUE; (* Odznaczamy to miejsce, by nie uøyÊ go podwÛjnie *)
                    
								(* >> ZADANIE: PRZENIEå BEZPOåREDNIO NA PLANSZY << 
								Zabierz z: PiecesToDiscard[i].Index
								Od≥Ûø na : PiecesToDraw[j].Index
								*)
                    
								EXIT; (* Przerywamy wewnÍtrznπ pÍtlÍ, szukamy dla kolejnego i *)
							END_IF;
						END_FOR;
            
						(* Jeúli pÍtla siÍ skoÒczy≥a i nie znaleziono dopasowania koloru... *)
						IF NOT MatchFound THEN
                
                (* >> ZADANIE: OD£”Ø DO MAGAZYNU << 
                   Zabierz z: PiecesToDiscard[i].Index
                   Od≥Ûø do : Magazyn
                *)
                
						END_IF;
					END_FOR;
				END_IF;

						(* =================================================================
						KROK 2: Uzupe≥nianie pozosta≥ych miejsc, dla ktÛrych zabrak≥o klockÛw na planszy
						================================================================= *)
				IF DrawCount > 0 THEN
					FOR j := 0 TO (DrawCount - 1) DO
            
						(* Bierzemy pod uwagÍ TYLKO te miejsca, ktÛrych nie odhaczyliúmy w Kroku 1 *)
						IF NOT DrawHandled[j] THEN
                
                (* >> ZADANIE: WEè Z MAGAZYNU << 
                   Bierz z  : Magazyn (kolor okreúla PiecesToDraw[j].Color)
                   Od≥Ûø na : PiecesToDraw[j].Index
                *)
                
						END_IF;
            
					END_FOR;
				END_IF;
				gStep := SetBoard;
			ELSE
				gStep := PhotoCheck;
				SetBoardTrigger := FALSE;
			END_IF;
			
		SetBoard:
			CASE SetBoardStep OF
				
				SetBoardExecute:
					;
				
				SetBoardBusy:
					;

			END_CASE;
		
	END_CASE;

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

