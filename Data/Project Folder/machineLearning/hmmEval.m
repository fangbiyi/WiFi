function [optPath, stateProb, hmmTable]=hmmEval(inputData, hmmPrm, plotOpt)
% hmmEval: HMM evaluation
%
%	Usage:
%		optPath=hmmEval(inputData, hmmPrm)
%		optPath=hmmEval(inputData, hmmPrm, plotOpt)
%		[optPath, stateProb]=hmmEval(...)
%
%	Description:
%		optPath=hmmEval(inputData, hmmPrm) returns the optimum path of a given HMM.
%			inputData: Input matrix, where each column is a feature vector
%			hmmPrm: HMM parameters
%		optPath=hmmEval(inputData, hmmPrm, plotOpt) plot the optimum path if plotOpt=1.
%		[optPath, stateProb]=hmmEval(...) returns the state probabilities in addition to the optimum path.
%
%	Example:

%	Category: HMM
%	Roger Jang, 20090928, 20100618

if nargin<1, selfdemo; return; end
if nargin<4, plotOpt=1; end

[feaDim, frameNum]=size(inputData);
stateNum=length(hmmPrm.state);
stateProb=zeros(frameNum, stateNum);

% ====== Compute the matrix of state prob.
for i=1:stateNum
	stateProb(:,i)=gmmEval(inputData, hmmPrm.state(i).gmmPrm);
end
% ====== Add prior to the matrix of state prob.
%for i=1:frameNum
%	stateProb(i,:)=stateProb(i,:)+hmmPrm.prior;
%end

hmmTable=zeros(frameNum, stateNum);
prevPos=zeros(frameNum, stateNum);
optPath=zeros(frameNum, 1);

% ====== Fill hmmTable
hmmTable(1,:)=stateProb(1,:)+hmmPrm.pi;	% Add the initial prob for each state
for i=2:frameNum
	for j=1:stateNum
		prob=hmmTable(i-1,:)+hmmPrm.transProb(:,j)';
		[maxProb, index]=max(prob);
		prevPos(i,j)=index;
		hmmTable(i,j)=stateProb(i,j)+maxProb;
	end
end

% ===== Backtrack to find the optimal path
[maxProb, optPath(end)]=max(hmmTable(end, :));
for j=frameNum-1:-1:1
	optPath(j)=prevPos(j+1, optPath(j+1));
end

if plotOpt
	subplot(5,1,1); imagesc(inputData); axis xy
	subplot(5,1,2); plot((1:frameNum)', stateProb); legend('SU', 'V'); set(gca, 'xlim', [-inf inf]);
	subplot(5,1,3); plot(1:frameNum, optPath, 'k.-'); legend('Predcited'); set(gca, 'xlim', [-inf inf]);
	subplot(5,1,4); imagesc(stateProb'); axis xy
	subplot(5,1,5); imagesc(hmmTable'); axis xy
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
