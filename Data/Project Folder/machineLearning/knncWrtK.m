function [misclassify, elapsed_time]=knncWrtK(testSet, trainSet, kMax, plotOpt)
% knncWrtK: Try various values of K in KNN classifier
%
%	Usage:
%		recogRate = knncWrtK(testSet, trainSet, kMax, plotOpt)
%
%	Description:
%		recogRate = knncWrtK(testSet, trainSet, kMax, plotOpt) return the
%		recognition rates of KNNC w.r.t. various values of k ranging from
%		1 to kMax.
%
%	Example:
%		[trainSet, testSet]=prData('iris');
%		designNum=size(trainSet.input, 2);
%		testNum  =size(testSet.input, 2);
%		fprintf('Use of KNNC for Iris data:\n');
%		fprintf('\tSize of design set (odd-indexed data)= %d\n', designNum);
%		fprintf('\tSize of test set (even-indexed data) = %d\n', testNum);
%		kMax=15;
%		plotOpt=1;
%		knncWrtK(testSet, trainSet, kMax, plotOpt);

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19971227, 19990613

if nargin<1, selfdemo; return; end
if nargin<3, kMax=15; end
if nargin<4, plotOpt=0; end

designNum=size(trainSet.input, 2);
testNum  =size(testSet.input, 2);
knncTrainPrm.method='none';
knncPrm=knncTrain(trainSet, knncTrainPrm);
for k=1:kMax
	knncPrm.k=k;
	computed=knncEval(testSet, knncPrm);
	correctCount=sum(testSet.output==computed);
	recog(k)=correctCount/testNum;
	fprintf('\t%d-NNR ===> 1-%d/%d = %.2f%%.\n', k, testNum-correctCount, testNum, recog(k)*100);
end

if plotOpt
	plot(1:kMax, recog*100, 'b-o'); grid on;
	title('Recognition rates of KNN classifier');
	xlabel('K'); ylabel('Recognition rates (%)');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
