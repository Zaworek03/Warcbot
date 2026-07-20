
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
				mcGroupHome.Execute := TRUE;
			END_IF;
			
			mcGroupHome();
		
		ROBOT_HOMED:
			IF gRequestManualMode THEN
				RobotState := ROBOT_MANUAL;
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
		
	
			IF JogJointPos OR JogJointNeg THEN
				// tryb JogJoint
				RobotPar.Jog.CoordSystem := mcJACS;
		
				IF JogJointPos THEN
					RobotPar.Jog.Velocity[SelJoint] := JogJointSpeed;
				ELSIF JogJointNeg THEN
					RobotPar.Jog.Velocity[SelJoint] := -JogJointSpeed;
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
			
			END_IF;		
	END_CASE;
	
	Robot();	
END_PROGRAM

PROGRAM _EXIT

END_PROGRAM

