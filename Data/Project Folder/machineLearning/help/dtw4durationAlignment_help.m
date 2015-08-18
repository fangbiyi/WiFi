%% dtw4durationAlignment
% Pure m-file implementation of DTW (dynamic time warping) for duration alignment
%% Syntax
% * 		minDist = dtw4durationAlignment(vec1, vec2)
% * 		minDist = dtw4durationAlignment(vec1, vec2, plotOpt)
% * 		[minDist, dtwPath, dtwTable] = dtw4durationAlignment(...)
%% Description
%
% <html>
% <p>dtw1m(vec1, vec2, plotOpt) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 27, 45, and 63 degrees.
% 	<ul>
% 	<li>vec1: testing vector
% 	<li>vec2: reference vector
% 	<li>plotOpt: 1 for plotting the DTW path
% 	</ul>
% <p>[minDist, dtwPath, dtwTable] = dtw1m(...) also return two extra results:
% 	<ul>
% 	<li>dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
% 	<li>dtwTable: DTW table
% 	</ul>
% <p>Note that this function is a pure m-file implementation which is slow but easy to customize.
% </html>
%% Example
%%
%
vec1=[2 3 1 2 4 1 3 2 3];
vec2=[1 1 4 1 2 2 4 5];
[minDist, dtwPath, dtwTable] = dtw4durationAlignment(vec1, vec2);
dtwPathPlot(vec1, vec2, dtwPath);
%% See Also
% <dtwPathPlot_help.html dtwPathPlot>,
% <dtwBridgePlot_help.html dtwBridgePlot>,
% <dtw1_help.html dtw1>,
% <dtw2_help.html dtw2>,
% <dtw3_help.html dtw3>.
