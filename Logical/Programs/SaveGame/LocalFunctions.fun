
{REDUND_ERROR} FUNCTION_BLOCK FB_ValidateFileName (*Validating file name*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		sUserInput : {REDUND_UNREPLICABLE} STRING[80]; (*Zmienna wejœciowa ze sprawdzan¹ nazw¹ pliku*)
	END_VAR
	VAR_OUTPUT
		sValidName : STRING[80]; (*Zmienna wyjœciowa z poprawn¹ nazw¹ pliku*)
		bIsValid : BOOL; (*Zmienna informuj¹ca czy by³a mo¿liwoœæ dana poprawnej nazwy pliku na wyjœciu*)
	END_VAR
	VAR
		i : UDINT; (*zmienna do iteracji po stringu*)
		tempChar : BYTE; (*Zmienna do przechowywania akutalnie iterownaje litery*)
	END_VAR
	VAR CONSTANT
		UNDERSCORE : BYTE := 95; (*ASCII value for '_'*)
	END_VAR
END_FUNCTION_BLOCK
