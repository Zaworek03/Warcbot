
TYPE
	MotionInterfaceType : 	STRUCT 
		RequestManualMode : BOOL;
		StartPos : McPosType;
		EndPos : McPosType;
		PilePos : McPosType;
		Move : BOOL; (*Przesuniêcie warcaba ze StartPos na EndPos*)
		Discard : BOOL; (*Od³o¿enie warcaba ze StartPos na stos*)
		Done : BOOL; (*Oznacza zakoñczenie ruchu robota*)
		Busy : BOOL;
	END_STRUCT;
END_TYPE
