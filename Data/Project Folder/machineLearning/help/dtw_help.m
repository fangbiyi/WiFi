%% dtw
% DTW (dynamic time warping)
%% Syntax
% * 		minDist = dtw(vec1, vec2)
% * 		[minDist, dtwPath] = dtw(vec1, vec2)
% * 		[minDist, dtwPath, dtwTable] = dtw(vec1, vec2)
% * 		[...] = dtw(vec1, vec2, dtwOpt)
% * 		[...] = dtw(vec1, vec2, dtwOpt, showPlot)
%% Description
%
% <html>
% <p>dtw(vec1, vec2) returns the DTW distance between two vectors vec1 and vec2.
% <p>dtw(vec1, vec2, dtwOpt) perform DTW by using the given parameters in dtwOpt, with the fields
% 	<ul>
% 	<li>dtwOpt.type: type of DTW
% 		<ul>
% 		<li>dtwOpt.type=1 for type-1 DTW of local path constraints of 27-45-65.
% 		<li>dtwOpt.type=2 for type-2 DTW of local path constraints of 0-45-90.
% 		<li>dtwOpt.type=3 for type-3 DTW of local path constraints of 0-45.
% 		</ul>
% 	<li>dtwOpt.beginCorner: 1 for anchored beginning
% 	<li>dtwOpt.endCorner: 1 for anchored ending
% 	</ul>
% <p>dtw(vec1, vec2, dtwOpt, showPlot) plots the DTW path
% <p>[minDist, dtwPath, dtwTable] = dtw(...) returns additions information:
% 	<ul>
% 	<li>minDist: minimun distance of DTW
% 	<li>dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
% 	<li>dtwTable: DTW table
% 	</ul>
% <p>Depending on the value of dtwOpt.type, this function calls dtw1, dtw2, or dtw3.
% </html>
%% Example
%%
%
vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
[minDist, dtwPath, dtwTable]=dtw(vec1, vec2);
dtwPathPlot(vec1, vec2, dtwPath);
%% See Also
% <dtwPathPlot_help.html dtwPathPlot>,
% <dtwBridgePlot_help.html dtwBridgePlot>,
% <dtw1_help.html dtw1>,
% <dtw2_help.html dtw2>,
% <dtw3_help.html dtw3>.
