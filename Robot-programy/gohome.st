VAR {AT 'MotionCtrl'}
    Done {ACCESS 'STMotionDone'}: BOOL;
END_VAR

VAR
    Home : McAxisTargetType := (JointAxis:=[0,0,-90,0,90,0]);
END_VAR

PROGRAM _MAIN
    Done := FALSE;
    Feedrate(5000);

    MoveA(Home);
    WaitEndMove();
    Done := TRUE;
END_PROGRAM