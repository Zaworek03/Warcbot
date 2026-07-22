
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
	PieceTypeEnum : 
		(
		EMPTY,
		BLACK_KING,
		BLACK,
		WHITE_KING,
		WHITE
		);
	PositionStruct : 	STRUCT 
		Z : REAL;
		Y : REAL;
		X : REAL;
	END_STRUCT;
	MoveStruct : 	STRUCT 
		TO_COLUMN : INT;
		TO_ROW : INT;
		FROM_COLUMN : INT;
		FROM_ROW : INT;
	END_STRUCT;
END_TYPE
