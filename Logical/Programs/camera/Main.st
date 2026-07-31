PROGRAM _INIT

	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.AcquireImage := FALSE;
	
	gCameraAutoAdjust := FALSE;
	PreviousCameraAutoAdjust := FALSE;
		
	gCameraExposureTime := 20884;
	gCameraGainLevel := 4;
	gCameraFocus := 53073;

	gCameraCtrl.Parameters.ExposureTime := gCameraExposureTime;
	gCameraCtrl.Parameters.SetFocus := gCameraFocus;
	gCameraCtrl.Parameters.GainLevel := gCameraGainLevel;
	gCameraCtrl.Parameters.FlashColor := 3;
	gCameraCtrl.Parameters.FlashSegment := 1;
	
	gCameraCtrl.Parameters.ScoreMin := 75;
	gCameraCtrl.Parameters.NumSearchMax := 26;

	gCameraCtrl.Calibration.ReferenceTopLeftX := 41009;
	gCameraCtrl.Calibration.ReferenceTopLeftY := 14517;
	gCameraCtrl.Calibration.ReferenceTopRightX := 120526;
	gCameraCtrl.Calibration.ReferenceTopRightY := 12412;

	gCameraCtrl.Calibration.ReferenceBottomLeftX := 41915;
	gCameraCtrl.Calibration.ReferenceBottomLeftY := 91572;

	gCameraCtrl.Calibration.ReferenceBottomRightX := 121154;
	gCameraCtrl.Calibration.ReferenceBottomRightY := 90368;

	gCameraCtrl.Calibration.ReferenceMarker3X := 41009;
	gCameraCtrl.Calibration.ReferenceMarker3Y := 14517;

	gCameraCtrl.Calibration.ReferenceMarker4X := 121154;
	gCameraCtrl.Calibration.ReferenceMarker4Y := 90368;

	gCameraCtrl.Calibration.MarkersValid := FALSE;

	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := FALSE;
	gCameraCtrl.WhiteCount := 0;
	gCameraCtrl.BlackCount := 0;

	gCameraEnd := FALSE;
	PreviousProcessingActive := FALSE;

END_PROGRAM


