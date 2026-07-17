
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	gRobotJog.MpLink := ADR(gAxesGroup); 
	gRobotJog.Parameters := ADR(gRobotJogPar);
	gRobotJog.Enable := TRUE;

	gRobotJog();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

