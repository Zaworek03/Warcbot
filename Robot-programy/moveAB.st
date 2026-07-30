VAR {AT 'MotionCtrl'}
    StartPoint {ACCESS 'STMotionStartPoint'}: McPointType;
    EndPoint {ACCESS 'STMotionEndPoint'}: McPointType;
    Done {ACCESS 'STMotionDone'}: BOOL;

    HighFeedrate {ACCESS 'STMotionHighFeedrate'}: LREAL;
    LowFeedrate {ACCESS 'STMotionLowFeedrate'}: LREAL;
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
    SetPCS(OH::gUserFrame);
    Feedrate(HighFeedrate);

    StartPointOffs := StartPoint;
    StartPointOffs.Pos.Z := StartPointOffs.Pos.Z + Offs.Z;
    EndPointOffs := EndPoint;
    EndPointOffs.Pos.Z := EndPointOffs.Pos.Z + Offs.Z;

    MoveJ(StartPointOffs);
    Feedrate(LowFeedrate);
    MoveL(StartPoint);
    WaitEndMove();
    doMagnet := TRUE;
    WaitTime(1);
    MoveL(StartPointOffs); // zapytac sie czy tutaj da sie dac StartPoint + Offs, dla krotszego kodu
    Feedrate(HighFeedrate);
    
    //MoveJ(HomePoint);

    MoveJ(EndPointOffs);
    Feedrate(LowFeedrate);
    MoveL(EndPoint);
    WaitEndMove();
    doMagnet := FALSE;
    WaitTime(1);
    MoveL(EndPointOffs);
    Feedrate(HighFeedrate);

    WaitEndMove();
    Done := TRUE;
END_PROGRAM
