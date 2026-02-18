function [dist, prev] = hl_dijkstra(G, srcId)
%HL_DIJKSTRA  Dijkstra shortest paths from one source node id.
%
%   dist = hl_dijkstra(G, srcId)
%   [dist, prev] = hl_dijkstra(...)
%
% Inputs
%   G     : graph struct from hl_build_graph
%   srcId : source node id in 1..M
%
% Outputs
%   dist : Mx1 double, shortest-path distance in world units
%   prev : Mx1 uint32, predecessor id for path reconstruction (0 if none)

M = numel(G.nbrs);
dist = inf(M,1);
prev = zeros(M,1,'uint32');
visited = false(M,1);

dist(srcId) = 0;

% Simple O(M^2) Dijkstra (fine to start; optimize later if needed)
for iter = 1:M
    % pick unvisited node with smallest dist
    best = inf; u = 0;
    for k = 1:M
        if ~visited(k) && dist(k) < best
            best = dist(k);
            u = k;
        end
    end
    if u == 0 || isinf(best)
        break;
    end

    visited(u) = true;

    neigh = G.nbrs{u};
    for t = 1:numel(neigh)
        v = double(neigh(t));
        if visited(v), continue; end

        % cost: 4-neighbor => stepCost; 8-neighbor => adjust diagonals
        % For simplicity, infer diagonal by coordinate difference
        duv = abs(double(G.idToSub(u,1)) - double(G.idToSub(v,1))) + ...
              abs(double(G.idToSub(u,2)) - double(G.idToSub(v,2)));
        if duv == 2
            w = sqrt(2)*G.stepCost;
        else
            w = G.stepCost;
        end

        alt = dist(u) + w;
        if alt < dist(v)
            dist(v) = alt;
            prev(v) = uint32(u);
        end
    end
end
end
