%% jjj
% An m-file implementation of DP over matrix of state probability.
%% Syntax
% * 		optimValue=dpOverMapM(stateProbMat, transProbMat)
% * 		optimValue=dpOverMapM(stateProbMat, transProbMat, showPlot)
% * 		[optimValue, dpPath, dpTable, time]=dpOverMapM(...)
%% Description
%
% <html>
% <p>[optimValue, dpPath]=dpOverMap(stateProbMat, transProbMat) returns the optimum value and the corresponding DP (dynamic programming) for HMM evaluation.
% 	<ul>
% 	<li>stateProbMat: matrix of log state probabilities
% 	<li>transProbMat: matrix of log transition probabilities
% 	</ul>
% </html>
%% Example
%%
%
load pfMat.mat
pfMat(1:20, :)=0;
%pfMat=[5 2 6; 2 9 3];
penalty=10000;
showPlot=1;
[optimValue, dpPath, dpTable, time]=dpOverMapM(pfMat, penalty, showPlot);
fprintf('Time=%.2f sec\n', time);
%% See Also
% <dpOverMap_help.html dpOverMap>.
