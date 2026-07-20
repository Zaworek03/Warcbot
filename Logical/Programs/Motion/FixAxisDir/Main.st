
PROGRAM _INIT
	
END_PROGRAM

PROGRAM _CYCLIC
	AxisQ1Pos := -Robot.Info.JointAxisPosition[0];
	AxisQ2Pos := Robot.Info.JointAxisPosition[1];
	AxisQ3Pos := -Robot.Info.JointAxisPosition[2];
	AxisQ4Pos := Robot.Info.JointAxisPosition[3];
	AxisQ5Pos := Robot.Info.JointAxisPosition[4];
	AxisQ6Pos := Robot.Info.JointAxisPosition[5];
END_PROGRAM

PROGRAM _EXIT
	
END_PROGRAM

