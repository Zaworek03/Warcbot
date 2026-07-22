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
	
	
	FOR i := 1 TO 24 DO
		gCameraCtrl.Pieces[i].Valid := 
		(gCameraCtrl.NumResults >= i)
		AND
		(gCameraCtrl.Pieces[i].Score >= gCameraCtrl.Parameters.ScoreMin);
		
		relativeX := gCameraCtrl.Pieces[i].PositionX - gCameraCtrl.Calibration.TopLeftX;
		relativeY := gCameraCtrl.Pieces[i].PositionY - gCameraCtrl.Calibration.TopLeftY;
			
	END_FOR;
		

	IF gCameraCtrl.Status.ProcessingError <> 0 THEN

		(* Obs³uga b³êdu kamery bêdzie dodana póŸniej *)

	END_IF;

END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

END_PROGRAM