function [freeMask, Xg, Yg, slits] = hl_make_mask(r, N, Gsize, varargin)
%HL_MAKE_MASK  Build a stage-N dyadic slit obstacle mask on a uniform grid.
%
%   [freeMask, Xg, Yg, slits] = hl_make_mask(r, N, Gsize)
%
% Inputs
%   r      : vector with length >= N, where r(n) controls slit length at level n
%   N      : max dyadic level (stage)
%   Gsize  : number of grid nodes per side (e.g., 513, 1025, ...)
%
% Outputs
%   freeMask : logical Gsize-by-Gsize, true = free space, false = blocked by slit
%   Xg, Yg   : meshgrid arrays for coordinates in [0,1]^2 (same size as freeMask)
%   slits    : struct array describing each slit segment (for debugging/plotting)
%
% Options (name/value)
%   'Thickness'    : slit thickness in world units (default = 1.5*grid spacing)
%   'KeepBoundary' : keep outer boundary free (default = true)
%   'ShowFigure'   : show a figure (default = true)
%   'DrawGrid'     : draw dyadic grid overlay in figure (default = false)
%
% Notes
% - This builds a 2D "barrier" model: shortest paths must go around slit segments.
% - It is a computational surrogate for the HL metric to get distances working.
%
% Example
%   N = 5;
%   r = 1./(1:N);
%   Gsize = 2^N*12 + 1;
%   [freeMask,Xg,Yg] = hl_make_mask(r,N,Gsize,'ShowFigure',true);

p = inputParser;
p.addParameter('Thickness', [], @(x) isempty(x) || (isnumeric(x)&&isscalar(x)&&x>0));
p.addParameter('KeepBoundary', true, @(x)islogical(x)&&isscalar(x));
p.addParameter('ShowFigure', true, @(x)islogical(x)&&isscalar(x));
p.addParameter('DrawGrid', false, @(x)islogical(x)&&isscalar(x));
p.parse(varargin{:});
opt = p.Results;

if numel(r) < N
    error("r must have length at least N. Got length(r)=%d, N=%d.", numel(r), N);
end

% Grid in [0,1]^2
x = linspace(0,1,Gsize);
y = linspace(0,1,Gsize);
[Xg, Yg] = meshgrid(x,y);

dx = x(2)-x(1);
thick = opt.Thickness;
if isempty(thick)
    thick = 1.5*dx;  % default thickness ~ 1-2 pixels
end

blocked = false(Gsize, Gsize);

% Store slit metadata
slits = struct('n',{},'x',{},'y0',{},'y1',{});
idx = 0;

for n = 1:N
    m = 2^n;            % cells per side
    cellSize = 1/m;     % 2^{-n}
    slitLen = r(n)*cellSize;

    for ix = 0:(m-1)
        for iy = 0:(m-1)
            % Cell bounds
            x0 = ix*cellSize; x1 = (ix+1)*cellSize;
            y0 = iy*cellSize; y1 = (iy+1)*cellSize;

            % Center
            xc = (x0+x1)/2;
            yc = (y0+y1)/2;

            % Slit endpoints
            ya = max(y0, yc - slitLen/2);
            yb = min(y1, yc + slitLen/2);

            % Mark blocked pixels near the slit centerline
            mask = (abs(Xg - xc) <= thick/2) & (Yg >= ya) & (Yg <= yb);
            blocked = blocked | mask;

            % Save
            idx = idx + 1;
            slits(idx).n  = n;
            slits(idx).x  = xc;
            slits(idx).y0 = ya;
            slits(idx).y1 = yb;
        end
    end
end

% Optionally keep the outer boundary free so the boundary loop is always feasible
if opt.KeepBoundary
    blocked(1,:)   = false;
    blocked(end,:) = false;
    blocked(:,1)   = false;
    blocked(:,end) = false;
end

freeMask = ~blocked;

% Optional visualization
if opt.ShowFigure
    figure; clf;
    imagesc(x, y, ~freeMask); axis image xy;
    colormap(gray);
    title(sprintf('Blocked mask (1=blocked), stage N=%d', N));
    xlabel('x'); ylabel('y');
    hold on;

    if opt.DrawGrid
        for n = 1:N
            m = 2^n;
            xs = (0:m)/m;
            ys = (0:m)/m;
            for k = 2:numel(xs)-1
                plot([xs(k) xs(k)],[0 1],'r-','LineWidth',0.5,'Color',[1 0 0 0.15]);
            end
            for k = 2:numel(ys)-1
                plot([0 1],[ys(k) ys(k)],'r-','LineWidth',0.5,'Color',[1 0 0 0.15]);
            end
        end
    end

    hold off;
end
end
