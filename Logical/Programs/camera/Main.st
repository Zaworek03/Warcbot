PROGRAM _INIT
	gBoardCamera;
	gCameraEnd;
	
	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;

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

	PreviousProcessingActive := FALSE;

END_PROGRAM


PROGRAM _CYCLIC
	IF gStep = PhotoCheck1 OR gStep = PhotoCheck2 THEN
		gCameraCtrl.Cmd.AcquireImage := TRUE;
	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := TRUE;

		IF gCameraCtrl.Status.AcquisitionReady
			AND NOT gCameraCtrl.Status.ProcessingActive
			AND NOT gCameraCtrl.Cmd.AcquireImage THEN
			gCameraCtrl.Cmd.AcquireImage := TRUE;
		END_IF;

	IF NOT gCameraCtrl.Cmd.Enable THEN

		gCameraCtrl.Cmd.AcquireImage := FALSE;

	END_IF;


	IF gCameraCtrl.Cmd.AcquireImage
		AND NOT gCameraCtrl.Status.AcquisitionReady THEN

		gCameraCtrl.Cmd.AcquireImage := FALSE;

	END_IF;


	boardHeight :=
	(
	(gCameraCtrl.Calibration.BottomLeftY
	- gCameraCtrl.Calibration.TopLeftY)
	+
	(gCameraCtrl.Calibration.BottomRightY
	- gCameraCtrl.Calibration.TopRightY)
	) / 2;


	cellStepY := boardHeight / 7;


	gCameraCtrl.WhiteCount := 0;
	gCameraCtrl.BlackCount := 0;


	FOR rowIndex := 1 TO 8 DO

		FOR columnIndex := 1 TO 8 DO

			gCameraCtrl.Board[rowIndex, columnIndex] := 0;

		END_FOR;

	END_FOR;


	FOR i := 1 TO 24 DO

		gCameraCtrl.Pieces[i].Valid :=
		(gCameraCtrl.NumResults >= i)
		AND
		(gCameraCtrl.Pieces[i].Score
		>= gCameraCtrl.Parameters.ScoreMin);


		IF gCameraCtrl.Pieces[i].Valid THEN

			relativeY :=
			gCameraCtrl.Pieces[i].PositionY
			- gCameraCtrl.Calibration.TopLeftY;


			IF relativeY < -(cellStepY / 2)
				OR relativeY > (boardHeight + (cellStepY / 2)) THEN

				gCameraCtrl.Pieces[i].Valid := FALSE;
				gCameraCtrl.Pieces[i].Row := 0;
				gCameraCtrl.Pieces[i].Column := 0;

				gCameraCtrl.BoardDataValid := FALSE;

			ELSE

				currentLeftX :=
				gCameraCtrl.Calibration.TopLeftX
				+
				(
				(gCameraCtrl.Calibration.BottomLeftX
				- gCameraCtrl.Calibration.TopLeftX)
				* relativeY
				) / boardHeight;


				currentRightX :=
				gCameraCtrl.Calibration.TopRightX
				+
				(
				(gCameraCtrl.Calibration.BottomRightX
				- gCameraCtrl.Calibration.TopRightX)
				* relativeY
				) / boardHeight;


				currentBoardWidth :=
				currentRightX - currentLeftX;


				cellStepX :=
				currentBoardWidth / 7;


				relativeX :=
				gCameraCtrl.Pieces[i].PositionX
				- currentLeftX;


				IF relativeX < -(cellStepX / 2)
					OR relativeX >
					(currentBoardWidth + (cellStepX / 2)) THEN

					gCameraCtrl.Pieces[i].Valid := FALSE;
					gCameraCtrl.Pieces[i].Row := 0;
					gCameraCtrl.Pieces[i].Column := 0;

					gCameraCtrl.BoardDataValid := FALSE;

				ELSE

					gCameraCtrl.Pieces[i].Column :=
					DINT_TO_USINT(
					(relativeX + (cellStepX / 2))
					/ cellStepX
					) + 1;


					gCameraCtrl.Pieces[i].Row :=
					9
					-
					(
					DINT_TO_USINT(
					(relativeY + (cellStepY / 2))
					/ cellStepY
					) + 1
					);


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

		ELSE

			gCameraCtrl.Pieces[i].Valid := FALSE;
			gCameraCtrl.Pieces[i].Row := 0;
			gCameraCtrl.Pieces[i].Column := 0;

		END_IF;

	END_FOR;


	IF PreviousProcessingActive
		AND NOT gCameraCtrl.Status.ProcessingActive THEN

		IF gCameraCtrl.Status.ProcessingError = 0 THEN

			gCameraCtrl.BoardReady := TRUE;

		ELSE

			gCameraCtrl.BoardReady := FALSE;
			gCameraCtrl.BoardDataValid := FALSE;

		END_IF;

	END_IF;


	PreviousProcessingActive :=
	gCameraCtrl.Status.ProcessingActive;


	IF gCameraCtrl.Status.ProcessingError <> 0 THEN

		gCameraCtrl.BoardReady := FALSE;
		gCameraCtrl.BoardDataValid := FALSE;

		END_IF;
		FOR i := 1 TO 8 DO
			FOR j := 1 TO 8 DO
				CASE gCameraCtrl.Board[i, j] OF
					0:  gBoardCamera[i, j] := 0;
					1:  gBoardCamera[i, j] := 1;
					2:  gBoardCamera[i, j] := 2;
				END_CASE;
			END_FOR;
		END_FOR;
		gCameraCtrl.Cmd.AcquireImage := FALSE;
		gCameraEnd := 1;
	END_IF;
END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

	gCameraCtrl.BoardReady := FALSE;
	gCameraCtrl.BoardDataValid := FALSE;

END_PROGRAM