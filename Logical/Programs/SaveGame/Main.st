
PROGRAM _INIT
	(* Insert code here *)
	MpRecipeXml_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), FileName := ADR('Save'));
	MpRecipeRegPar_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, PVName := ADR('SaveGame:IceFormula'));
	
	MpRecipeUI_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), UIConnect := ADR(UIConnect));
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	MpRecipeUI_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpRecipeXml_0(Enable := FALSE);
	MpRecipeRegPar_0(Enable := FALSE);
	MpRecipeUI_0(Enable := FALSE);

END_PROGRAM

