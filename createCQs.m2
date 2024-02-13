loadPackage "ThinSincereQuivers";
needsPackage "NormalToricVarieties";
needsPackage "Graphs";
needsPackage "Polyhedra";

shareAFacet = (C1, C2) -> (

    for f1 in facesAsCones(1, C1) do (
        for f2 in facesAsCones(1, C2) do (
            if (f1 == f2) then (
                return true;
            );
        );
    );
    return false;
)

chamberGraph = Q -> (

    CQ := coneSystem Q;
    ths := referenceThetas CQ;
    fps := apply(ths, x-> transpose matrix flowPolytope(x, Q));
    nts := apply(fps, x-> normalToricVariety x);
    tif := apply(nts, x-> isFano x);
    nvs := apply(fps, x-> #latticePoints convexHull x);
    pgs := apply(nts, x-> picardGroup x);
    edges := {};

    for ic1 in (0..#CQ - 1) do(

        c1 := CQ#ic1;
        for ic2 in (ic1 + 1..#CQ - 1) do(

            c2 := CQ#ic2;
            if shareAFacet(c1, c2) then (
                edges = edges | {{ic1, ic2}};
            );
        );
    );
    verts := apply(0..#ths - 1, x-> {x, ths#x, fps#x, nvs#x, pgs#x});
    return {verts, edges};
)

graphs = {
    {{0,1},{1,2},{2,3},{0,2},{0,3},{1,3}},
    {{0,1},{2,1},{2,3}},
    {{1,0},{1,2},{2,3},{1,3}},
    {{0,1},{1,2},{3,2},{0,2}},
    {{0,1},{0,2},{0,3}},
    {{0,1},{0,2},{3,0},{3,1},{3,2}},
    {{0,1},{2,0},{3,0},{3,1},{2,1}},
    {{1,0},{2,0},{3,0}}
};



fname = "3PrimitiveArrowsOutput.txt"

for g in graphs do(
    Q = toricQuiver g;
    fname << "quiver edges: " << g << endl;
    print("The toric quiver is: ", Q);

    if #g > 3 then (
        CG = chamberGraph Q;
    ) else (
        pas = primitiveArrows Q;
        CG = {entries transpose quiverIncidenceMatrix(Q_pas), {"NA"}};
    );

    for v in CG#0 do(
        fname << v << endl;
        print(v);
    );
    for e in CG#1 do(
        fname << e << endl;
        print(e);
    );
    fname << endl;
    print(concatenate("finished graph ", toString g));
);
fname << close;
