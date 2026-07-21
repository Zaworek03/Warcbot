
PROGRAM _INIT
	(* Insert code here *)
	DirCreate_0(enable := TRUE, pDevice := ADR('USER'), pName := ADR('SavedGames'));
	
	MpRecipeXml_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), FileName := ADR('Save'));
	MpRecipeRegPar_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, PVName := ADR('SaveGame:Save'));
	
	MpRecipeUI_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), UIConnect := ADR(UIConnect));
	UIConnect.Recipe.SortOrder := mpRECIPE_UI_SORT_DATE_DESCENDING;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	MpRecipeUI_0();
	
	IF NSDialogOpen THEN
		Saved := FALSE;
		InvSavFileName := FALSE;
		NSDialogOpen := FALSE;
	END_IF;
	
	CurrentFileName := UIConnect.Recipe.List.Names[UIConnect.Recipe.List.SelectedIndex];
	
	IF UIConnect.Recipe.List.MaxSelection >= 19 THEN
		IndexOOR := TRUE;
		NIndexOOR := FALSE;
	ELSE
		IndexOOR := FALSE;
		NIndexOOR := TRUE;
	END_IF
	
	IF UIConnect.Status = mpRECIPE_UI_STATUS_IDLE THEN

		IF NewSave AND NOT IndexOOR THEN
			Saved := FALSE;
			InvSavFileName := FALSE;
			FB_ValidateFileName_0(sUserInput := SaveFileName);
			IF FB_ValidateFileName_0.bIsValid THEN
				UIConnect.New.FileName := FB_ValidateFileName_0.sValidName;
				UIConnect.New.Create := TRUE;
				SaveFileName := '';
				Saved := TRUE;
				NewSave := FALSE;
			ELSE
				InvSavFileName := TRUE;
				NewSave := FALSE;
			END_IF;
		
		END_IF;
	
		IF Load THEN
			UIConnect.Recipe.Load := TRUE;
			gBoardActual := Save.BoardActual;
			Load := FALSE;
		END_IF;
	
		IF DeleteSave THEN
			UIConnect.Recipe.Delete := TRUE;
			DeleteSave := FALSE;
		END_IF
	END_IF;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpRecipeXml_0(Enable := FALSE);
	MpRecipeRegPar_0(Enable := FALSE);
	MpRecipeUI_0(Enable := FALSE);

END_PROGRAM

