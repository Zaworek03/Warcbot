VAR {AT 'MotionCtrl'}
    StartPoint {ACCESS 'STMotionStartPoint'}: McPointType;
    EndPoint {ACCESS 'STMotionEndPoint'}: McPointType;
    HomePoint {ACCESS 'STMotionHomePoint'}: McPointType;
    Done {ACCESS 'STMotionDone'}: BOOL;
END_VAR

VAR {AT PLC}
    doMagnet : BOOL;
END_VAR

VAR
    Offs : McPosType := (Z:=20);
    
    StartPointOffs : McPointType;
    EndPointOffs : McPointType;
END_VAR

PROGRAM _MAIN
    Done := FALSE;
    Feedrate(5000);

    StartPointOffs := StartPoint;
    StartPointOffs.Pos.Z := StartPointOffs.Pos.Z + Offs.Z;
    EndPointOffs := EndPoint;
    EndPointOffs.Pos.Z := EndPointOffs.Pos.Z + Offs.Z;

    MoveJ(StartPointOffs);
    Feedrate(500);
    MoveL(StartPoint);
    Feedrate(5000);
    WaitEndMove();
    doMagnet := TRUE;
    WaitTime(1);
    MoveL(StartPointOffs); // zapytac sie czy tutaj da sie dac StartPoint + Offs, dla krotszego kodu
    
    //MoveJ(HomePoint);

    MoveJ(EndPointOffs);
    Feedrate(500);
    MoveL(EndPoint);
    Feedrate(5000);
    WaitEndMove();
    doMagnet := FALSE;
    WaitTime(1);
    MoveL(EndPointOffs);

    MoveJ(HomePoint);

    WaitEndMove();
    Done := TRUE;
END_PROGRAM
