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
				IF fbDirInfo.filenum <> 3 THEN
					gAlarm.MissingSTMotionProgram := TRUE;
				ELSE
					gAlarm.MissingSTMotionProgram := FALSE;
				END_IF;
				step := 20;

			ELSIF fbDirInfo.status = 20723 THEN
				step := 100;

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
				step := 110;

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
				step := 120;

			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 40;
			END_IF;


		40: (* CHECK: 'Report' folder exists *)
			strPath := 'Report';
			fbDirInfo.enable := TRUE;
			fbDirInfo.pDevice := ADR('USER');
			fbDirInfo.pPath := ADR(strPath);
			fbDirInfo();

			IF fbDirInfo.status = 0 THEN
				step := 50;

			ELSIF fbDirInfo.status = 20723 THEN
				step := 130;

			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 50;
			END_IF;


		50: (* CHECK: 'Audit' folder exists *)
			strPath := 'Audit';
			fbDirInfo.enable := TRUE;
			fbDirInfo.pDevice := ADR('USER');
			fbDirInfo.pPath := ADR(strPath);
			fbDirInfo();

			IF fbDirInfo.status = 0 THEN
				step := 60;

			ELSIF fbDirInfo.status = 20723 THEN
				step := 140;

			ELSIF fbDirInfo.status <> 65535 THEN
				gAlarm.FolderError := TRUE;
				step := 60;
			END_IF;


		60: (* Loop reset *)
			step := 10;


			(* ===================== *)
			(* CREATION SEQUENCE     *)
			(* ===================== *)

		100: (* Create Programs *)
			strPath := 'Programs';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();

			IF fbDirCreate.status = 0 THEN
				step := 10;
			ELSIF fbDirCreate.status <> 65535 THEN
				step := 999;
			END_IF;


		110: (* Create SavedGames *)
			strPath := 'SavedGames';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();

			IF fbDirCreate.status = 0 THEN
				step := 20;
			ELSIF fbDirCreate.status <> 65535 THEN
				step := 999;
			END_IF;


		120: (* Create AlarmHistory *)
			strPath := 'AlarmHistory';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();

			IF fbDirCreate.status = 0 THEN
				step := 30;
			ELSIF fbDirCreate.status <> 65535 THEN
				step := 999;
			END_IF;


		130: (* Create Report *)
			strPath := 'Report';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();

			IF fbDirCreate.status = 0 THEN
				step := 40;
			ELSIF fbDirCreate.status <> 65535 THEN
				step := 999;
			END_IF;


		140: (* Create Audit *)
			strPath := 'Audit';
			fbDirCreate.enable := TRUE;
			fbDirCreate.pDevice := ADR('USER');
			fbDirCreate.pName := ADR(strPath);
			fbDirCreate();

			IF fbDirCreate.status = 0 THEN
				step := 50;
			ELSIF fbDirCreate.status <> 65535 THEN
				step := 999;
			END_IF;


		999: (* Error *)
			gAlarm.FolderError := TRUE;
			step := 10;

	END_CASE;
END_PROGRAM

PROGRAM _EXIT
  (* Insert code here *)
    
END_PROGRAM
      