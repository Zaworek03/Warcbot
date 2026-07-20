
PROGRAM _INIT
	(* Insert code here *)
	MpAlarmXHistory_0(MpLink := ADR(MpLinkgAlarmXHistory), Enable := TRUE, DeviceName := ADR('SG'), FileName := ADR('Alarm_history'));
	
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXHistory_0();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpAlarmXHistory_0(Enable := FALSE);
	
END_PROGRAM

