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
	return
end
if nargin<2||isempty(knncTrainPrm), knncTrainPrm=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end

[dim, dataNum]=size(DS.input);
uniqueOutput=unique(DS.output);		% possible output class
classNum=length(uniqueOutput);

if isfield(DS, 'dataName'), knncPrm.dataName=DS.dataName; end
if isfield(DS, 'inputName'), knncPrm.inputName=DS.inputName; end
if isfield(DS, 'outputName'), knncPrm.outputName=DS.outputName; end
knncPrm.trainMethod=knncTrainPrm.method;
knncPrm.k=1;	% k in KNNR, default to be 1
switch(lower(knncTrainPrm.method))
	case lower('none')
		for i=1:classNum
			index=find(DS.output==i);
			knncPrm.class(i).data=DS.input(:, index);
		end
	case lower('kMeans')
		% === K-means clustering
		if ~isfield(knncTrainPrm, 'centerNum4eachClass')
			knncTrainPrm.centerNum4eachClass=4;
		end
		for i=1:classNum
			index=find(DS.output==i);
			theData=DS.input(:, index);
			knncPrm.class(i).data=kMeansClustering(theData, knncTrainPrm.centerNum4eachClass);
		end
	case lower('kMeans&lvq')
		% === K-means clustering and LVQ fine tuning
		if isfield(knncTrainPrm, 'centerNum4eachClass')
			knncTrainPrm.centerNum4eachClass=4;
		end
		for i=1:lclassNum
			index=find(DS.output==i);
			theData=DS.input(:, index);
			knncPrm.class(i).data=kMeansClustering(theData, knncTrainPrm.centerNum4eachClass);
		end
		% === LVQ to be added here
	otherwise
		error('Unknown mode!');
end

if nargout>1
	logLike=zeros(classNum, dataNum);
	for i=1:classNum
		[computedOutput, combinedComputedOutput, nearestIndex, nearestDist, knncMat]=knncEval(DS, knncPrm.class(i).data);
		% === Assuming k (as in KNNC) is equal to 1
		logLike(i,:)=log(1./(1+nearestDist(1,:)));
	end
end
if nargout>2
	recogRate=sum(DS.output==computedOutput)/length(DS.output);
end
if nargout>3
	hitIndex=find(DS.output==computedOutput);
end

if plotOpt & dim==2
	knncPlot(DS, knncPrm, 'decBoundary');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
