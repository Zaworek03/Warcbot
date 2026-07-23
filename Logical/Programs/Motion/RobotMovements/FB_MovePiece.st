
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_MovePiece
	
	AnyPickPiece := FALSE;
	AnyPickMove := FALSE;

	FOR Row := 1 TO 8 DO
		FOR Col := 1 TO 8 DO
			IF PickPiece[Row, Col] THEN AnyPickPiece := TRUE; END_IF;
			IF PickMove[Row, Col] THEN AnyPickMove := TRUE; END_IF;
		END_FOR;
	END_FOR;

	(* --- KROK 2: MASZYNA STANÓW --- *)
	CASE iState OF
		0: (* Oczekiwanie na sygna³ od gracza *)
			(* Teraz Twoja logika: jeœli gracz wybra³ pionek I cel, startujemy *)
			IF AnyPickPiece AND AnyPickMove THEN 
				iState := 10;
			END_IF;
		10: (* STAN: Wyznaczenie wspó³rzêdnych *)
			FOR Row := 1 TO 8 DO
				FOR Col := 1 TO 8 DO
					IF PickPiece[Row,Col] THEN
						Motion.StartPos := PositionMatrix[Row,Col];
					END_IF;
					IF PickMove[Row,Col] THEN
						Motion.EndPos := PositionMatrix[Row,Col];
					END_IF;
				END_FOR;
			END_FOR;
        
			Motion.Move := TRUE; (* Wyzwalacz ruchu - tylko raz! *)
			iState := 20;

		20: (* STAN: Oczekiwanie na zakoñczenie ruchu *)
			IF Motion.Done THEN (* Za³ó¿my, ¿e Motion ma wyjœcie Done *)
				Motion.Move := FALSE; (* Reset sygna³u dla kolejnego ruchu *)
				iState := 30;
			END_IF;

		30: (* STAN: Reset danych silnika warcabów *)
			FOR Row := 1 TO 8 DO
				FOR Col := 1 TO 8 DO
					PickPiece[Row, Col] := FALSE;
					PickMove[Row, Col] := FALSE;
				END_FOR;
			END_FOR;
		iState := 0; (* Powrót do oczekiwania *)
	END_CASE;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	FOR Row := 1 TO 8 DO
		FOR Col := 1 TO 8 DO

			IF PickPiece[Row,Col] THEN
				Motion.StartPos := PositionMatrix[Row,Col];
			END_IF;

			IF PickMove[Row,Col] THEN
				Motion.EndPos := PositionMatrix[Row,Col];
			END_IF;

		END_FOR;
	END_FOR;

	Motion.Move := TRUE;
END_FUNCTION_BLOCK
