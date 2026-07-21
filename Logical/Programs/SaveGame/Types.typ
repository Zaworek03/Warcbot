
TYPE
	Save_type : 	STRUCT 
		BoardActual : ARRAY[1..8,1..8]OF USINT := [1,0,1,0,1,0,1,2(0),1,0,1,0,1,0,2(1),0,1,0,1,0,1,18(0),2,0,2,0,2,0,2(2),0,2,0,2,0,2,2(0),2,0,2,0,2,0,2];
		MoveNum : USINT;
	END_STRUCT;
END_TYPE
