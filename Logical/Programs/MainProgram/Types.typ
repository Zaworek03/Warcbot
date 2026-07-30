
TYPE
	RobotMoveEnum : 
		(
		IdleRM,
		MoveExecute,
		MoveBusy,
		DiscardExecute,
		DiscardBusy,
		HomeExecute,
		HomeBusy,
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
		SetBoardBusy,
		SetBoardHomeExecute,
		SetBoardHomeBusy
		);
	CommandType : 	STRUCT 
		EndPos : McPosType;
		StartPos : McPosType;
	END_STRUCT;
END_TYPE
