FUNCTION CalculateTransformation

	referenceVectorX := DINT_TO_LREAL(ReferenceMarker4X - ReferenceMarker3X);

	referenceVectorY := DINT_TO_LREAL(ReferenceMarker4Y - ReferenceMarker3Y);

	currentVectorX := DINT_TO_LREAL(CurrentMarker4X - CurrentMarker3X);

	currentVectorY := DINT_TO_LREAL(CurrentMarker4Y - CurrentMarker3Y);

	referenceDen := (referenceVectorX * referenceVectorX) + (referenceVectorY * referenceVectorY);

	IF referenceDen > 0.0 THEN

		TransformationA := ((currentVectorX * referenceVectorX) + (currentVectorY * referenceVectorY)) / referenceDen;

		TransformationB := ((currentVectorY * referenceVectorX) - (currentVectorX * referenceVectorY)) / referenceDen;

		TransformationDen := (TransformationA * TransformationA) + (TransformationB * TransformationB);

		CalculateTransformation := TransformationDen > 0.0;

	ELSE

		TransformationA := 0.0;
		TransformationB := 0.0;
		TransformationDen := 0.0;
		CalculateTransformation := FALSE;
	END_IF;

END_FUNCTION