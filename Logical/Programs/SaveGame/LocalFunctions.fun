
{REDUND_ERROR} FUNCTION_BLOCK FB_ValidateFileName (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		sUserInput : {REDUND_UNREPLICABLE} STRING[80];
	END_VAR
	VAR_OUTPUT
		sValidName : STRING[80];
		bIsValid : BOOL;
	END_VAR
	VAR
		i : UDINT;
		tempChar : BYTE;
	END_VAR
	VAR CONSTANT
		underscore : BYTE := 95; (*ASCII value for '_'*)
	END_VAR
END_FUNCTION_BLOCK
