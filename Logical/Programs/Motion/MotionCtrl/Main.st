
PROGRAM _INIT
	doMagnet;

	gAxesGroup_Racer3_1;
	gAxisQ1_Racer3_1;
	gAxisQ2_Racer3_1;
	gAxisQ3_Racer3_1;
	gAxisQ4_Racer3_1;
	gAxisQ5_Racer3_1;
	gAxisQ6_Racer3_1;
	
	mcGroupHome.AxesGroup := ADR(gAxesGroup_Racer3_1);
	
	Robot.MpLink := ADR(gAxesGroup_Racer3_1);
	Robot.Enable := 1;
	Robot.ErrorReset := 0;
	Robot.Parameters := ADR(RobotPar);
	Robot.Update := 1;
	Robot.Override := 100;
	Robot.Power := 0;
	Robot();
	
	RobotState := ROBOT_ENABLED;
	
END_PROGRAM

PROGRAM _CYCLIC
	// TRZEBA ZROBIÆ SYNCHRONIZACJE
	ExecuteImpulse := RTrigExecute.Q;
	RTrigExecute.CLK := gMotionInterface.Execute;
	
	STMotionDoneImpulse := RTrigSTMotionDone.Q;
	RTrigSTMotionDone.CLK := STMotionDone;
	
	CASE RobotState OF
		ROBOT_DISABLED:
			IF gMotionInterface.Enable THEN
				RobotState := ROBOT_ENABLED;
				Robot.ErrorReset := 0;
			END_IF;
		
		ROBOT_ENABLED:
			Robot.Power := TRUE;
			IF Robot.PowerOn THEN
				RobotState := ROBOT_HOMING_SELECT;
			END_IF;
			
		ROBOT_HOMING_SELECT:
			// Bazowanie Restore Position
			IF RestorePosReady THEN
				RobotState := ROBOT_HOMING_RESTORE;
			// Bazowanie Homing Direct
			ELSE
				gAlarm.RobotRestorePosFail := TRUE;
				RobotState := ROBOT_HOMING_DIRECT;
			END_IF;
		
		ROBOT_HOMING_DIRECT:
			FOR i := 0 TO 5 DO
				mcGroupHome.HomingMode[i] := mcHOMING_DIRECT;
				mcGroupHome.Position[i] := AxisPos[i];
			END_FOR;
			mcGroupHome.Execute := TRUE;
			IF mcGroupHome.Done THEN
				RobotState := ROBOT_HOMED;
				gMotionInterface.Manual.RequestRehomeRobot := FALSE;
				RestorePosReady := TRUE;
				mcGroupHome.Execute := FALSE;
			END_IF;
			
		ROBOT_HOMING_RESTORE:
			FOR i := 0 TO 5 DO
				mcGroupHome.HomingMode[i] := mcHOMING_RESTORE_POSITION;
				mcGroupHome.Position[i] := AxisPos[i];
			END_FOR;
			mcGroupHome.Execute := TRUE;
			IF mcGroupHome.Done THEN
				RobotState := ROBOT_HOMED;
				mcGroupHome.Execute := FALSE;
			END_IF;
			
		ROBOT_HOMED:
			
			gMotionInterface.Done := FALSE;
			IF gMotionInterface.RequestManualMode THEN
				RobotState := ROBOT_MANUAL;
			ELSIF ExecuteImpulse  THEN
				RobotState := ROBOT_EXECUTE;
			END_IF;
			
		ROBOT_MANUAL:
			// domyslnie
			
			RobotPar.Jog.Velocity[0] := 0;
			RobotPar.Jog.Velocity[1] := 0;
			RobotPar.Jog.Velocity[2] := 0;
			RobotPar.Jog.Velocity[3] := 0;
			RobotPar.Jog.Velocity[4] := 0;
			RobotPar.Jog.Velocity[5] := 0;
			Robot.Jog := FALSE;
			
			JogJointPos0 := gMotionInterface.Manual.Joint.JogPos0;
			JogJointPos1 := gMotionInterface.Manual.Joint.JogPos1;
			JogJointPos2 := gMotionInterface.Manual.Joint.JogPos2;
			JogJointPos3 := gMotionInterface.Manual.Joint.JogPos3;
			JogJointPos4 := gMotionInterface.Manual.Joint.JogPos4;
			JogJointPos5 := gMotionInterface.Manual.Joint.JogPos5;
			JogJointNeg0 := gMotionInterface.Manual.Joint.JogNeg0;
			JogJointNeg1 := gMotionInterface.Manual.Joint.JogNeg1;
			JogJointNeg2 := gMotionInterface.Manual.Joint.JogNeg2;
			JogJointNeg3 := gMotionInterface.Manual.Joint.JogNeg3;
			JogJointNeg4 := gMotionInterface.Manual.Joint.JogNeg4;
			JogJointNeg5 := gMotionInterface.Manual.Joint.JogNeg5;
			JogJointSpeed := gMotionInterface.Manual.Joint.Speed;
				
			JogXPos := gMotionInterface.Manual.Cartesian.JogXPos;
			JogXNeg := gMotionInterface.Manual.Cartesian.JogXNeg;
			JogYPos := gMotionInterface.Manual.Cartesian.JogYPos;
			JogYNeg := gMotionInterface.Manual.Cartesian.JogYNeg;
			JogZPos := gMotionInterface.Manual.Cartesian.JogZPos;
			JogZNeg := gMotionInterface.Manual.Cartesian.JogZNeg;
			JogCartesianSpeed := gMotionInterface.Manual.Cartesian.Speed;
			
			JogJointAny := JogJointPos0 OR JogJointNeg0
			OR JogJointPos1 OR JogJointNeg1
			OR JogJointPos2 OR JogJointNeg2
			OR JogJointPos3 OR JogJointNeg3
			OR JogJointPos4 OR JogJointNeg4
			OR JogJointPos5 OR JogJointNeg5;
			
			IF JogJointAny THEN
				// tryb JogJoint
				RobotPar.Jog.CoordSystem := mcJACS;
				
				IF JogJointPos0 THEN
					RobotPar.Jog.Velocity[0] := JogJointSpeed;
				ELSIF JogJointNeg0 THEN
					RobotPar.Jog.Velocity[0] := -JogJointSpeed;
				END_IF;
				IF JogJointPos1 THEN
					RobotPar.Jog.Velocity[1] := JogJointSpeed;
				ELSIF JogJointNeg1 THEN
					RobotPar.Jog.Velocity[1] := -JogJointSpeed;
				END_IF;
				IF JogJointPos2 THEN
					RobotPar.Jog.Velocity[2] := JogJointSpeed;
				ELSIF JogJointNeg2 THEN
					RobotPar.Jog.Velocity[2] := -JogJointSpeed;
				END_IF;
				IF JogJointPos3 THEN
					RobotPar.Jog.Velocity[3] := JogJointSpeed;
				ELSIF JogJointNeg3 THEN
					RobotPar.Jog.Velocity[3] := -JogJointSpeed;
				END_IF;
				IF JogJointPos4 THEN
					RobotPar.Jog.Velocity[4] := JogJointSpeed;
				ELSIF JogJointNeg4 THEN
					RobotPar.Jog.Velocity[4] := -JogJointSpeed;
				END_IF;
				IF JogJointPos5 THEN
					RobotPar.Jog.Velocity[5] := JogJointSpeed;
				ELSIF JogJointNeg5 THEN
					RobotPar.Jog.Velocity[5] := -JogJointSpeed;
				END_IF;
				
				Robot.Jog := TRUE;
			ELSIF JogXPos OR JogXNeg OR JogYPos OR JogYNeg OR JogZPos OR JogZNeg THEN
				// tryb JogCartesian
				RobotPar.Jog.CoordSystem := mcMCS; // lub inny
				Robot.Jog := TRUE;
		
				IF JogXPos THEN
					RobotPar.Jog.Velocity[0] := JogCartesianSpeed;
				END_IF;
				IF JogXNeg THEN
					RobotPar.Jog.Velocity[0] := -JogCartesianSpeed;
				END_IF;
				IF JogYPos THEN
					RobotPar.Jog.Velocity[1] := JogCartesianSpeed;
				END_IF;
				IF JogYNeg THEN
					RobotPar.Jog.Velocity[1] := -JogCartesianSpeed;
				END_IF;
				IF JogZPos THEN
					RobotPar.Jog.Velocity[2] := JogCartesianSpeed;
				END_IF;
				IF JogZNeg THEN
					RobotPar.Jog.Velocity[2] := -JogCartesianSpeed;
				END_IF;
			
			ELSIF gMotionInterface.Manual.RequestGoHome THEN
				RobotPar.ProgramName := 'gohome.st';
				Robot.MoveProgram := TRUE;
				STMotionDone := FALSE;
				RobotState := ROBOT_GO_HOME;
				gMotionInterface.Manual.RequestGoHome := FALSE;
			END_IF;
			
			IF NOT gMotionInterface.RequestManualMode THEN
				Robot.Jog := FALSE;
				RobotState := ROBOT_HOMED;
			END_IF;
			
			IF gMotionInterface.Manual.RequestRehomeRobot THEN
				Robot.Jog := FALSE;
				RobotState := ROBOT_HOMING_DIRECT;
			END_IF;
			
			IF STMotionDoneImpulse THEN
				Robot.MoveProgram := FALSE;
				Robot.Interrupt := TRUE;
			END_IF;
			
		ROBOT_GO_HOME:
			IF STMotionDone THEN
				RobotState := ROBOT_MANUAL;
			END_IF;
			
		ROBOT_EXECUTE:
			
		STMotionStartPoint.Pos := gMotionInterface.StartPos;
		STMotionStartPoint.Orient := STMotionDefaultOrient;
			
			// Ustalanie na jaka pozycje warcab ma byc odstawiony
			CASE gMotionInterface.Command OF
				MOVE_START_END:
					STMotionEndPoint.Pos := gMotionInterface.EndPos;
				DISCARD_WHITE:
					PileCalculatedOffs.X := WhitePileXOffs * USINT_TO_REAL(WhitePileCnt/PileHeight);
					PileCalculatedOffs.Y := 0;
					PileCalculatedOffs.Z := PileZOffs * USINT_TO_REAL(WhitePileCnt MOD PileHeight);
					
					STMotionEndPoint.Pos.X := gMotionInterface.EndPos.X + PileCalculatedOffs.X;
					STMotionEndPoint.Pos.Y := gMotionInterface.EndPos.Y + PileCalculatedOffs.Y;
					STMotionEndPoint.Pos.Z := gMotionInterface.EndPos.Z + PileCalculatedOffs.Z;
				DISCARD_BLACK:
					PileCalculatedOffs.X := BlackPileXOffs * USINT_TO_REAL(BlackPileCnt/PileHeight);
					PileCalculatedOffs.Y := 0;
					PileCalculatedOffs.Z := PileZOffs * USINT_TO_REAL(BlackPileCnt MOD PileHeight);
					
					STMotionEndPoint.Pos.X := gMotionInterface.EndPos.X + PileCalculatedOffs.X;
					STMotionEndPoint.Pos.Y := gMotionInterface.EndPos.Y + PileCalculatedOffs.Y;
					STMotionEndPoint.Pos.Z := gMotionInterface.EndPos.Z + PileCalculatedOffs.Z;
			END_CASE;
			
			// rozpoczecie pracy programu
			RobotPar.ProgramName := 'move.st';
			Robot.Interrupt := FALSE;
			Robot.MoveProgram := TRUE;
			STMotionEndPoint.Orient := STMotionDefaultOrient;
			
			STMotionDone := FALSE;
			gMotionInterface.Busy := TRUE;
			RobotState := ROBOT_MOVING;
		
		ROBOT_MOVING:
			IF STMotionDone THEN
				gMotionInterface.Busy := FALSE;
				Robot.MoveProgram := FALSE;
				STMotionDone := FALSE;
				gMotionInterface.Done := TRUE;
				RobotState := ROBOT_MOVE_DONE;
				Robot.Interrupt := TRUE;
			END_IF;
		
		ROBOT_MOVE_DONE:
			IF NOT gMotionInterface.Execute THEN
				gMotionInterface.Done := FALSE;
				Robot.Interrupt := FALSE;
				RobotState := ROBOT_HOMED;
			END_IF;
			
	END_CASE;
	
	IF NOT gMotionInterface.Enable THEN
		RobotState := ROBOT_DISABLED;
		Robot.ErrorReset := 1;
		Robot.Power := 0;
		mcGroupHome.Execute := 0;
		Robot.Jog := 0;
		Robot.MoveProgram := 0;
		Robot.Interrupt := 1;
	END_IF;
	
	RTrigSTMotionDone();
	RTrigExecute();
	mcGroupHome();
	Robot();
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM

