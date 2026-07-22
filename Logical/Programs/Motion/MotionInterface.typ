
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
	END_STRUCT;
	JogJointType : 	STRUCT 
		SelJoint : USINT;
		JogPos : BOOL;
		JogNeg : BOOL;
		Speed : REAL;
	END_STRUCT;
	JogCartesianType : 	STRUCT 
		JogXPos : BOOL;
		JogXNeg : BOOL;
		JogYPos : BOOL;
		JogYNeg : BOOL;
		JogZPos : BOOL;
		JogZNeg : BOOL;
		Speed : REAL;
	END_STRUCT;
END_TYPE
