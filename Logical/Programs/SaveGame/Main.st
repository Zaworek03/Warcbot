
PROGRAM _INIT
	(* Insert code here *)
	MpRecipeXml_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), FileName := ADR('Game_save'));
	MpRecipeRegPar_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, PVName := ADR('SaveGame:IceFormula'));
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpRecipeXml_0(Enable := FALSE);
	MpRecipeRegPar_0(Enable := FALSE);

END_PROGRAM

