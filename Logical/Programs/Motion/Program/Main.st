
PROGRAM _INIT
	(* Insert code here *)
	gAxesGroup_Racer3_1;
	gAxisQ1_Racer3_1;
	gAxisQ2_Racer3_1;
	gAxisQ3_Racer3_1;
	gAxisQ4_Racer3_1;
	gAxisQ5_Racer3_1;
	gAxisQ6_Racer3_1;
	
	Robot.MpLink := ADR(gAxesGroup_Racer3_1);
	Robot.Enable := 1;
	Robot.ErrorReset := 0;
	Robot.Parameters := ADR(RobotPar);
	Robot.Update := 1;
	Robot();
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	Robot.Update := 0;
	Robot();

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

