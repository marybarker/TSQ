loadPackage "ThinSincereQuivers";
needsPackage "NormalToricVarieties";
needsPackage "Graphs";
needsPackage "Polyhedra"

-- this function checks if the object 'v' is in the list 'l'
isIn = (v, l) -> (
    p := positions(l, x -> x == v);
    #p > 0
)

-- this function checks if two cones share a facet
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

    -- smallerFs is the set of unique flow polytopes
    smallerFps := unique fps;
    -- smallerIs is the indices of smallerFs considered as a subset of fps
    smallerIs := apply(smallerFps, x -> first positions(fps, y -> y == x));
    print("here are the indices", smallerIs);

    CQ = CQ_smallerIs;
    ths = ths_smallerIs;
    fps = fps_smallerIs;

    pgs := apply(fps, x-> picardGroup normalToricVariety x);
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
    verts := apply(0..#ths - 1, x-> {x, nvs#x, tif#x, fps#x, nvs#x, pgs#x});
    return {verts, edges, max(nvs) - min(nvs)};
)

-- list all possible graphs (up to multiplicity of non-primitive arrows) that have 3 primitive arrows
ThreePrimitiveArrowQuivers := {
    --{{0,1},{0,2},{0,3}},
    --{{1,0},{2,0},{3,0}},
    --{{0,1},{1,2},{2,3}},
    --{{0,1},{1,2},{2,3},{0,2}},
    {{0,1},{1,2},{2,3},{0,3}},
    {{0,1},{1,2},{2,3},{1,3}},
    {{0,1},{1,2},{2,3},{0,2},{0,3}},
    {{0,1},{1,2},{2,3},{0,2},{1,3}},
    {{0,1},{1,2},{2,3},{0,3},{1,3}},
    {{0,1},{1,2},{2,3},{0,2},{0,3},{1,3}},
    --{{0,1},{1,2},{3,2}},
    --{{0,1},{1,2},{3,2},{0,2}},
    {{0,1},{1,2},{3,2},{0,3}},
    {{0,1},{1,2},{3,2},{0,2},{0,3}},
    --{{1,0},{1,2},{2,3}},
    --{{1,0},{1,2},{2,3},{1,3}},
    --{{1,0},{1,2},{2,3},{2,0}},
    {{1,0},{1,2},{2,3},{1,3},{2,0}},
    --{{0,1},{0,2},{3,0}},
    --{{0,1},{0,2},{3,0},{3,1}},
    --{{0,1},{0,2},{3,0},{3,2}},
    {{0,1},{0,2},{3,0},{3,1},{3,2}},
    --{{0,1},{2,0},{3,0},{3,1}},
    --{{0,1},{2,0},{3,0},{2,1}},
    {{0,1},{2,0},{3,0},{3,1},{2,1}}
};

-- compute results for all 3-primitive arrows graphs
fname = "threePrimitiveArrows";
for Q in ThreePrimitiveArrowQuivers do(
    TQ := toricQuiver(Q);
    CG := chamberGraph(TQ);
    fname << Q << endl;
    for v in CG#0 do(
        fname << v << endl;
        print(v);
    );
    for e in CG#1 do(
        fname << e << endl;
        print(e);
    );
    fname << CG#2 << endl;
    fname << endl;
);
fname << close;


