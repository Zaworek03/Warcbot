
PROGRAM _INIT
	gAxesGroup_Racer3_1;
	gAxisQ1_Racer3_1;
	gAxisQ2_Racer3_1;
	gAxisQ3_Racer3_1;
	gAxisQ4_Racer3_1;
	gAxisQ5_Racer3_1;
	gAxisQ6_Racer3_1;
	
	mcGroupHome.AxesGroup := ADR(gAxesGroup_Racer3_1);
	FOR i := 0 TO 5 DO
		mcGroupHome.HomingMode[i] := mcHOMING_DIRECT;
		mcGroupHome.Position[i] := AxisPos[i];
	END_FOR;
	
	RobotPar.ProgramName := 'move.st';
	
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
	// TRZEBA ZROBIÆ POPRAWNY EXIT
	// TRZEBA ZROBIÆ SYNCHRONIZACJE
	ExecuteImpulse := RTrigExecute.Q;
	RTrigExecute.CLK := gMotionInterface.Execute;
	
	CASE RobotState OF
		ROBOT_ENABLED:
			Robot.Power := TRUE;
			IF Robot.PowerOn THEN
				RobotState := ROBOT_POWERED;
			END_IF;
			
		ROBOT_POWERED:
			mcGroupHome.Execute := TRUE;
			IF mcGroupHome.Done THEN
				RobotState := ROBOT_HOMED;
				mcGroupHome.Execute := FALSE;
			END_IF;
			
			mcGroupHome();
		
		ROBOT_HOMED:
			IF gMotionInterface.RequestManualMode THEN
				RobotState := ROBOT_MANUAL;
			ELSIF gMotionInterface.Execute THEN
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
			ELSE
				// tryb JogCartesian
				IF JogXPos OR JogXNeg OR JogYPos OR JogYNeg OR JogZPos OR JogZNeg THEN
					RobotPar.Jog.CoordSystem := mcMCS; // lub inny
					Robot.Jog := TRUE;
				END_IF;
		
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
				
				IF NOT gMotionInterface.RequestManualMode THEN
					RobotState := ROBOT_HOMED;
				END_IF;
				
			
			END_IF;
		ROBOT_EXECUTE:
			
			IF ExecuteImpulse THEN // impuls jest po to zeby nie dalo sie zmienic parametrow w czasie
				STMotionStartPoint.Pos := gMotionInterface.StartPos;
				STMotionStartPoint.Orient := STMotionDefaultOrient;
				
				// Ustalanie na jaka pozycje warcab ma byc odstawiony
				CASE gMotionInterface.Command OF
					MOVE_START_END:
						STMotionEndPoint.Pos := gMotionInterface.EndPos;
					DISCARD_WHITE:
						PileCalculatedOffs.X := WhitePileXOffs*USINT_TO_REAL(WhitePileCnt/PileHeight);
						PileCalculatedOffs.Y := 0;
						PileCalculatedOffs.Z := PileZOffs*USINT_TO_REAL(WhitePileCnt MOD PileHeight);
						
						STMotionEndPoint.Pos.X := gMotionInterface.EndPos.X + PileCalculatedOffs.X;
						STMotionEndPoint.Pos.Y := gMotionInterface.EndPos.Y + PileCalculatedOffs.Y;
						STMotionEndPoint.Pos.Z := gMotionInterface.EndPos.Z + PileCalculatedOffs.Z;
					DISCARD_BLACK:
						PileCalculatedOffs.X := BlackPileXOffs*USINT_TO_REAL(BlackPileCnt/PileHeight);
						PileCalculatedOffs.Y := 0;
						PileCalculatedOffs.Z := PileZOffs*USINT_TO_REAL(BlackPileCnt MOD PileHeight);
						
						STMotionEndPoint.Pos.X := gMotionInterface.EndPos.X + PileCalculatedOffs.X;
						STMotionEndPoint.Pos.Y := gMotionInterface.EndPos.Y + PileCalculatedOffs.Y;
						STMotionEndPoint.Pos.Z := gMotionInterface.EndPos.Z + PileCalculatedOffs.Z;
				END_CASE;
				
				Robot.MoveProgram := TRUE;
				STMotionEndPoint.Orient := STMotionDefaultOrient;
				
				gMotionInterface.Busy := TRUE;
			END_IF;
			
			IF STMotionDone THEN
				gMotionInterface.Busy := FALSE;
				RobotState := ROBOT_HOMED;
				Robot.MoveProgram := FALSE;
				STMotionDone := FALSE;
			END_IF;
		
	END_CASE;
	
	RTrigExecute();
	Robot();	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM

