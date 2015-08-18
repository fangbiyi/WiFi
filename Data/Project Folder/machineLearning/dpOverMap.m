function [optimValue, dpPath, dpTable, time]=dpOverMap(stateProbMat, transProbMat, opt, showPlot)
% dpOverMap: DP over matrix of state probability.
%
%	Usage:
%		optimValue=dpOverMap(stateProbMat, transProbMat)
%		optimValue=dpOverMap(stateProbMat, transProbMat, showPlot)
%		[optimValue, dpPath, dpTable, time]=dpOverMap(...)
%
%	Description:
%		[optimValue, dpPath]=dpOverMap(stateProbMat, transProbMat) returns the optimum value and the corresponding DP (dynamic programming) for HMM evaluation.
%			stateProbMat: matrix of log state probabilities
%			transProbMat: matrix of log transition probabilities
%
%	Example:
%		load pfMat.mat
%		pfMat(1:20, :)=0;
%		%pfMat=[5 2 6; 2 9 3];
%		[stateNum, frameNum]=size(pfMat);
%		penalty=10000;
%		opt.initProb=log(1/stateNum)*ones(1, stateNum);
%		%opt.initProb=zeros(1, stateNum); opt.initProb(1)=1; opt.initProb=log(opt.initProb); 
%		opt.endState=logical(ones(1, stateNum));
%		%opt.endState=logical(zeros(1, stateNum)); opt.endState(end)=1;
%		showPlot=1;
%		[optimValue, dpPath, dpTable, time]=dpOverMap(pfMat, penalty, opt, showPlot);
%		fprintf('Time=%.2f sec\n', time);
%
%	See also dpOverMapM.

%	Category: HMM
%	Roger Jang, 20101028

if nargin<1, selfdemo; return; end
[stateNum, frameNum]=size(stateProbMat);
if nargin<3
	opt.initProb=log(1/stateNum)*ones(1, stateNum);
	opt.endState=logical(ones(1, stateNum));
end
if nargin<4, showPlot=0; end

if isscalar(transProbMat)	% This is actually penalty for state transition
	penalty=transProbMat;
	[xx,yy]=meshgrid(1:stateNum); transProbMat=-penalty*abs(xx-yy);
end

mexCommand='dpOverMapMex';
mCommand='dpOverMapM';

tic
try
	[optimValue, dpPath, dpTable]=feval(mexCommand, stateProbMat', transProbMat, opt.initProb, opt.endState);
catch exception
	fprintf('%s is disabled due to the error message "%s".\n%s is activated instead.\n', mexCommand, exception.message, mCommand);
	[optimValue, dpPath, dpTable]=feval(  mCommand, stateProbMat,  transProbMat, opt);
end
time=toc;
dpTable=dpTable';

if showPlot
	subplot(2,2,1);
	frameTime=1:frameNum;
	imagesc(frameTime, 1:stateNum, stateProbMat); shading flat; axis xy; colorbar
	title('Map');
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), 'color', 'k', 'marker', '.');
	end
	subplot(2,2,3);
	mesh(frameTime, 1:size(stateProbMat,1), stateProbMat); axis tight; colorbar
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), stateProbMat(dpPath(2,i), dpPath(1,i)), 'color', 'k', 'marker', '.');
	end
	title('Opt. path over the map');
	
	subplot(2,2,2);
	imagesc(frameTime, 1:stateNum, dpTable); shading flat; axis xy; colorbar
	title('dpTable');
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), 'color', 'k', 'marker', '.');
	end
	subplot(2,2,4);
	mesh(frameTime, 1:stateNum, dpTable); axis tight; colorbar
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), dpTable(dpPath(2,i), dpPath(1,i)), 'color', 'k', 'marker', '.');
	end
	title('Opt. path over the DP table');
	set(gcf, 'name', mfilename);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
