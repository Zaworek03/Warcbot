
PROGRAM _INIT
	(* W³¹czenie Function Bloku MpAlarmXHistory *)
	MpAlarmXHistory_0(MpLink := ADR(MpLinkgAlarmXHistory), Enable := TRUE, DeviceName := ADR('AH'), FileName := ADR('Alarm_history'));
	 
END_PROGRAM

PROGRAM _CYCLIC
	MpAlarmXHistory_0();
	
	(* Jeœli MpAlarmXHistory nic nie robi, a przycisk export klikniêty -> wyexportuj i otwórz okno dialogowe *)
	IF AHExport AND NOT MpAlarmXHistory_0.CommandBusy THEN
		MpAlarmXHistory_0.Export := TRUE;
		IF MpAlarmXHistory_0.CommandDone THEN
			MpAlarmXHistory_0.Export := FALSE;
			OpenExportDialog := TRUE;
			AHExport := FALSE;
		END_IF;
	END_IF;
	
	IF AHClear AND NOT MpAlarmXHistory_0.CommandBusy THEN
		MpAlarmXHistory_0.Clear := TRUE;
		IF MpAlarmXHistory_0.CommandDone THEN
			AHClear := FALSE;
		END_IF;
	END_IF;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Wy³acz MpAlarmXHistory *)
	MpAlarmXHistory_0(Enable := FALSE);
	
END_PROGRAM

