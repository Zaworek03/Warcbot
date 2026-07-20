TYPE
	IceCreamIngredients_Type : STRUCT (*Structure of the ice cream recipe*)
		Milk : REAL := 200.0; (*Amount of milk in [ml]*)
		Cream : REAL := 250.0; (*Amount of cream in [ml]*)
		Sugar : REAL := 60.0; (*Amount of sugar in [g]*)
		EggYolk : USINT := 3; (*Amount of egg yolk in pieces*)
		Flavour : STRING[80] := 'Chocolate'; (*Flavour of the ice cream*)
	END_STRUCT;
END_TYPE
