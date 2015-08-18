%% dpOverMapM
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
[stateNum, frameNum]=size(pfMat);
penalty=10000;
opt.initProb=log(1/stateNum)*ones(1, stateNum);
%opt.initProb=zeros(1, stateNum); opt.initProb(1)=1; opt.initProb=log(opt.initProb);
opt.endState=logical(ones(1, stateNum));
%opt.endState=logical(zeros(1, stateNum)); opt.endState(end)=1;
showPlot=1;
[optimValue, dpPath, dpTable, time]=dpOverMapM(pfMat, penalty, opt, showPlot);
fprintf('Time=%.2f sec\n', time);
%% See Also
% <dpOverMap_help.html dpOverMap>.
