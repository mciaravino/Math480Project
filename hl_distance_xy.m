function d = hl_distance_xy(G, x1, y1, x2, y2)
%HL_DISTANCE_XY  Shortest-path distance between two world points (x,y) in [0,1]^2.
% Snaps each point to the nearest FREE grid node, then runs Dijkstra once.

id1 = hl_snap_xy_to_id(G, x1, y1);
id2 = hl_snap_xy_to_id(G, x2, y2);

dist = hl_dijkstra(G, id1);
d = dist(id2);
end
