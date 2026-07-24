PROGRAM _INIT

	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;

	gCameraCtrl.Parameters.ExposureTime := 20884;
	gCameraCtrl.Parameters.SetFocus := 53073;
	gCameraCtrl.Parameters.GainLevel := 4;

	gCameraCtrl.Parameters.ScoreMin := 75;
	gCameraCtrl.Parameters.NumSearchMax := 24;


	gCameraCtrl.Calibration.TopLeftX := 31054;
	gCameraCtrl.Calibration.TopLeftY := 8435;

	gCameraCtrl.Calibration.TopRightX := 118132;
	gCameraCtrl.Calibration.TopRightY := 9073;

	gCameraCtrl.Calibration.BottomLeftX := 29851;
	gCameraCtrl.Calibration.BottomLeftY := 94668;

	gCameraCtrl.Calibration.BottomRightX := 117414;
	gCameraCtrl.Calibration.BottomRightY := 96517;


	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := FALSE;

	gCameraCtrl.WhiteCount := 0;
	gCameraCtrl.BlackCount := 0;

	gCameraEnd := FALSE;

	PreviousProcessingActive := FALSE;

END_PROGRAM


PROGRAM _CYCLIC

	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;

	IF NOT gCameraTrigger THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;
		gCameraEnd := FALSE;
	END_IF;

	IF gCameraTrigger
		AND NOT gCameraEnd
		AND gCameraCtrl.Cmd.Enable
		AND gCameraCtrl.Status.AcquisitionReady
		AND NOT gCameraCtrl.Status.ProcessingActive
		AND (gCameraCtrl.Status.ProcessingError = 0) THEN
		gCameraCtrl.Cmd.AcquireImage := TRUE;
	END_IF;


	IF gCameraCtrl.Status.ProcessingActive THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
	END_IF;


	IF gCameraTrigger
		AND PreviousProcessingActive
		AND NOT gCameraCtrl.Status.ProcessingActive THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardDataValid := TRUE;
		gCameraCtrl.WhiteCount := 0;
		gCameraCtrl.BlackCount := 0;


		FOR rowIndex := 1 TO 8 DO
			FOR columnIndex := 1 TO 8 DO
				gCameraCtrl.Board[rowIndex, columnIndex] := 0;
			END_FOR;
		END_FOR;


		boardHeight := ((gCameraCtrl.Calibration.BottomLeftY- gCameraCtrl.Calibration.TopLeftY) +
		(gCameraCtrl.Calibration.BottomRightY - gCameraCtrl.Calibration.TopRightY)) / 2;


		IF boardHeight > 0 THEN
			cellStepY := boardHeight / 7;
		ELSE
			cellStepY := 0;
			gCameraCtrl.BoardDataValid := FALSE;
		END_IF;


		FOR i := 1 TO 24 DO
			gCameraCtrl.Pieces[i].Valid := (gCameraCtrl.NumResults >= i)
			AND
			(gCameraCtrl.Pieces[i].Score >= gCameraCtrl.Parameters.ScoreMin);

			IF gCameraCtrl.Pieces[i].Valid
				AND (cellStepY > 0) THEN
				relativeY := gCameraCtrl.Pieces[i].PositionY - gCameraCtrl.Calibration.TopLeftY;


				IF relativeY < -(cellStepY / 2)
					OR relativeY > (boardHeight + (cellStepY / 2)) THEN
					gCameraCtrl.Pieces[i].Valid := FALSE;
					gCameraCtrl.Pieces[i].Row := 0;
					gCameraCtrl.Pieces[i].Column := 0;
					gCameraCtrl.BoardDataValid := FALSE;
				ELSE

					currentLeftX := gCameraCtrl.Calibration.TopLeftX + 
					((gCameraCtrl.Calibration.BottomLeftX- gCameraCtrl.Calibration.TopLeftX) * relativeY) / boardHeight;


					currentRightX := gCameraCtrl.Calibration.TopRightX +
					((gCameraCtrl.Calibration.BottomRightX - gCameraCtrl.Calibration.TopRightX) * relativeY) / boardHeight;


					currentBoardWidth := currentRightX - currentLeftX;


					IF currentBoardWidth > 0 THEN
						cellStepX := currentBoardWidth / 7;
					ELSE
						cellStepX := 0;
						gCameraCtrl.Pieces[i].Valid := FALSE;
						gCameraCtrl.BoardDataValid := FALSE;
					END_IF;


					IF gCameraCtrl.Pieces[i].Valid
						AND (cellStepX > 0) THEN
						relativeX := gCameraCtrl.Pieces[i].PositionX - currentLeftX;


						IF relativeX < -(cellStepX / 2)
							OR relativeX > (currentBoardWidth + (cellStepX / 2)) THEN
							gCameraCtrl.Pieces[i].Valid := FALSE;
							gCameraCtrl.Pieces[i].Row := 0;
							gCameraCtrl.Pieces[i].Column := 0;
							gCameraCtrl.BoardDataValid := FALSE;
						ELSE
							gCameraCtrl.Pieces[i].Column := DINT_TO_USINT((relativeX + (cellStepX / 2)) / cellStepX) + 1;
							gCameraCtrl.Pieces[i].Row := 9 - (DINT_TO_USINT((relativeY + (cellStepY / 2)) / cellStepY) + 1);


							IF gCameraCtrl.Pieces[i].Column = 0
								OR gCameraCtrl.Pieces[i].Column > 8 THEN
								gCameraCtrl.Pieces[i].Column := 0;
								gCameraCtrl.Pieces[i].Row := 0;
								gCameraCtrl.Pieces[i].Valid := FALSE;
								gCameraCtrl.BoardDataValid := FALSE;
							END_IF;


							IF gCameraCtrl.Pieces[i].Row = 0
								OR gCameraCtrl.Pieces[i].Row > 8 THEN
								gCameraCtrl.Pieces[i].Row := 0;
								gCameraCtrl.Pieces[i].Column := 0;
								gCameraCtrl.Pieces[i].Valid := FALSE;
								gCameraCtrl.BoardDataValid := FALSE;
							END_IF;


							IF gCameraCtrl.Pieces[i].Valid THEN

								IF (gCameraCtrl.Pieces[i].ModelNumber <> 1)
									AND
									(gCameraCtrl.Pieces[i].ModelNumber <> 2) THEN
									gCameraCtrl.Pieces[i].Valid := FALSE;
									gCameraCtrl.Pieces[i].Row := 0;
									gCameraCtrl.Pieces[i].Column := 0;
									gCameraCtrl.BoardDataValid := FALSE;
								END_IF;

							END_IF;


							IF gCameraCtrl.Pieces[i].Valid THEN

								IF gCameraCtrl.Board[
									gCameraCtrl.Pieces[i].Row,
									gCameraCtrl.Pieces[i].Column
									] <> 0 THEN

									gCameraCtrl.Pieces[i].Valid := FALSE;
									gCameraCtrl.Pieces[i].Row := 0;
									gCameraCtrl.Pieces[i].Column := 0;
									gCameraCtrl.BoardDataValid := FALSE;
								ELSE

									gCameraCtrl.Board[
									gCameraCtrl.Pieces[i].Row,
									gCameraCtrl.Pieces[i].Column
									] :=
									gCameraCtrl.Pieces[i].ModelNumber;


									IF gCameraCtrl.Pieces[i].ModelNumber = 1 THEN

										gCameraCtrl.WhiteCount :=
										gCameraCtrl.WhiteCount + 1;

									ELSIF
										gCameraCtrl.Pieces[i].ModelNumber = 2 THEN

										gCameraCtrl.BlackCount :=
										gCameraCtrl.BlackCount + 1;

									END_IF;

								END_IF;

							END_IF;

						END_IF;

					END_IF;

				END_IF;

			ELSE

				gCameraCtrl.Pieces[i].Valid := FALSE;
				gCameraCtrl.Pieces[i].Row := 0;
				gCameraCtrl.Pieces[i].Column := 0;

			END_IF;

		END_FOR;


		FOR rowIndex := 1 TO 8 DO
			FOR columnIndex := 1 TO 8 DO
				gBoardCamera[rowIndex, columnIndex] :=
				gCameraCtrl.Board[rowIndex, columnIndex];
			END_FOR;

		END_FOR;


		IF gCameraCtrl.Status.ProcessingError = 0 THEN
			gCameraCtrl.BoardReady := TRUE;
			gCameraEnd := TRUE;
		ELSE
			gCameraCtrl.BoardReady := FALSE;
			gCameraCtrl.BoardDataValid := FALSE;
			gCameraEnd := TRUE;
		END_IF;

	END_IF;


	PreviousProcessingActive := gCameraCtrl.Status.ProcessingActive;


	IF gCameraTrigger
		AND (gCameraCtrl.Status.ProcessingError <> 0) THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;
		gCameraEnd := TRUE;
	END_IF;


	IF NOT gCameraCtrl.Cmd.Enable THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;
		gCameraEnd := FALSE;
	END_IF;

END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := FALSE;

	gCameraEnd := FALSE;

	PreviousProcessingActive := FALSE;

END_PROGRAM