
FUNCTION CalculateTransformation : BOOL

	VAR_INPUT

		ReferenceMarker3X : DINT;
		ReferenceMarker3Y : DINT;

		ReferenceMarker4X : DINT;
		ReferenceMarker4Y : DINT;

		CurrentMarker3X : DINT;
		CurrentMarker3Y : DINT;

		CurrentMarker4X : DINT;
		CurrentMarker4Y : DINT;

	END_VAR

	VAR_IN_OUT

		TransformationA : LREAL;
		TransformationB : LREAL;
		TransformationDen : LREAL;

	END_VAR

	VAR

		referenceVectorX : LREAL;
		referenceVectorY : LREAL;

		currentVectorX : LREAL;
		currentVectorY : LREAL;

		referenceDen : LREAL;

	END_VAR

END_FUNCTION
