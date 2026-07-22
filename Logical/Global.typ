
TYPE
	AlarmEnum : 	STRUCT 
		InncorrectBoard : BOOL;
	END_STRUCT;
	StepEnum : 
		(
		Idle,
		RobotMove,
		CheckVision
		);
	GameEnum : 	STRUCT 
		BoardActual : ARRAY[1..8,1..8]OF USINT;
		gPickPiece : ARRAY[1..8,1..8]OF BOOL;
		gEnableMove : ARRAY[1..8,1..8]OF BOOL;
		gPickMove : ARRAY[1..8,1..8]OF BOOL;
		gEnablePiece : ARRAY[1..8,1..8]OF BOOL;
	END_STRUCT;
END_TYPE
