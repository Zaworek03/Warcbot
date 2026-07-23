
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK FB_MovePiece (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		PickPiece  : ARRAY[1..8,1..8] OF BOOL;
		PickMove   : ARRAY[1..8,1..8] OF BOOL;
		PositionMatrix : ARRAY[1..8,1..8] OF McPosType; 
	END_VAR

	VAR_IN_OUT
		Motion      : MotionInterfaceType;
	END_VAR

	VAR_OUTPUT
		Done        : BOOL;
		Busy        : BOOL;
	END_VAR
	
	VAR
    	iState : INT := 0;
		Row : INT;
		Col : INT;
		AnyPickPiece : BOOL; (* Flaga: czy jakikolwiek pionek jest wybrany *)
		AnyPickMove : BOOL;   (* Flaga: czy jakikolwiek ruch jest wybrany *)
	END_VAR
END_FUNCTION_BLOCK
