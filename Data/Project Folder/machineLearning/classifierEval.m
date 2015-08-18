function [computedClass, logLike, recogRate, hitIndex, nearestIndex]=classifierEval(classifier, DS, cPrm, plotOpt)
% classifierEval: Evaluation of a given classifier
%
%	Usage:
%		computedClass=classifierEval(classifier, DS, cPrm)
%		computedClass=classifierEval(classifier, DS, cPrm, plotOpt)
%		[computedClass, logLike]=classifierEval(...)
%		[computedClass, logLike, recogRate]=classifierEval(...)
%
%		If DS does not have "output" field, then this command won't return "recogRate" and "hitIndex".
%
%	Description:
%		computedClass=classifierEval(classifier, DS, cPrm) returns the computed class of the dataset DS on a given classifier.
%			classifier: a string specifying a classifier
%				classifier='qc' for quadratic classifier
%				classifier='nbc' for naive Bayes classifier
%				classifier='gmmc' for GMM classifier
%				classifier='knnc' for k-nearest-neighbor classifier
%				classifier='linc' for linear classifier
%				classifier='src' for sparse-representation classifier
%			DS: data set for training
%			cPrm: parameters for the classifier, where cPrm.class(i) is the parameters for class i.
%			computedClass: a vector of computed classes for data instances in DS
%		computedClass=classifierEval(classifier, DS, cPrm, plotOpt) also plots the decision boundary if the dimension is 2.
%		[computedClass, logLike, recogRate]=classifierEval(...) returns	more info, including the log likelihood of each data instance, and the recognition rate (if the DS has the info of desired classes).
%
%	Example:
%		DS=prData('3classes');
%		plotOpt=1;
%		classifier='qc';
%		[cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS);
%		DS.hitIndex=hitIndex;		% Attach hitIndex to DS for plotting
%		classifierPlot(classifier, DS, cPrm, 'decBoundary');

%	See also classifierTrain, classifierPlot.

%	Category: Classifier Evaluation
%	Roger Jang, 20110506

if nargin<1, selfdemo; return; end
if nargin<2, classifier='qc'; end
if nargin<3, cPrm=[]; end
if nargin<4, plotOpt=0; end

if isnumeric(DS)		% DS is actually the input matrix
	inputData=DS;
	clear DS;
	DS.input=inputData;
end

if isfield(cPrm, 'output')
	classNum=length(unique(cPrm.output));	% For KNNC, cPrm could be in the format of a dataset
elseif isfield(cPrm, 'class')
	classNum=length(cPrm.class);
else
	classNum=cPrm.nr_class;		% svm
end

% ====== Input preprocessing
if isfield(cPrm, 'pcaVec')	% for PCA projection
	DS.input=cPrm.pcaVec'*DS.input;
end
if isfield(cPrm, 'ldaVec')	% for LDA projection
	DS.input=cPrm.ldaVec'*DS.input;
end

[dim, dataNum]=size(DS.input);
logLike=zeros(classNum, dataNum);
nearestIndex=[];	% This is only available when the classifier is knnc.

