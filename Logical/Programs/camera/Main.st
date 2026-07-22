PROGRAM _INIT

	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;
	gCameraCtrl.Parameters.ScoreMin := 75;
	gCameraCtrl.Parameters.NumSearchMax := 24;
	
	gCameraCtrl.Calibration.TopLeftX := 28242;
	gCameraCtrl.Calibration.TopLeftY := 7440;
	gCameraCtrl.Calibration.TopRightX := 121355;
	gCameraCtrl.Calibration.TopRightY := 8066;
	gCameraCtrl.Calibration.BottomLeftX := 28311;
	gCameraCtrl.Calibration.BottomLeftY := 97484;
	gCameraCtrl.Calibration.BottomRightX := 119386;
	gCameraCtrl.Calibration.BottomRightY := 98658;
	
	gCameraCtrl.BoardReady := FALSE;

END_PROGRAM


PROGRAM _CYCLIC

	IF NOT gCameraCtrl.Cmd.Enable THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
	END_IF;

	IF gCameraCtrl.Cmd.AcquireImage
		AND NOT gCameraCtrl.Status.AcquisitionReady THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
	END_IF;
	
	boardWidth := 
		((gCameraCtrl.Calibration.TopRightX - gCameraCtrl.Calibration.TopLeftX) 
		+ (gCameraCtrl.Calibration.BottomRightX - gCameraCtrl.Calibration.BottomLeftX)) /2;
	
	boardHeight := 
		((gCameraCtrl.Calibration.BottomLeftY - gCameraCtrl.Calibration.TopLeftY) 
		+ (gCameraCtrl.Calibration.BottomRightY - gCameraCtrl.Calibration.TopRightY)) /2;
	
	cellStepX := boardWidth / 7;
	cellStepY := boardHeight / 7;
	
	FOR rowIndex := 1 TO 8 DO
		FOR columnIndex := 1 TO 8 DO
			gCameraCtrl.Board[rowIndex, columnIndex] := 0;
		END_FOR;
	END_FOR;
	
	FOR i := 1 TO 24 DO
		gCameraCtrl.Pieces[i].Valid := 
		(gCameraCtrl.NumResults >= i)
		AND
		(gCameraCtrl.Pieces[i].Score >= gCameraCtrl.Parameters.ScoreMin);
		
		IF gCameraCtrl.Pieces[i].Valid THEN
			relativeX := gCameraCtrl.Pieces[i].PositionX - gCameraCtrl.Calibration.TopLeftX;
			relativeY := gCameraCtrl.Pieces[i].PositionY - gCameraCtrl.Calibration.TopLeftY;
		
			gCameraCtrl.Pieces[i].Column := DINT_TO_USINT((relativeX + (cellStepX/2)) / cellStepX) + 1;
			gCameraCtrl.Pieces[i].Row := DINT_TO_USINT((relativeY + (cellStepY/2)) / cellStepY) + 1;
			
			
			IF gCameraCtrl.Pieces[i].Column > 8 THEN

				gCameraCtrl.Pieces[i].Column := 0;
				gCameraCtrl.Pieces[i].Valid := FALSE;

			END_IF;
				
			IF gCameraCtrl.Pieces[i].Row > 8 THEN

				gCameraCtrl.Pieces[i].Row := 0;
				gCameraCtrl.Pieces[i].Valid := FALSE;

			END_IF;
			
			IF gCameraCtrl.Pieces[i].Valid THEN

				gCameraCtrl.Board[
				gCameraCtrl.Pieces[i].Row,
				gCameraCtrl.Pieces[i].Column
				] := gCameraCtrl.Pieces[i].ModelNumber;

			END_IF;
			
		ELSE
			gCameraCtrl.Pieces[i].Row := 0;
			gCameraCtrl.Pieces[i].Column := 0;
		END_IF;
			
	END_FOR;
	
	gCameraCtrl.BoardReady := TRUE;		

	IF gCameraCtrl.Status.ProcessingError <> 0 THEN

		(* Obs³uga b³êdu kamery bêdzie dodana póŸniej *)

	END_IF;

END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

END_PROGRAM