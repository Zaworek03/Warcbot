
TYPE
	PlayerColorEnum : 
		(
		WHITE,
		BLACK
	);
	DifficultyLevelEnum : 
		(
		HARD,
		MEDIUM,
		EASY
	);
	GameStateEnum : 
		(
		WAITING_PLAYER, (*oczekiwanie na ruch gracza*)
		IDLE, (*oczekiwanie na rozpocz?cie gry*)
		CHECKING_MOVE, (*sprawdzanie poprawno?ci ruchu*)
		CHECKING_BOARD, (*weryfikacja planszy po ruchu*)
		ROBOT_MOVE, (*robot wykonuje ruch*)
		FINISHED (*koniec gry*)
	);
	PieceTypeEnum : 
		(
		EMPTY,
		BLACK_KING,
		BLACK,
		WHITE_KING,
		WHITE
	);
	WinnerEnum : 
		(
		ROBOT,
		PLAYER,
		NONE
	);
	PositionStruct :     STRUCT 
		Z : REAL;
		Y : REAL;
		X : REAL;
	END_STRUCT;
	MoveStruct :     STRUCT 
		TO_COLUMN : INT;
		TO_ROW : INT;
		FROM_COLUMN : INT;
		FROM_ROW : INT;
	END_STRUCT;
END_TYPE