function [slits] = hl_draw_slits(r, N, varargin)
%HL_DRAW_SLITS  Draw stage-N Hakobyan–Li dyadic slit domain in [0,1]^2.
%
%   slits = hl_draw_slits(r, N) draws the slits for levels 1..N where
%   r is a vector with length >= N (r(n) used at level n).
%
%   Output:
%     slits: struct array with fields:
%       .n    (level)
%       .x    (x-coordinate of slit centerline)
%       .y0   (lower endpoint y)
%       .y1   (upper endpoint y)
%
%   Options (name/value):
%     'DrawGrid'    true/false (default false)  draw dyadic grid lines
%     'LineWidth'   numeric    (default 1.0)
%     'GridAlpha'   numeric    (default 0.15)
%
%   Convention:
%     At level n, each dyadic cell has side length 2^{-n}.
%     In each cell, we insert one *vertical* slit centered in the cell,
%     of length (r_n)*(2^{-n}), centered vertically in that cell.

p = inputParser;
p.addParameter('DrawGrid', false, @(x)islogical(x) && isscalar(x));
p.addParameter('LineWidth', 1.0, @(x)isnumeric(x) && isscalar(x) && x>0);
p.addParameter('GridAlpha', 0.15, @(x)isnumeric(x) && isscalar(x) && x>=0 && x<=1);
p.parse(varargin{:});
opt = p.Results;

if numel(r) < N
    error("r must have length at least N. Got length(r)=%d, N=%d.", numel(r), N);
end
if any(r(1:N) < 0) || any(r(1:N) > 1)
    warning("Some r_n are outside [0,1]. Typical constructions use 0<=r_n<=1.");
end

% Prepare figure
figure; hold on; axis equal;
xlim([0 1]); ylim([0 1]);
set(gca,'YDir','normal');
box on;
title(sprintf('Dyadic slit domain, stage N=%d', N));
xlabel('x'); ylabel('y');

% Optional: draw dyadic grid
if opt.DrawGrid
    for n = 1:N
        m = 2^n;
        xs = (0:m)/m;
        ys = (0:m)/m;
        for k = 2:numel(xs)-1
            plot([xs(k) xs(k)],[0 1],'k-','LineWidth',0.5,'Color',[0 0 0 opt.GridAlpha]);
        end
        for k = 2:numel(ys)-1
            plot([0 1],[ys(k) ys(k)],'k-','LineWidth',0.5,'Color',[0 0 0 opt.GridAlpha]);
        end
    end
end

% Generate slits
slits = struct('n',{},'x',{},'y0',{},'y1',{});
idx = 0;

for n = 1:N
    m = 2^n;              % cells per side
    cellSize = 1/m;       % 2^{-n}
    slitLen = r(n)*cellSize;

    for ix = 0:(m-1)
        for iy = 0:(m-1)
            % Cell bounds
            x0 = ix*cellSize; x1 = (ix+1)*cellSize;
            y0 = iy*cellSize; y1 = (iy+1)*cellSize;

            % Slit center
            xc = (x0+x1)/2;
            yc = (y0+y1)/2;

            % Slit endpoints (clipped to the cell just in case)
            ya = max(y0, yc - slitLen/2);
            yb = min(y1, yc + slitLen/2);

            % Store + draw
            idx = idx + 1;
            slits(idx).n  = n;
            slits(idx).x  = xc;
            slits(idx).y0 = ya;
            slits(idx).y1 = yb;

            plot([xc xc],[ya yb],'k-','LineWidth',opt.LineWidth);
        end
    end
end

hold off;
end
