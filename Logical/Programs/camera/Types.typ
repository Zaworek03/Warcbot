TYPE
	CameraCommandType : STRUCT
		Enable                    : BOOL;
		AcquireImage              : BOOL;
		SearchAcquisitionSettings : BOOL;
	END_STRUCT;

	CameraParameterType : STRUCT
		FlashColor   : USINT;
		FlashSegment : USINT;
		SetFocus     : UINT;
		ExposureTime : UDINT;
	END_STRUCT;

	CameraStatusType : STRUCT
		AcquisitionReady : BOOL;
		ProcessingActive : BOOL;
		ProcessingError  : UINT;
		ReadFocus        : UINT;
		ReadExposureTime : UDINT;
	END_STRUCT;
	
	DetectedPieceType : STRUCT
		PositionX : DINT;
		PositionY : DINT;
		Area      : UDINT;
		Valid     : BOOL;
	END_STRUCT;

	CameraControlType : STRUCT
		Cmd        : CameraCommandType;
		Parameters : CameraParameterType;
		Status     : CameraStatusType;
		NumResults : USINT;
		Pieces     : ARRAY[1..24] OF DetectedPieceType;
	END_STRUCT;
END_TYPE
