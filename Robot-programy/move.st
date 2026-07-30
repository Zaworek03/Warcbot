VAR {AT 'MotionCtrl'}
    HomePoint {ACCESS 'STMotionHomePoint'}: McPointType;
    Done {ACCESS 'STMotionDone'}: BOOL;

    HighFeedrate {ACCESS 'STMotionHighFeedrate'}: LREAL;
    LowFeedrate {ACCESS 'STMotionLowFeedrate'}: LREAL;
END_VAR

VAR {AT PLC}
    doMagnet : BOOL;
END

PROGRAM _MAIN
    Done := FALSE;
    Feedrate(HighFeedrate);

    SetPCS(OH::MCS);
    MoveJ(HomePoint);

    WaitEndMove();
    Done := TRUE;
END_PROGRAM
