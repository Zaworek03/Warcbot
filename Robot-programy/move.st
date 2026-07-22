VAR {AT 'MotionCtrl'}
    StartPoint {ACCESS 'STMotionStartPoint'}: McPointType;
    EndPoint {ACCESS 'STMotionEndPoint'}: McPointType;
    HomePoint {ACCESS 'STMotionHomePoint'}: McPointType;
END_VAR

VAR {AT PLC}
    doMagnet : BOOL;
    MagnetStatus : BOOL;
END_VAR

VAR
    Offs : McPosType := (Z:=20);
END_VAR

PROGRAM _MAIN
    Feedrate(5000);

    MoveJ(StartPoint + Offs);
    MoveL(StartPoint);
    WaitALAP();
    doMagnet := TRUE;
    WaitUntil(MagnetStatus);
    MoveL(StartPoint + Offs);
    
    MoveJ(HomePoint);

    MoveJ(EndPoint + Offs);
    MoveL(EndPoint);
    WaitALAP();
    doMagnet := FALSE;
    WaitUntil(NOT MagnetStatus);
    MoveL(EndPoint + Offs);

    MoveJ(HomePoint);
END_PROGRAM
