
TYPE
	Save_type : 	STRUCT 
		BoardActual : ARRAY[1..8,1..8]OF USINT := [2,0,2,0,2,0,2,2(0),2,0,2,0,2,0,2(2),0,2,0,2,0,2,18(0),1,0,1,0,1,0,2(1),0,1,0,1,0,1,2(0),1,0,1,0,1,0,1];
		PlayerColor : BOOL := FALSE;
		MoveHistory : ARRAY[1..4]OF STRING[20];
		MoveCount : INT;
		DifficultyLevel : USINT := 0;
	END_STRUCT;
END_TYPE
