
PROGRAM _INIT
	(* Insert code here *)
	DirCreate_0(enable := TRUE, pDevice := ADR('USER'), pName := ADR('AlarmHistory'));
	DirCreate_0(enable := FALSE);
	
	MpAlarmXHistory_0(MpLink := ADR(MpLinkgAlarmXHistory), Enable := TRUE, DeviceName := ADR('AH'), FileName := ADR('Alarm_history'));
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXHistory_0();
	
	IF AHExport AND NOT MpAlarmXHistory_0.CommandBusy THEN
		MpAlarmXHistory_0.Export := TRUE;
		IF MpAlarmXHistory_0.CommandDone THEN
			MpAlarmXHistory_0.Export := FALSE;
			OpenExportDialog := TRUE;
			AHExport := FALSE;
		END_IF;
	END_IF;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpAlarmXHistory_0(Enable := FALSE);
	
END_PROGRAM

