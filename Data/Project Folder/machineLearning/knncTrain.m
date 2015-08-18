function [knncPrm, logLike, recogRate, hitIndex]=knncTrain(DS, knncTrainPrm, plotOpt)
% knncTrain: Training of KNNC (K-nearest neighbor classifier)
%
%	Usage:
%		knncPrm=knncTrain(DS)
%		knncPrm=knncTrain(DS, knncTrainPrm)
%
%	Description:
%		knncPrm = knncTrain(DS, knncTrainPrm, plotOpt) returns the parameters of KNNC after training, where
%			DS: the training set
%			knncTrainPrm: parameters for training, including
%				knncTrainPrm.method: 'none', 'kMeans', or 'kMeans&lvq'
%				knncTrainPrm.centerNum4eachClass: no. of prototypes for each class
%			knncPrm: parameters for KNNC, including the following necessary fields:
%				knncPrm.method: method for training
%				knncPrm.k: the value of k in KNNR
%				knncPrm.class: class parameters
%					knncPrm.class(i).data: prototypes (centers) for class i
%
%	Example:
%		knncTrainPrm.method='kMeans';
%		knncTrainPrm.centerNum4eachClass=4;
%		[trainSet, testSet]=prData('3classes');
%		knncPrm=knncTrain(trainSet, knncTrainPrm);
%		cClass=knncEval(testSet, knncPrm);
%		hitIndex=find(cClass==testSet.output);
%		recogRate=length(hitIndex)/length(cClass);
%		fprintf('Recog. rate=%.2f%%\n', recogRate*100);
%		testSet.hitIndex=hitIndex;
%		knncPlot(testSet, knncPrm, 'decBoundary');
%
%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19970331, 20040928

if nargin<1, selfdemo; return; end
if ischar(DS) && strcmpi(DS, 'defaultOpt')	% Set the default options
	knncPrm.method='none';
	knncPrm.centerNum4eachClass=4;
	return
end
if nargin<2||isempty(knncTrainPrm), knncTrainPrm=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end
[knncPrm, logLike, recogRate, hitIndex]=classifierTrain('knnc', DS, knncTrainPrm, plotOpt);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);