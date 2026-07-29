
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
		MarkersValid : BOOL;
		ReferenceMarker4Y : DINT;
		ReferenceMarker4X : DINT;
		ReferenceMarker3Y : DINT;
		ReferenceMarker3X : DINT;
		ReferenceBottomRightY : DINT;
		ReferenceBottomRightX : DINT;
		ReferenceBottomLeftY : DINT;
		ReferenceBottomLeftX : DINT;
		ReferenceTopRightY : DINT;
		ReferenceTopRightX : DINT;
		ReferenceTopLeftY : DINT;
		ReferenceTopLeftX : DINT;
	END_STRUCT;
	CameraParameterType : 	STRUCT 
		FlashColor : USINT;
		FlashSegment : USINT;
		SetFocus : UINT;
		ExposureTime : UDINT;
		NumSearchMax : USINT;
		ScoreMin : USINT;
		GainLevel : USINT;
	END_STRUCT;
	CameraStatusType : 	STRUCT 
		AcquisitionReady : BOOL;
		ProcessingActive : BOOL;
		ProcessingError : UINT;
		ReadFocus : UINT;
		ReadExposureTime : UDINT;
		ReadGainLevel : USINT;
	END_STRUCT;
	DetectedPieceType : 	STRUCT 
		PositionX : DINT;
		PositionY : DINT;
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
		Pieces : ARRAY[1..26]OF DetectedPieceType;
		Calibration : BoardCalibrationType;
		Board : CameraBoardType;
		BoardReady : BOOL;
		BlackCount : USINT;
		WhiteCount : USINT;
		BoardDataValid : BOOL;
	END_STRUCT;
END_TYPE
