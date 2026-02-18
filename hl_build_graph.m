function G = hl_build_graph(freeMask, Xg, Yg, varargin)
%HL_BUILD_GRAPH  Build a 4-neighbor grid graph on free nodes for shortest paths.
%
%   G = hl_build_graph(freeMask, Xg, Yg)
%
% Inputs
%   freeMask : logical HxW, true=free node, false=blocked
%   Xg, Yg   : meshgrid coordinate arrays (same size as freeMask)
%
% Output struct G with fields:
%   .H, .W       : grid size
%   .nodeId      : HxW uint32, 0 for blocked, else compact id in 1..M
%   .idToSub     : Mx2 uint32, (i,j) subscripts for each id
%   .idToXY      : Mx2 double, (x,y) coordinate for each id
%   .nbrs        : Mx1 cell, neighbor id list (4-neighbor)
%   .stepCost    : scalar, cost of one horizontal/vertical step in world units
%
% Options (name/value)
%   'Connectivity' : 4 or 8 (default 4)
%
% Notes
% - Edge weights are geometric: horizontal/vertical steps cost ~grid spacing.
% - If using 8-neighbor connectivity, diagonals cost sqrt(2)*stepCost.

p = inputParser;
p.addParameter('Connectivity', 4, @(x)isnumeric(x)&&isscalar(x)&&(x==4||x==8));
p.parse(varargin{:});
conn = p.Results.Connectivity;

[H,W] = size(freeMask);
if ~isequal(size(Xg), [H,W]) || ~isequal(size(Yg), [H,W])
    error("Xg and Yg must be same size as freeMask.");
end

% Map free nodes to compact ids
nodeId = zeros(H,W,'uint32');
freeLin = find(freeMask);
M = numel(freeLin);
nodeId(freeLin) = uint32(1:M);

% Reverse mapping
[iSub, jSub] = ind2sub([H,W], freeLin);
idToSub = uint32([iSub(:), jSub(:)]);

% Coordinates for each id
xVec = Xg(1,:);        % x varies along columns
yVec = Yg(:,1);        % y varies along rows
idToXY = [xVec(double(jSub(:)))', yVec(double(iSub(:)))];

% Step cost
dx = xVec(2)-xVec(1);
dy = yVec(2)-yVec(1);
if abs(dx-dy) > 1e-12
    warning("Grid spacing dx != dy; using average for stepCost.");
end
stepCost = (dx+dy)/2;

% Neighbor offsets
if conn == 4
    offs = int32([ -1 0; 1 0; 0 -1; 0 1 ]);
    offCost = [1;1;1;1];
else
    offs = int32([ -1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1 ]);
    offCost = [1;1;1;1; sqrt(2); sqrt(2); sqrt(2); sqrt(2)];
end

% Build adjacency
nbrs = cell(M,1);
for id = 1:M
    i = int32(idToSub(id,1));
    j = int32(idToSub(id,2));

    neigh = zeros(size(offs,1),1,'uint32');
    cnt = 0;

    for k = 1:size(offs,1)
        ni = i + offs(k,1);
        nj = j + offs(k,2);
        if ni>=1 && ni<=H && nj>=1 && nj<=W
            nid = nodeId(ni,nj);
            if nid ~= 0
                cnt = cnt + 1;
                neigh(cnt) = nid;
            end
        end
    end

    nbrs{id} = neigh(1:cnt);
end

G = struct();
G.H = H; G.W = W;
G.nodeId = nodeId;
G.idToSub = idToSub;
G.idToXY = idToXY;
G.nbrs = nbrs;
G.stepCost = stepCost;
G.connectivity = conn;
G.diagMultiplier = offCost; %#ok<STRNU>
end
