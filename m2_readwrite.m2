writeToFile = (FNAME, OBJ) -> (
    if instance(OBJ, List) then (
        FNAME << "{" << endl;
        for o in OBJ do (
            FNAME << toString(o) << ", " << endl;
        );
        FNAME << "};" << close;
    ) else (
        FNAME << toString(o) << close;
    );
);

readFromFile = (FNAME) -> (
    return value get FNAME;
);
