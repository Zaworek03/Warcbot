
PROGRAM _INIT
	(* Tworzenie folderu *)
	DirCreate_0(enable := TRUE, pDevice := ADR('USER'), pName := ADR('SavedGames'));
	DirCreate_0(enable := FALSE);
	
	(* W³¹czenie Bloków Funkcyjnych MpRecipe *)
	MpRecipeXml_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), FileName := ADR('Save'));
	MpRecipeRegPar_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, PVName := ADR('SaveGame:Save'));
	
	(* W³¹czenie Bloków Funkcyjnych z UI *)
	MpRecipeUI_0(MpLink := ADR(MpLinkgRecipeSR), Enable := TRUE, DeviceName := ADR('SG'), UIConnect := ADR(UIConnect));
	UIConnect.Recipe.SortOrder := mpRECIPE_UI_SORT_DATE_DESCENDING;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Function Bloki *)
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	MpRecipeUI_0();
	
	(* Czyszczenie komunikatów po otwrciu / zamkniêciu okna *)
	IF NSDialogOpen THEN
		Saved := FALSE;
		InvSavFileName := FALSE;
		NSDialogOpen := FALSE;
	END_IF;
	
	CurrentFileName := UIConnect.Recipe.List.Names[UIConnect.Recipe.List.SelectedIndex];
	
	(* Sprawdzanie czy jest mniej plików ni¿ max *)
	IndexOOR := UIConnect.Recipe.List.MaxSelection >= 19;
	NIndexOOR := UIConnect.Recipe.List.MaxSelection < 19;
	
	(* Zabezpieczenie przed ingerencj¹ w Function Blok podczas jego pracy *)
	IF UIConnect.Status = mpRECIPE_UI_STATUS_IDLE THEN
		
		(* Jeœli przycisk New save klikniêty i jest mniej ni¿ max plików 
		sprawdŸ nazwê i mo¿liwie stwórz nowy plik. Wyœwietl komunikaty *)
		IF NewSave AND NOT IndexOOR THEN
			Saved := FALSE;
			InvSavFileName := FALSE;
			FB_ValidateFileName_0(sUserInput := SaveFileName);
			IF FB_ValidateFileName_0.bIsValid THEN
				Save.BoardActual := gBoardActual;
				Save.PlayerColor := gPlayerColor;
				Save.DifficultyLevel := gDifficultyLevel;
				
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
		
		(* £adowanie do zmiennej *)
		IF PreLoad THEN
			UIConnect.Recipe.Load := TRUE;
			PreLoad := FALSE;
		END_IF;
		
		(* Jeœli przycisk Load klikniêty przypisz zmienn¹ z danymi do zmiennej globalnej *)
		IF Load THEN
			gBoardActual := Save.BoardActual;
			gPlayerColor := Save.PlayerColor;
			gDifficultyLevel := Save.DifficultyLevel;
			LoadingDone := TRUE;
				
			gStart := TRUE;
			Load := FALSE;
		END_IF;
		
		(* Jeœli przycisk Delete klikniêty usuñ plik o wybranym indeksie *)
		IF DeleteSave THEN
			UIConnect.Recipe.Delete := TRUE;
			DeleteSave := FALSE;
		END_IF
	END_IF;
	
END_PROGRAM

PROGRAM _EXIT
	(* Wy³¹czenie Function Bloków *)
	MpRecipeXml_0(Enable := FALSE);
	MpRecipeRegPar_0(Enable := FALSE);
	MpRecipeUI_0(Enable := FALSE);

END_PROGRAM