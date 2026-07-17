
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK FB_MovePiece (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL;
		Error : {REDUND_UNREPLICABLE} BOOL;
		ErrorID : {REDUND_UNREPLICABLE} INT;
	END_VAR
	VAR
		Piece : {REDUND_UNREPLICABLE} PieceTypeEnum;
		OldPosition : {REDUND_UNREPLICABLE} PositionStruct;
		NewPosition : {REDUND_UNREPLICABLE} PositionStruct;
		Piece1 : BOOL;
		gBoardBoard : BOOL;
		gCurrentMove : structType;
		gBoard : BOOL;
	END_VAR
END_FUNCTION_BLOCK
