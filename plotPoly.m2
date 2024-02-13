replaceInList = (i, v, l) -> (
    insert(i, v, drop(l, {i,i}))
)
plotP = P -> (
    if #first P > 2 then (
        print("error: cannot plot polytope in dimension > 2");
        print("vertices are: ", P);
    ) else (
        points := unique P;
        xs := apply(points, x -> x#0);
        ys := apply(points, x -> x#1);

        xmn := round(-2 + min xs);
        xmx := round( 2 + max xs);
        ymn := round(-2 + min ys);
        ymx := round( 2 + max ys);

        plainPrint := for i from xmn to xmx list(if (i == 0) then ("|   ") else ("    "));
        for i from ymn to ymx do(
            y := ymn + (ymx - i);
            xsp := " ";
            if y == 0 then (xsp = "-");
            toPrint := for i from xmn to xmx list(if (i == 0) then (concatenate{"|", xsp, xsp,xsp}) else (concatenate{xsp,xsp,xsp,xsp}));

            ps := positions(ys, t -> t == y);
            if #ps > 0 then (
                for p in ps do (
                    toPrint = replaceInList(round(xs#p)-xmn, concatenate{"*",xsp,xsp,xsp}, toPrint);
                );
            );
            print(concatenate plainPrint);
            print(concatenate toPrint);
        );
        print(concatenate plainPrint);
    );
)
