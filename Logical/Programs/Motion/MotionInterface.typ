
TYPE
	MotionInterfaceType : 	STRUCT 
		RequestManualMode : BOOL;
		StartPos : McPosType; (*Sk¹d przenieœæ pionek*)
		EndPos : McPosType;
		WhitePilePos : McPosType; (*Pozycja 1szego miejsca na stosie, reszta jest juz obliczana przez program*)
		BlackPilePos : McPosType; (*Pozycja 1szego miejsca na stosie, reszta jest juz obliczana przez program*)
		Command : RobotCommandType; (*Przesuniêcie warcaba ze StartPos na EndPos*)
		Execute : BOOL; (*Najlepiej podac impuls*)
		Busy : BOOL;
		Manual : ManualType;
	END_STRUCT;
	RobotCommandType : 
		(
		MOVE_START_END, (*Przesuniecie ze StartPos na EndPos*)
		DISCARD_WHITE, (*Przesuniecie ze StartPos na stos bialych*)
		DISCARD_BLACK (*Przesuniecie ze StartPos na stos czarnych*)
		);
	ManualType : 	STRUCT 
		Joint : JogJointType;
		Cartesian : JogCartesianType;
		Info : ManualInfoType;
	END_STRUCT;
	JogJointType : 	STRUCT 
		JogPos0 : BOOL;
		JogPos1 : BOOL;
		JogPos2 : BOOL;
		JogPos3 : BOOL;
		JogPos4 : BOOL;
		JogPos5 : BOOL;
		JogNeg0 : BOOL;
		JogNeg1 : BOOL;
		JogNeg2 : BOOL;
		JogNeg3 : BOOL;
		JogNeg4 : BOOL;
		JogNeg5 : BOOL;
		Speed : REAL := 30;
	END_STRUCT;
	JogCartesianType : 	STRUCT 
		JogXPos : BOOL;
		JogXNeg : BOOL;
		JogYPos : BOOL;
		JogYNeg : BOOL;
		JogZPos : BOOL;
		JogZNeg : BOOL;
		Speed : REAL := 30;
	END_STRUCT;
	ManualInfoType : 	STRUCT 
		Axis1Pos : REAL;
		Axis2Pos : REAL;
		Axis3Pos : REAL;
		Axis4Pos : REAL;
		Axis5Pos : REAL;
		Axis6Pos : REAL;
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE
