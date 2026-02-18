% 1) Build mask
N = 3;
r = 1./(1:N);
Gsize = 2^N*12 + 1;
[freeMask, Xg, Yg] = hl_make_mask(r, N, Gsize, 'ShowFigure', false);

% 2) Build graph
G = hl_build_graph(freeMask, Xg, Yg, 'Connectivity', 4);

% 3) Choose test points

% simple uniform grid of points
numPts = 4;
[xs, ys] = meshgrid(linspace(0.05,0.95,numPts));
pts = [xs(:), ys(:)];

% keep only points that can snap to a free node (consistent with hl_distance_xy)
keep = false(size(pts,1),1);
for k = 1:size(pts,1)
    try
        hl_snap_xy_to_id(G, pts(k,1), pts(k,2)); % succeeds iff it can snap to free
        keep(k) = true;
    catch
        keep(k) = false;
    end
end
pts = pts(keep,:);

% 4) Compute Lipschitz estimate
[Lip, pStar, qStar, dXStar, dEStar] = hl_lipschitz_constant_with_pair(G, pts);

fprintf("Estimated Lipschitz constant = %.6f\n", Lip);
fprintf("Maximizing pair:\n");
fprintf("  p* = (%.6f, %.6f)\n", pStar(1), pStar(2));
fprintf("  q* = (%.6f, %.6f)\n", qStar(1), qStar(2));
fprintf("  d_X(p*,q*) = %.6f\n", dXStar);
fprintf("  ||p*-q*||  = %.6f\n", dEStar);

%% Overlay points on the mask figure 
figure; imagesc(Xg(1,:), Yg(:,1), ~freeMask); axis image xy; colormap(gray);
hold on;
plot(pts(:,1), pts(:,2), 'r.', 'MarkerSize', 10);
plot([pStar(1) qStar(1)], [pStar(2) qStar(2)], 'g-', 'LineWidth', 2);
plot(pStar(1), pStar(2), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(qStar(1), qStar(2), 'go', 'MarkerSize', 8, 'LineWidth', 2);
title('Points + maximizing pair');
xlabel('x'); ylabel('y');
hold off;