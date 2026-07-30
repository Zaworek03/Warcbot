
TYPE
	JogCartesianType : 	STRUCT 
		JogXPos : BOOL;
		JogXNeg : BOOL;
		JogYPos : BOOL;
		JogYNeg : BOOL;
		JogZPos : BOOL;
		JogZNeg : BOOL;
		Speed : REAL := 30;
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
	ManualType : 	STRUCT 
		Joint : JogJointType;
		Cartesian : JogCartesianType;
		RequestRehomeRobot : BOOL;
		RequestGoHome : BOOL;
		UsingUCS : BOOL;
	END_STRUCT;
	MotionInterfaceType : 	STRUCT 
		RequestManualMode : BOOL;
		StartPos : McPosType; (*Sk¹d przenieœæ pionek*)
		EndPos : McPosType;
		WhitePilePos : McPosType; (*Pozycja 1szego miejsca na stosie, reszta jest juz obliczana przez program*)
		BlackPilePos : McPosType; (*Pozycja 1szego miejsca na stosie, reszta jest juz obliczana przez program*)
		Feedrate : RobotFeedrateType;
		Command : RobotCommandType; (*Przesuniêcie warcaba ze StartPos na EndPos*)
		Ready : BOOL;
		ReadyToPowerOn : BOOL;
		Execute : BOOL; (*Najlepiej podac impuls*)
		Busy : BOOL;
		Done : BOOL;
		Manual : ManualType;
		Enable : BOOL;
	END_STRUCT;
	RobotCommandType : 
		(
		MOVE_START_END, (*Przesuniecie ze StartPos na EndPos*)
		DISCARD_WHITE, (*Przesuniecie ze StartPos na stos bialych*)
		DISCARD_BLACK (*Przesuniecie ze StartPos na stos czarnych*)
		);
	RobotMoveVarType : 	STRUCT 
		DiscardColorWhite : BOOL := FALSE;
		Capture : BOOL := FALSE;
		StartPoint : IndexPointType;
		EndPoint : IndexPointType;
		DiscardPoint : IndexPointType;
		RTRMove : BOOL := FALSE; (*Ready to read move*)
	END_STRUCT;
	IndexPointType : 	STRUCT 
		x : USINT := 1;
		y : USINT := 1;
	END_STRUCT;
	RobotFeedrateType : 	STRUCT 
		High : LREAL := 5000;
		Low : LREAL := 500;
	END_STRUCT;
END_TYPE
