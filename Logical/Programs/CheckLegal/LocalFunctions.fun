
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
