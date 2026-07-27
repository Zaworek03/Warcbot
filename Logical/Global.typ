
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
		PhotoCheck1, (*Pierwsze zdjecie sprawdzajace czy wszytskie pionki sa na swoich miejscach*)
		CountPiece, (*Jezeli nie policz wszystkie pionki oraz oblicz ile jest ich w magazynach*)
		ArrangeBoard, (*Ulozenie planszy do rozpoczecia gry*)
		InncorrectBoard1, (*Alarm ze nie udalo sie ulozyc planszy do gry*)
		RobotMove, (*Ruch robota przestawiajacy pionki*)
		PhotoCheck2, (*Drugie zdjecie sprawdzajace poprawnosci odlozenia pionkow*)
		InncorrectBoard2, (*Alarm ze robot nie odniosl pionka we wlasciwe miejce *)
		Idle, (*Czekanie na start = 1*)
		WinOrLoseState (*Wygrana albo przegrana*)
		);
END_TYPE