switch(lower(classifier))
	case 'qc'
		for i=1:classNum
			logLike(i,:)=log(cPrm.prior(i));		% Take prior into consideration
		%	logLike(i,:)=logLike(i,:)+gaussianLog(DS.input, cPrm.class(i));
			dataMinusMu = DS.input-cPrm.class(i).mu*ones(1, dataNum);
			logLike(i,:)=logLike(i,:)-0.5*sum(dataMinusMu.*(cPrm.class(i).invSigma*dataMinusMu), 1)+cPrm.class(i).gconst;
		end
		[junk, computedClass]=max(logLike);
	case 'nbc'
		for i=1:classNum
			logLike(i,:)=log(cPrm.prior(i));		% Take weight into consideration
			for j=1:dim
				dataMinusMu = DS.input(j,:)-cPrm.class(i).dim(j).mu*ones(1, dataNum);
				logLike(i,:)=logLike(i,:)-0.5*sum(dataMinusMu.*(cPrm.class(i).dim(j).invSigma*dataMinusMu), 1)+cPrm.class(i).dim(j).gconst;
			end
		end
		[junk, computedClass]=max(logLike);
	case 'gmmc'
		priorLogProb=log(cPrm.prior/sum(cPrm.prior));
		% ====== Fully vectorized version, which is likely to be out of memory
		%outputLogProb=zeros(classNum, dataNum);		% This is memory hog, especially when classNum is big (in speaker id, for example)!!!
		%for i=1:classNum
		%	outputLogProb(i,:)=gmmEval(data, cPrm.class(i).gmmPrm)+priorLogProb(i);
		%end
		%[maxValue, computedClass]=max(outputLogProb);
		% ====== Partial vectorized version, which operates with a chunk of 10000 entries of data at a time to avoid "out of memory" error.
		% chunkSize=1 for fully for-loop version
		% chunkSize=inf for fully vectorized version (which could cause "out of memory" is data size is large)
		chunkSize=10000;
		chunkNum=ceil(dataNum/chunkSize);
		if chunkNum==0, chunkNum=1; end		% This happens when chunkSize=inf
		for j=1:chunkNum
			rangeIndex=((j-1)*chunkSize+1):min(j*chunkSize, dataNum);
			theLogProb=zeros(classNum, length(rangeIndex));
			for i=1:classNum
				theLogProb(i,:)=gmmEval(DS.input(:, rangeIndex), cPrm.class(i).gmmPrm)+priorLogProb(i);
				logLike(i,rangeIndex)=theLogProb(i,:);
			end
		%	[maxValue, computedClass(rangeIndex)]=max(theLogProb);
		end
		[junk, computedClass]=max(logLike);
	case 'knnc'
		if ~isfield(cPrm, 'input')	% cPrm is not in the format of a dataSet, convert it!
			temp.input=[];
			temp.output=[];
			for i=1:length(cPrm.class)
			%	fprintf('i=%d\n', i);
				temp.input=[temp.input, cPrm.class(i).data];
				temp.output=[temp.output, i*ones(1, size(cPrm.class(i).data, 2))];
			end
			temp.k=cPrm.k;
			cPrm=temp;	% Replace cPrm
		end
		[dim, testNum]=size(DS.input);
		[dim, trainNum]=size(cPrm.input);
		classNum=length(unique(cPrm.output));
		k=1;
		if isfield(cPrm, 'k')
			k=cPrm.k;
		end
		% Squared Euclidean distance matrix between sampleInput and testInput
		distMat = distSqrPairwise(cPrm.input, DS.input);
		% knncMat(i,j) = class of i-th nearest point of j-th test input vector (size = k by testNum.)
		[nearestDist, nearestIndex] = sort(distMat, 1);
		%knncMat=cPrm.output(nearestIndex(1:k,:));	% This causes an error when k>1
		knncMat=reshape(cPrm.output(nearestIndex(1:k,:)), k, testNum);
		% classCount(i,j) = number of class-i points in j-th test input's neighborhood
	%	classCount = zeros(classNum, testNum);
	%	for i=1:testNum,
	%		[sortedElement, elementCnt]=elementCount(knncMat(:,i));
	%		classCount(sortedElement, i)=elementCnt;
	%	end
	%	[junk, computedClass]=max(classCount, [], 1);
		computedClass=mode(knncMat, 1);		% "1" is necessary in case knncMat is a vector!
		% === logLike
		if nargout>1
			classDistMat=zeros(classNum, testNum);	% classDiatMat(i,j): Nearest distance of j-th data point to class i
			for i=1:classNum
				index=cPrm.output==i;
				classDistMat(i,:)=min(distMat(index,:));
			end
			logLike=1./(1+classDistMat);
		end
	case 'src'
		if strcmpi(cPrm.optimMethod, 'linprog')
			linProgOpt = struct('Display', 'off', 'TolFun', [], 'Diagnostics', 'off', 'LargeScale', 'on', 'MaxIter', [], 'Simplex', 'off');
			classDist=zeros(classNum, dataNum);
			A=[cPrm.class.input];
			if cPrm.useUnitFeaVec
				A=A/(diag(sqrt(diag(A'*A))));	% Normalize all feature vectors to have a length of 1. Why is this necessary??? 
			end
			n=size(A,2);
			% ====== Compute the predicted class for each data instance
			for j=1:dataNum
				% === Find x1 such that norm(x1, 1) is minimized subject to the constraint A*x1=y
				y=DS.input(:,j);
				if cPrm.useUnitFeaVec, y=y/norm(y); end
				f=ones(2*n,1);
				Aeq=[A -A];
				lb=zeros(2*n,1);
				x1=linprog(f, [], [], Aeq, y, lb, [], [], linProgOpt);
				x1=x1(1:n)-x1(n+1:2*n);
				% === Find the class
				for i=1:classNum
					deltaX=zeros(n, 1); deltaX(cPrm.class(i).index)=x1(cPrm.class(i).index);
					classDist(i,j)=norm(y-A*deltaX);
				end
			end
			logLike=1./classDist;
			[junk, computedClass]=max(logLike);
		elseif strcmpi(cPrm.optimMethod, 'spg')
			addpath([mltRoot, '/externalTool']);			% For using SC
			addpath([mltRoot, '/externalTool/spgl1-1.7']);	% For using L1 minimization within SC
			Train.X=[cPrm.class.input];
			output=[];
			for i=1:length(cPrm.class)
				output=[output, i*ones(1, length(cPrm.class(i).index))];
			end
			Train.y=output;
			Test.X=DS.input;
			Test.y=DS.output;
			[computedClass, relative_error]=SC(Train, Test, 150);
			recogRate=1-relative_error;
			logLike=nan*DS.output;
		else
			error('Unknown cPrm.optimMethod: %s', cPrm.optimMethod);
		end
	case 'svmc'
		addpath([mltRoot, '/externalTool/libsvm-3.11/matlab']);		% Add the path of libsvm by Prof. Chih-Jen Lin
	%	if isfield(cPrm, 'prior'), cPrm=rmfield(cPrm, 'prior'); end	% This extra field causes svm to fail!
	%	if isfield(cPrm, 'prior'), cPrm=rmfield(cPrm, 'prior'); end	% This extra field causes svm to fail!
	%	if isfield(cPrm, 'prior'), cPrm=rmfield(cPrm, 'prior'); end	% This extra field causes svm to fail!
	%	if isfield(cPrm, 'prior'), cPrm=rmfield(cPrm, 'prior'); end	% This extra field causes svm to fail!
		if ~isfield(DS, 'output'), DS.output=[]; end		% This causes svm to fail if the output is empty!
		[computedClass, rr, dec_values_L]=svmpredict(DS.output', DS.input', cPrm);
		computedClass=computedClass';
		logLike=nan*ones(1, length(DS.output));
	%	recogRate=rr(1)/100;	% This is recomputed below
	%	hitIndex=find(computedClass==DS.output);	% This is recomputed below
	otherwise
		error('Unknown classifier: %s', classifier);
end

recogRate=[];
hitIndex=[];
if isfield(DS, 'output')
	hitIndex=find(computedClass==DS.output);
	recogRate=length(hitIndex)/dataNum;
	DS.hitIndex=hitIndex;	% For plotting by classifierPlot
end

if plotOpt && dim==2
	classifierPlot(classifier, DS, cPrm, 'decBoundary');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
