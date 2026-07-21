
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_ValidateFileName
(* Logic *)
	bIsValid := TRUE;
	sValidName := sUserInput;

	// 1. Check for empty input
	IF sUserInput = '' THEN
		bIsValid := FALSE;
	ELSE
		// 2. Sanitize string
		// We use LEN(sValidName) to get the current length of the string
		FOR i := 0 TO brsstrlen(ADR(sValidName)) - 1 DO
			// 1. READ: Copy current character from string into tempChar
			brsmemcpy(ADR(tempChar), ADR(sValidName) + i, 1);
    
			// 2. CHECK: Use tempChar for all comparisons
			IF tempChar = 32 THEN
				// WRITE: Copy underscore back into the string at position i
				brsmemcpy(ADR(sValidName) + i, ADR(underscore), 1);
        
			ELSIF tempChar = 92 OR tempChar = 47 OR // \ and /
				tempChar = 58 OR tempChar = 42 OR // : and *
				tempChar = 63 OR tempChar = 34 OR // ? and "
				tempChar = 60 OR tempChar = 62 OR // < and >
				tempChar = 124 THEN               // |
        
				bIsValid := FALSE;
				EXIT; 
			END_IF
		END_FOR
	END_IF
END_FUNCTION_BLOCK
