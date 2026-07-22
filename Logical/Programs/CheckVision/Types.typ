
TYPE
	VisionEnum : 	STRUCT 
		BoardConverted : ARRAY[1..8,1..8]OF USINT; (*Przekonwertowana tablica gdzie pokazywany jest tylko kolor, 1 - bialy, 2 - czarny, 0 -brak*)
		BoardVision : ARRAY[1..8,1..8]OF USINT; (*Tablica z kamery *)
		Step : StepVisionEnum; (*Kroki do case*)
		PhotoTake : BOOL; (*TRUE - kamera wykonala zdjecie*)
	END_STRUCT;
	StepVisionEnum : 
		(
		CheckTable,
		ConvertTable
		);
END_TYPE