PROGRAM _CYCLIC

	gCameraCtrl.Cmd.Enable := TRUE;	
	
	(* Wyœwietlanie rzeczywistych wartoœci kamery *)
	gCameraReadExposureTime :=
	gCameraCtrl.Status.ReadExposureTime;

	gCameraReadGainLevel :=
	gCameraCtrl.Status.ReadGainLevel;

	gCameraReadFocus :=
	gCameraCtrl.Status.ReadFocus;


	(* Po wy³¹czeniu ustawiania zapisz znalezione parametry *)
	IF PreviousCameraAutoAdjust AND NOT gCameraAutoAdjust THEN

		gCameraExposureTime :=
		gCameraCtrl.Status.ReadExposureTime;

		gCameraGainLevel :=
		gCameraCtrl.Status.ReadGainLevel;

		gCameraFocus :=
		gCameraCtrl.Status.ReadFocus;

	END_IF;


	(* Poza automatycznym ustawianiem wysy³aj zapisane nastawy *)
	IF NOT gCameraAutoAdjust THEN

		gCameraCtrl.Parameters.ExposureTime :=
		gCameraExposureTime;

		gCameraCtrl.Parameters.GainLevel :=
		gCameraGainLevel;

		gCameraCtrl.Parameters.SetFocus :=
		gCameraFocus;

	END_IF;


	PreviousCameraAutoAdjust := gCameraAutoAdjust;
	
	IF gCameraTrigger
		AND NOT gCameraAutoAdjust
		AND NOT gCameraEnd
		AND gCameraCtrl.Status.AcquisitionReady
		AND NOT gCameraCtrl.Status.ProcessingActive
		AND (gCameraCtrl.Status.ProcessingError = 0) THEN
		gCameraCtrl.Cmd.AcquireImage := TRUE;
	END_IF;
	
	gCameraBlackCount := gCameraCtrl.BlackCount;
	gCameraWhiteCount := gCameraCtrl.WhiteCount;
	gCameraNumResults := gCameraCtrl.NumResults;
	
	IF NOT gCameraTrigger THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;
		gCameraEnd := FALSE;
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
		marker3Found := FALSE;
		marker4Found := FALSE;
		cellStepY := 0;

		FOR rowIndex := 1 TO 8 DO
			FOR columnIndex := 1 TO 8 DO
				gCameraCtrl.Board[rowIndex, columnIndex] := 0;
			END_FOR;
		END_FOR;

		FOR i := 1 TO 26 DO
			IF gCameraCtrl.NumResults >= i THEN

				IF (gCameraCtrl.Pieces[i].ModelNumber = 3)
					AND (gCameraCtrl.Pieces[i].Score >= 30) THEN

					IF NOT marker3Found THEN

						marker3X := gCameraCtrl.Pieces[i].PositionX;
						marker3Y := gCameraCtrl.Pieces[i].PositionY;

						marker4X := gCameraCtrl.Pieces[i].PositionX;
						marker4Y := gCameraCtrl.Pieces[i].PositionY;

						marker3Found := TRUE;

					ELSE

						IF gCameraCtrl.Pieces[i].PositionX < marker3X THEN

							marker4X := marker3X;
							marker4Y := marker3Y;

							marker3X := gCameraCtrl.Pieces[i].PositionX;
							marker3Y := gCameraCtrl.Pieces[i].PositionY;

						ELSIF gCameraCtrl.Pieces[i].PositionX > marker4X THEN

							marker4X := gCameraCtrl.Pieces[i].PositionX;
							marker4Y := gCameraCtrl.Pieces[i].PositionY;

						END_IF;

						marker4Found := TRUE;

					END_IF;

				END_IF;

			END_IF;
		END_FOR;

		gCameraCtrl.Calibration.MarkersValid := marker3Found AND marker4Found;

		IF gCameraCtrl.Calibration.MarkersValid THEN
			referenceVectorX := DINT_TO_LREAL(gCameraCtrl.Calibration.ReferenceMarker4X- gCameraCtrl.Calibration.ReferenceMarker3X);

			referenceVectorY := DINT_TO_LREAL(gCameraCtrl.Calibration.ReferenceMarker4Y- gCameraCtrl.Calibration.ReferenceMarker3Y);

			currentVectorX := DINT_TO_LREAL(marker4X - marker3X);

			currentVectorY := DINT_TO_LREAL(marker4Y - marker3Y);

			transformationDen := (referenceVectorX * referenceVectorX) + (referenceVectorY * referenceVectorY);

			IF transformationDen > 0.0 THEN

				transformationA := ((currentVectorX * referenceVectorX) + (currentVectorY * referenceVectorY)) / transformationDen;

				transformationB := ((currentVectorY * referenceVectorX) - (currentVectorX * referenceVectorY)) / transformationDen;

				transformationDen := (transformationA * transformationA) + (transformationB * transformationB);

				IF transformationDen > 0.0 THEN

					boardHeight := ((gCameraCtrl.Calibration.ReferenceBottomLeftY - gCameraCtrl.Calibration.ReferenceTopLeftY) +
					(gCameraCtrl.Calibration.ReferenceBottomRightY - gCameraCtrl.Calibration.ReferenceTopRightY)) / 2;

					IF boardHeight > 0 THEN
						cellStepY := boardHeight / 7;
					ELSE
						gCameraCtrl.BoardDataValid := FALSE;
					END_IF;

				ELSE
					gCameraCtrl.BoardDataValid := FALSE;
				END_IF;

			ELSE
				gCameraCtrl.BoardDataValid := FALSE;
			END_IF;

		ELSE
			gCameraCtrl.BoardDataValid := FALSE;
		END_IF;

		FOR i := 1 TO 26 DO

			gCameraCtrl.Pieces[i].Valid :=
			(gCameraCtrl.NumResults >= i)
			AND
			(gCameraCtrl.Pieces[i].Score >= gCameraCtrl.Parameters.ScoreMin)
			AND
			((gCameraCtrl.Pieces[i].ModelNumber = 1)
			OR
			(gCameraCtrl.Pieces[i].ModelNumber = 2));

			IF gCameraCtrl.Pieces[i].Valid
				AND gCameraCtrl.Calibration.MarkersValid
				AND (cellStepY > 0)
				AND (transformationDen > 0.0) THEN

				cornerRelativeX := DINT_TO_LREAL(gCameraCtrl.Pieces[i].PositionX - marker3X);

				cornerRelativeY := DINT_TO_LREAL(gCameraCtrl.Pieces[i].PositionY - marker3Y);

				transformedX := DINT_TO_LREAL(gCameraCtrl.Calibration.ReferenceMarker3X) +
				((transformationA * cornerRelativeX) + (transformationB * cornerRelativeY)) / transformationDen;

				transformedY := DINT_TO_LREAL(gCameraCtrl.Calibration.ReferenceMarker3Y) +
				((-transformationB * cornerRelativeX) + (transformationA * cornerRelativeY)) / transformationDen;

				relativeY := LREAL_TO_DINT(transformedY) - gCameraCtrl.Calibration.ReferenceTopLeftY;

				IF relativeY < -(cellStepY / 2)
					OR relativeY > (boardHeight + (cellStepY / 2)) THEN

					gCameraCtrl.Pieces[i].Valid := FALSE;
					gCameraCtrl.BoardDataValid := FALSE;

				ELSE

					currentLeftX :=
					LREAL_TO_DINT(
						DINT_TO_LREAL(
					gCameraCtrl.Calibration.ReferenceTopLeftX
					)
					+
					(
					DINT_TO_LREAL(
					gCameraCtrl.Calibration.ReferenceBottomLeftX
					- gCameraCtrl.Calibration.ReferenceTopLeftX
					)
					*
					DINT_TO_LREAL(relativeY)
					)
					/
					DINT_TO_LREAL(boardHeight)
					);

					currentRightX :=
					LREAL_TO_DINT(
						DINT_TO_LREAL(
					gCameraCtrl.Calibration.ReferenceTopRightX
					)
					+
					(
					DINT_TO_LREAL(
					gCameraCtrl.Calibration.ReferenceBottomRightX
					- gCameraCtrl.Calibration.ReferenceTopRightX
					)
					*
					DINT_TO_LREAL(relativeY)
					)
					/
					DINT_TO_LREAL(boardHeight)
					);

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

						relativeX :=
						LREAL_TO_DINT(transformedX) - currentLeftX;

						IF relativeX < -(cellStepX / 2)
							OR relativeX > (currentBoardWidth + (cellStepX / 2)) THEN

							gCameraCtrl.Pieces[i].Valid := FALSE;
							gCameraCtrl.BoardDataValid := FALSE;

						ELSE

							gCameraCtrl.Pieces[i].Column := DINT_TO_USINT((relativeX + (cellStepX / 2)) / cellStepX) + 1;

							gCameraCtrl.Pieces[i].Row := 9 - (DINT_TO_USINT((relativeY + (cellStepY / 2)) / cellStepY) + 1);

							IF (gCameraCtrl.Pieces[i].Column = 0)
								OR (gCameraCtrl.Pieces[i].Column > 8)
								OR (gCameraCtrl.Pieces[i].Row = 0)
								OR (gCameraCtrl.Pieces[i].Row > 8) THEN

								gCameraCtrl.Pieces[i].Valid := FALSE;
								gCameraCtrl.BoardDataValid := FALSE;

							ELSIF gCameraCtrl.Board[
								gCameraCtrl.Pieces[i].Row,
								gCameraCtrl.Pieces[i].Column
								] <> 0 THEN

								gCameraCtrl.Pieces[i].Valid := FALSE;
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
								ELSE
									gCameraCtrl.BlackCount :=
									gCameraCtrl.BlackCount + 1;
								END_IF;

							END_IF;

						END_IF;

					END_IF;

				END_IF;

			ELSE
				gCameraCtrl.Pieces[i].Valid := FALSE;
			END_IF;

			IF NOT gCameraCtrl.Pieces[i].Valid THEN
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

		gCameraCtrl.BoardReady :=
		gCameraCtrl.BoardDataValid
		AND (gCameraCtrl.Status.ProcessingError = 0);
		gCameraEnd := TRUE;
	END_IF;

	PreviousProcessingActive := gCameraCtrl.Status.ProcessingActive;

	IF gCameraTrigger
		AND (gCameraCtrl.Status.ProcessingError <> 0) THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;
		gCameraEnd := TRUE;
	END_IF;

END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := FALSE;
	gCameraCtrl.Calibration.MarkersValid := FALSE;

	gCameraEnd := FALSE;
	PreviousProcessingActive := FALSE;
	PreviousCameraAutoAdjust := FALSE;
	gCameraAutoAdjust := FALSE;

END_PROGRAM