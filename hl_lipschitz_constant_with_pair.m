function [Lip, pStar, qStar, dXStar, dEStar] = hl_lipschitz_constant_with_pair(G, pts)

n = size(pts,1);
Lip = 0;
pStar = [NaN NaN];
qStar = [NaN NaN];
dXStar = NaN;
dEStar = NaN;

% --- minimum Euclidean separation to avoid grid artifacts ---
minSep = 4 * G.stepCost;   % try 3–8 times stepCost if needed

for i = 1:n
    for j = i+1:n

        p = pts(i,:);
        q = pts(j,:);

        dE = hypot(p(1)-q(1), p(2)-q(2));

        % Skip pairs that are too close (avoid discretization noise)
        if dE < minSep
            continue;
        end

        dX = hl_distance_xy(G, p(1), p(2), q(1), q(2));
        ratio = dX / dE;

        if ratio > Lip
            Lip = ratio;
            pStar = p;
            qStar = q;
            dXStar = dX;
            dEStar = dE;
        end

    end
end

end
