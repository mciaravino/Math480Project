Hakobyan–Li Slit Domain (Discrete Graph Approximation)

This repository contains a MATLAB implementation of a finite-stage approximation of the Hakobyan–Li slit domain and a numerical estimate of Lipschitz distortion using shortest-path distances.

The goal is to approximate the intrinsic metric of the slit domain and estimate

Lip approximately equals maximum over i not equal to j of

d_X(p_i , p_j) divided by Euclidean distance between p_i and p_j

where

d_X is the intrinsic shortest-path distance in the slit domain
Euclidean distance is the standard distance in R^2

FILES

hl_make_mask.m
Builds the binary mask of the slit domain at scale N using sequence r.

hl_draw_slits.m
Draws the vertical slits at each dyadic scale.

hl_build_graph.m
Builds a graph from the free region of the mask.

hl_dijkstra.m
Dijkstra shortest-path implementation.

hl_snap_xy_to_id.m
Snaps continuous coordinates to nearest valid graph node.

hl_distance_xy.m
Computes intrinsic shortest-path distance between two points.

hl_lipschitz_constant_with_pair.m
Computes the Lipschitz estimate and returns the maximizing pair.

script.m
Example driver script.

HOW TO RUN

Place all .m files in the same directory.

Open MATLAB and navigate to that directory.

Run:

script

The script will:

Construct the slit domain for a chosen scale N

Build the intrinsic graph

Sample test points in the unit square

Compute the Lipschitz estimate

Print the maximizing pair

Display a visualization

MAIN PARAMETERS (in script.m)

N = dyadic depth
r = 1./(1:N) is the defining sequence
numPts = number of grid points per axis

Increasing N adds more dyadic scales of slits.
Increasing numPts increases sampling resolution.

MATHEMATICAL INTERPRETATION

For a fixed dyadic depth N, this code constructs a discrete approximation of the slit domain X_N.

The intrinsic metric is approximated by shortest-path distance in a grid graph.

The reported Lipschitz value is the maximum ratio of intrinsic distance to Euclidean distance over sampled points.

This measures distortion of the identity embedding from the Euclidean metric to the intrinsic metric on X_N.

NOTES

The implementation is purely discrete and grid-based.

Very small distances may be influenced by grid resolution.

Results depend on sampling density and grid resolution.

This is an exploratory numerical experiment toward understanding how distortion grows as N increases.
