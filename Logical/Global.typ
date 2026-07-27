
TYPE
	AlarmEnum : 	STRUCT 
		EstopActive : BOOL; (*E stop zostal zalaczony*)
		InncorrectRobotMove : BOOL; (*Zle przeniesienie pionka przez robota*)
		InncorrectBoard : BOOL; (*Zla plansza do startu gry*)
		FolderError : USINT;
		MissingSTMotionProgram : USINT; (*Brakuje programu ST Motion*)
		RobotProgramNotLoaded : BOOL; (*Program (napisany w STMotion) nie istnieje w pami�ci USER robota*)
		RobotWorkspaceViolation : BOOL; (*TCP robota znalaz�o si� poza dozwolonym obszarem - robot nie mo�e kontynuowa� ruchu w tym kierunku*)
		RobotAxisViolation : BOOL; (*Robota przekroczy� maksymaln� pozycj� k�tow� w kt�rej� z osi*)
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
