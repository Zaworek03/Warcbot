
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	IF gStep = RobotMove THEN
		Doing := TRUE;
		CASE MoveStep OF
			IdleRM:
				IF Doing THEN
					MoveStep := MoveExecute;
				ELSE
					gStep := PhotoCheck;
				END_IF;
				
			MoveExecute:
				IF gMotionInterface.Execute = FALSE THEN
					gMotionInterface.RequestManualMode := FALSE;
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
						Doing := FALSE;
						MoveStep := IdleRM;
					END_IF;
				END_IF;
			
			DiscardExecute:
				IF gMotionInterface.Execute = FALSE THEN
					gMotionInterface.RequestManualMode := FALSE;
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
					Doing := FALSE;
					MoveStep := IdleRM;
				END_IF;
		END_CASE;
	END_IF;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

