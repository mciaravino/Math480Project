function id = hl_snap_xy_to_id(G, x, y)
%HL_SNAP_XY_TO_ID  Snap (x,y) to nearest free grid node id.

% clamp
x = min(1,max(0,x));
y = min(1,max(0,y));

% nearest row/col by coordinates
% G.idToXY isn't on a perfect matrix, so use grid size + nodeId directly.
% Recover xVec and yVec from corners:
% (we can reconstruct approximate xVec/yVec from any row/col indices)
H = G.H; W = G.W;

% Build xVec/yVec once (fast enough for now)
% Use the fact coordinates are uniform in [0,1]
xVec = linspace(0,1,W);
yVec = linspace(0,1,H);

[~, j0] = min(abs(xVec - x));
[~, i0] = min(abs(yVec - y));

if G.nodeId(i0,j0) ~= 0
    id = double(G.nodeId(i0,j0));
    return;
end

% Expand search radius until a free node is found
for rad = 1:max(H,W)
    iMin = max(1,i0-rad); iMax = min(H,i0+rad);
    jMin = max(1,j0-rad); jMax = min(W,j0+rad);
    for ii = iMin:iMax
        for jj = jMin:jMax
            nid = G.nodeId(ii,jj);
            if nid ~= 0
                id = double(nid);
                return;
            end
        end
    end
end

error("No free node found (unexpected).");
end
