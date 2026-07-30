
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
		Color : BOOL; (*White = True; Black = False*)
	END_STRUCT;
	SetBoardEnum : 
		(
		SetBoardCommandGen,
		SetBoardExecute,
		SetBoardBusy
		);
END_TYPE
