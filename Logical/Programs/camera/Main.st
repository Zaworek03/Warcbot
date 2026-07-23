PROGRAM _INIT

	gCameraCtrl.Cmd.Enable := TRUE;
	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.SearchAcquisitionSettings := FALSE;

END_PROGRAM


PROGRAM _CYCLIC

	IF NOT gCameraCtrl.Cmd.Enable THEN
		gCameraCtrl.Cmd.AcquireImage := FALSE;
	END_IF;

	IF gCameraCtrl.Cmd.AcquireImage
		AND NOT gCameraCtrl.Status.AcquisitionReady THEN

		gCameraCtrl.Cmd.AcquireImage := FALSE;

	END_IF;

	IF gCameraCtrl.Status.ProcessingError <> 0 THEN

		(* Obs³uga b³êdu kamery bêdzie dodana póŸniej *)

	END_IF;

END_PROGRAM


PROGRAM _EXIT

	gCameraCtrl.Cmd.AcquireImage := FALSE;
	gCameraCtrl.Cmd.Enable := FALSE;

END_PROGRAM