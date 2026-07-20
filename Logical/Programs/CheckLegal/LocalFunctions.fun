
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
