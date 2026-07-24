PROGRAM _INIT
	step := 10;
END_PROGRAM

PROGRAM _CYCLIC
	CASE step OF
		10: (* CHECK: 'Programs' folder exists AND has exactly 2 files *)
			strPath := 'Programs';
			fbDirInfo.enable := TRUE;
			fbDirInfo.pDevice := ADR('USER');
			fbDirInfo.pPath := ADR(strPath);
			fbDirInfo();
            
			IF fbDirInfo.status = 0 THEN
				IF fbDirInfo.filenum <> 2 THEN
					gAlarm.MissingSTMotionProgram := TRUE;
				ELSE
					gAlarm.MissingSTMotionProgram := FALSE;
				END_IF;
				step := 20; (* Move to next folder check *)
			ELSIF fbDirInfo.status = 20723 THEN (* Folder doesn't exist *)
				step := 100; (* Go to create 'Programs' *)
			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 20;
			END_IF;

		20: (* CHECK: 'SavedGames' folder exists *)
			strPath := 'SavedGames';
			fbDirInfo.enable := TRUE;
			fbDirInfo.pDevice := ADR('USER');
			fbDirInfo.pPath := ADR(strPath);
			fbDirInfo();
            
			IF fbDirInfo.status = 0 THEN
				step := 30;
			ELSIF fbDirInfo.status = 20723 THEN
				step := 110; (* Go to create 'SavedGames' *)
			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 30;
			END_IF;

		30: (* CHECK: 'AlarmHistory' folder exists *)
			strPath := 'AlarmHistory';
			fbDirInfo.enable := TRUE;
			fbDirInfo.pDevice := ADR('USER');
			fbDirInfo.pPath := ADR(strPath);
			fbDirInfo();
            
			IF fbDirInfo.status = 0 THEN
				step := 40;
			ELSIF fbDirInfo.status = 20723 THEN
				step := 120; (* Go to create 'AlarmHistory' *)
			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 40;
			END_IF;

		40: (* Loop reset - start checking again next cycle *)
			step := 10;

			(* CREATION SEQUENCE *)
		100: (* Create Programs *)
			strPath := 'Programs';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();
			IF fbDirCreate.status = 0 THEN step := 10; ELSIF fbDirCreate.status <> 65535 THEN step := 999; END_IF;

		110: (* Create SavedGames *)
			strPath := 'SavedGames';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();
			IF fbDirCreate.status = 0 THEN step := 20; ELSIF fbDirCreate.status <> 65535 THEN step := 999; END_IF;

		120: (* Create AlarmHistory *)
			strPath := 'AlarmHistory';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();
			IF fbDirCreate.status = 0 THEN step := 30; ELSIF fbDirCreate.status <> 65535 THEN step := 999; END_IF;

		999: (* Error *)
			gAlarm.FolderError := TRUE;
			step := 10; 
	END_CASE;
END_PROGRAM

PROGRAM _EXIT
  (* Insert code here *)
    
END_PROGRAM
      