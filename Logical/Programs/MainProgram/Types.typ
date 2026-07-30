
TYPE
	RobotMoveEnum : 
		(
		IdleRM,
		MoveExecute,
		MoveBusy,
		DiscardExecute,
		DiscardBusy,
		EndRM
		);
	SetBoardInfoType : 	STRUCT 
		Index : IndexPointType;
		Color : USINT; (*White = 1; Black = 2*)
	END_STRUCT;
	SetBoardEnum : 
		(
		SetBoardCommandGen,
		SetBoardExecute,
		SetBoardBusy
		);
	CommandType : 	STRUCT 
		EndPos : McPosType;
		StartPos : McPosType;
	END_STRUCT;
END_TYPE
