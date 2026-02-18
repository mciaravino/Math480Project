Hakobyan–Li Slit Domain (Discrete Approximation)

This project contains a MATLAB implementation of a finite-stage approximation of the Hakobyan–Li slit domain and a numerical estimate of intrinsic Lipschitz distortion.

The code constructs a dyadic slit domain, builds its intrinsic shortest-path metric using a grid graph, and estimates

L ≈ max_{i ≠ j} d_X(p_i, p_j) / ||p_i − p_j||_2

over a finite set of sampled points.

Here:

d_X is intrinsic shortest-path distance in the slit domain

||·||_2 is Euclidean distance

Files

hl_make_mask.m
Builds the slit domain mask at dyadic depth N.

hl_draw_slits.m
Draws vertical slits at each dyadic scale.

hl_build_graph.m
Constructs a graph on the free region.

hl_dijkstra.m
Dijkstra shortest-path algorithm.

hl_snap_xy_to_id.m
Snaps continuous coordinates to nearest valid node.

hl_distance_xy.m
Computes intrinsic shortest-path distance between two points.

hl_lipschitz_constant_with_pair.m
Computes the Lipschitz estimate and returns the maximizing pair.

script.m
Example driver script.

How to Run

Place all .m files in the same directory.

Open MATLAB and navigate to that directory.

Run:

script

The script will:

Construct the slit domain for chosen depth N

Build the intrinsic graph

Sample test points

Compute the Lipschitz estimate

Print the maximizing pair

Display a visualization

Main Parameters (in script.m)

N dyadic depth
r defining sequence (currently r_n = 1/n)
numPts number of grid points per axis

Increasing N increases the number of dyadic scales.
Increasing numPts increases sampling resolution.

Mathematical Interpretation

For fixed N, the code constructs a discrete approximation X_N of the slit domain.

The intrinsic metric is approximated by shortest-path distance on a grid graph.

The reported value approximates

max_{i ≠ j} d_{X_N}(p_i, p_j) / ||p_i − p_j||_2

over sampled points.

This measures distortion of the identity embedding from the Euclidean metric to the intrinsic metric.

Notes

The implementation is discrete and grid-based.

Small distances may be influenced by grid resolution.

Results depend on sampling density and grid size.

This is an exploratory numerical experiment toward understanding distortion growth as N increases.

This will render cleanly on GitHub and look professional when your professor opens the repo.

If you want, I can also tighten it slightly to sound more research-polished.
