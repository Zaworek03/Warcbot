
TYPE
	AlarmEnum : 	STRUCT 
		EstopActive : BOOL; (*E stop zostal zalaczony*)
		InncorrectRobotMove : BOOL; (*Zle przeniesienie pionka przez robota*)
		InncorrectBoard : BOOL; (*Zla plansza do startu gry*)
		FolderError : USINT;
		MissingSTMotionProgram : USINT; (*Brakuje programu ST Motion*)
		RobotProgramNotLoaded : BOOL; (*Program (napisany w STMotion) nie istnieje w pamiï¿½ci USER robota*)
		RobotWorkspaceViolation : BOOL; (*TCP robota znalazï¿½o siï¿½ poza dozwolonym obszarem - robot nie moï¿½e kontynuowaï¿½ ruchu w tym kierunku*)
		RobotAxisViolation : BOOL; (*Robota przekroczyï¿½ maksymalnï¿½ pozycjï¿½ kï¿½towï¿½ w ktï¿½rejï¿½ z osi*)
		RobotRestorePosFail : BOOL; (*Nie uda³o siê wykonaæ bazowania za pomoc¹ restore pos podczas uruchamiania robota*)
	END_STRUCT;
	GameEnum : 	STRUCT 
		BoardActual : ARRAY[1..8,1..8]OF USINT;
		gPickPiece : ARRAY[1..8,1..8]OF BOOL;
		gEnableMove : ARRAY[1..8,1..8]OF BOOL;
		gPickMove : ARRAY[1..8,1..8]OF BOOL;
		gEnablePiece : ARRAY[1..8,1..8]OF BOOL;
	END_STRUCT;
	GameStatStruct : 	STRUCT 
		MoveCount : INT;
		MoveHistory : ARRAY[1..4]OF STRING[20];
		Load : BOOL;
	END_STRUCT;
	StepEnum : 
		(
		Idle, (*Czekanie na start = 1*)
		PhotoCheck, (*Drugie zdjecie sprawdzajace poprawnosci odlozenia pionkow po ruchu*)
		GameMove, (*Ruch warcabowy cz³owiek vs AI*)
		RobotMove, (*Robot wykonuje fizyczny ruch*)
		ErrorState,
		ResetRobotPos,
		SetBoard,
		SetBoardPrep
		);
END_TYPE
