
TYPE
	CameraCommandType : 	STRUCT 
		Enable : BOOL;
		AcquireImage : BOOL;
		SearchAcquisitionSettings : BOOL;
	END_STRUCT;
	BoardCalibrationType : 	STRUCT 
		BottomRightY : DINT;
		BottomRightX : DINT;
		BottomLeftY : DINT;
		BottomLeftX : DINT;
		TopRightY : DINT;
		TopRightX : DINT;
		TopLeftY : DINT;
		TopLeftX : DINT;
	END_STRUCT;
	CameraParameterType : 	STRUCT 
		FlashColor : USINT;
		FlashSegment : USINT;
		SetFocus : UINT;
		ExposureTime : UDINT;
		NumSearchMax : USINT;
		ScoreMin : USINT;
	END_STRUCT;
	CameraStatusType : 	STRUCT 
		AcquisitionReady : BOOL;
		ProcessingActive : BOOL;
		ProcessingError : UINT;
		ReadFocus : UINT;
		ReadExposureTime : UDINT;
	END_STRUCT;
	DetectedPieceType : 	STRUCT 
		PositionX : DINT;
		PositionY : DINT;
		Area : UDINT;
		Valid : BOOL;
		Score : USINT;
		ModelNumber : USINT;
		Column : USINT;
		Row : USINT;
	END_STRUCT;
	CameraBoardType :ARRAY[1..8,1..8]OF USINT;
	CameraControlType : 	STRUCT 
		Cmd : CameraCommandType;
		Parameters : CameraParameterType;
		Status : CameraStatusType;
		NumResults : USINT;
		Pieces : ARRAY[1..24]OF DetectedPieceType;
		Calibration : BoardCalibrationType;
		Board : CameraBoardType;
		BoardReady : BOOL;
	END_STRUCT;
END_TYPE
