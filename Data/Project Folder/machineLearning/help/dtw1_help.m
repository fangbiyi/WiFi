%% dtw1
% DTW (dynamic time warping) with local paths of 27, 45, and 63 degrees
%% Syntax
% * 		minDist = dtw1(vec1, vec2)
% * 		minDist = dtw1(vec1, vec2, beginCorner, endCorner)
% * 		minDist = dtw1(vec1, vec2, beginCorner, endCorner, plotOpt)
% * 		minDist = dtw1(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound)
% * 		[minDist, dtwPath, dtwTable] = dtw1(...)
%% Description
%
% <html>
% <p>dtw1(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 27, 45, and 63 degrees.
% 	<ul>
% 	<li>vec1: testing vector
% 	<li>vec2: reference vector
% 	<li>beginCorner: 1 for anchored beginning
% 	<li>endCorner: 1 for anchored ending
% 	<li>plotOpt: 1 for plotting the DTW path
% 	<li>distanceBound: distance bound for stop the computation. (Stop the computation immediately if the accumulated DTW distance is larger than this distance bound.)
% 	</ul>
% <p>[minDist, dtwPath, dtwTable] = dtw1(...) also return two extra results:
% 	<ul>
% 	<li>dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
% 	<li>dtwTable: DTW table
% 	</ul>
% <p>Note that this function is called by dtw.
% </html>
%% Example
%%
%
vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
[minDist, dtwPath, dtwTable] = dtw1(vec1, vec2);
dtwPathPlot(vec1, vec2, dtwPath);
%% See Also
% <dtwPathPlot_help.html dtwPathPlot>,
% <dtwBridgePlot_help.html dtwBridgePlot>,
% <dtw1m_help.html dtw1m>,
% <dtw2_help.html dtw2>,
% <dtw3_help.html dtw3>.
