%% editDistance
% Edit distance (ED) via dynamic programming
%% Syntax
% * 		minDist = editDistance(str1, str2)
% * 		minDist = editDistance(str1, str2, costVec)
% * 		minDist = editDistance(str1, str2, costVec, plotOpt)
% * 		[minDist, edPath, edTable] = editDistance(str1, str2, ...)
%% Description
%
% <html>
% <p>minDist = editDistance(str1, str2) returns the edit distance between strings str1 and str2, assuming the costs for insertion, deletion, and substitution are 1, 1, and 2, respectively.
% <p>minDist = editDistance(a, b, costVec) specifies the cost via costVec=[substitution, insertion, deletion].
% 	<ul>
% 	<li>If costVec is a scalar, then it is taken as the substitution cost and the other costs are assumed to be 1.
% 	</ul>
% <p>minDist = editDistance(a, b, costVec, plotOpt) display the optimum path on the DP table.
% <p>[minDist, edPath, edTable] = editDistance(a, b, ...) also returns the optimum path of dynamic programming in edPath, and the resulting table in edTable.
% </html>
%% Example
%%
%
str1='execution';
str2='intention';
costVec=[2, 1, 1];
plotOpt=1;
[minDist, edPath, edTable] = editDistance(str1, str2, costVec, plotOpt);
%% See Also
% <lcs_help.html lcs>,
% <dpPathPlot4strMatch_help.html dpPathPlot4strMatch>.
