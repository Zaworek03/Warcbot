
PROGRAM _INIT
	AxisRestorePos0;
	AxisRestorePos1;
	AxisRestorePos2;
	AxisRestorePos3;
	AxisRestorePos4;
	AxisRestorePos5;
	
	GetCoordSystemIdent.Execute := TRUE;
	GetCoordSystemIdent.CoordSystemName := 'gUserFrame';
	
	GetCoordSystemIdent();
	
	CoordSystemIdent := GetCoordSystemIdent.Ident;
END_PROGRAM

PROGRAM _CYCLIC
	AxisQ1Pos := -Robot.Info.JointAxisPosition[0];
	AxisQ2Pos := Robot.Info.JointAxisPosition[1];
	AxisQ3Pos := -Robot.Info.JointAxisPosition[2];
	AxisQ4Pos := -Robot.Info.JointAxisPosition[3];
	AxisQ5Pos := Robot.Info.JointAxisPosition[4];
	AxisQ6Pos := -Robot.Info.JointAxisPosition[5];
	
//	X := Robot.X;
//	Y := Robot.Y;
	//	Z := Robot.Z;
	
	
	
	ReadActualPosition.AxesGroup := ADR(gAxesGroup_Racer3_1);
	ReadActualPosition.Enable := TRUE;
	ReadActualPosition.CoordSystem := CoordSystemIdent;
	
	X := ReadActualPosition.Position[0];
	Y := ReadActualPosition.Position[1];
	Z := ReadActualPosition.Position[2];
	
	gAlarm.RobotWorkspaceViolation := 0;
	gAlarm.RobotAxisViolation := 0;
	
	IF WorkspaceMonitor.WorkspaceStatus = mcPATHGEN_WS_WORKSPACE_VIOLATION 
		OR WorkspaceMonitor.WorkspaceStatus = mcPATHGEN_WS_SAFESPACE_VIOLATION
		OR WorkspaceMonitor.WorkspaceStatus = mcPATHGEN_WS_WORKRANGE_VIOLATION THEN
		gAlarm.RobotWorkspaceViolation := 1;
	END_IF;
	IF WorkspaceMonitor.WorkspaceStatus = mcPATHGEN_WS_AXES_VIOLATION
		OR WorkspaceMonitor.WorkspaceStatus = mcPATHGEN_WS_JOINTAXES_VIOLATION THEN
		gAlarm.RobotAxisViolation := 1;
	END_IF;
	
	GetCoordSystemIdent();
	ReadActualPosition();
	
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM

