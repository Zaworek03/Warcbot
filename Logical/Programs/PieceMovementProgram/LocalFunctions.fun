
{REDUND_ERROR} FUNCTION CanPlayerCapture : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		PlayerColor : PlayerColorEnum;
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
	VAR
		Row : INT;
		Column : INT;
		Piece : PieceTypeEnum;
		WHITE_PLAYER : BOOL;
		BLACK_PLAYER : BOOL;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CheckMove : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		FromRow : INT;
		FromColumn : INT;
		ToRow : INT;
		ToColumn : INT;
		Piece : PieceTypeEnum;
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
	VAR
		RowDiff : INT;
		ColDiff : INT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CheckRegularCapture : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		FromRow : INT;
		FromColumn : INT;
		ToRow : INT;
		ToColumn : INT;
		Piece : PieceTypeEnum;
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
	VAR
		MiddlePiece : PieceTypeEnum;
		RowDiff : INT;
		ColDiff : INT;
		MiddleRow : INT;
		MiddleColumn : INT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK FB_InitGame (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_IN_OUT
		MovesWithoutCapture : INT;
		PlayerColor : PlayerColorEnum;
		Winner : WinnerEnum;
		GameState : GameStateEnum;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FB_MovePiece
	VAR_INPUT
		Execute : BOOL;
		FromRow : INT;
		FromColumn : INT;
		ToRow : INT;
		ToColumn : INT;
		Piece : PieceTypeEnum; (* Dodaj to tutaj! *)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (* Teraz Done jest poprawnym wyjœciem *)
	END_VAR
	VAR_IN_OUT
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FB_InitBoard (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
	END_VAR
	VAR_IN_OUT
		BoardBoard : ARRAY[1..8,1..8] OF PieceTypeEnum;
		GameState : GameStateEnum;
	END_VAR
	VAR
		Row : INT;
		Column : INT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION CanPieceCaptureAgain : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Row : INT;
		Column : INT;
		Piece : PieceTypeEnum;
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION_BLOCK FB_PromotePiece (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Execute : BOOL;
		Row : INT;
		Column : INT;
	END_VAR

	VAR_OUTPUT
		Done : BOOL;
	END_VAR

	VAR_IN_OUT
		Board : ARRAY[1..8,1..8] OF PieceTypeEnum;
	END_VAR
END_FUNCTION_BLOCK
