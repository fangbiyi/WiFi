function [cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS, trainPrm, showPlot)
% classifierTrain: Training a given classifier
%
%	Usage:
%		cPrm=classifierTrain(classifier, DS, trainPrm)
%		cPrm=classifierTrain(classifier, DS, trainPrm, showPlot)
%		[cPrm, logLike]=classifierTrain(...)
%		[cPrm, logLike, recogRate]=classifierTrain(...)
%		[cPrm, logLike, recogRate, hitIndex]=classifierTrain(...)
%
%	Description:
%		cPrm=classifierTrain(classifier, DS, trainPrm) returns the training results of a given classifier.
%			classifier: a string specifying a classifier
%				classifier='qc' for quadratic classifier
%				classifier='nbc' for naive Bayes classifier
%				classifier='gmmc' for GMM classifier
%				classifier='knnc' for k-nearest-neighbor classifier
%				classifier='linc' for linear classifier
%				classifier='src' for sparse-representation classifier
%			DS: data set for training
%			trainPrm: parameters for training
%				trainPrm.prior: a vector of class prior probability (Data count based prior is assume if an empty matrix is given.)
%			cPrm: cPrm.class(i) is the parameters for class i, etc.
%		cPrm=classifierTrain(classifier, DS, trainPrm, showPlot) also plot the results if showPlot is 1.
%		[cPrm, logLike, recogRate, hitIndex]=classifierTrain(...) returns additional output arguments:
%			logLike: log likelihood of each data point
%			recogRate: recognition rate (if the desired output is given via DS)
%			hitIndex: vector of indices of correctly classified data points in DS.
%
%	Example:
%		DS=prData('3classes');
%		classifier='knnc';
%		[cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS);
%		DS.hitIndex=hitIndex;		% Attach hitIndex to DS for plotting
%		classifierPlot(classifier, DS, cPrm, 'decBoundary');
%
%	See also classifierEval, classifierPlot.

%	Category: Classifier training
%	Roger Jang, 20110506

if nargin<1, selfdemo; return; end
if nargin==2 && ischar(DS) && strcmpi(DS, 'defaultOpt')
	switch(lower(classifier))
		case 'qc'
			cPrm=[];
		case 'nbc'
			cPrm=[];
		case 'gmmc'
			cPrm=gmmTrain('defaultOpt');
		case 'knnc'
			cPrm.method='none';
			cPrm.centerNum4eachClass=4;
		case {'src', 'src2'}
			cPrm.useUnitFeaVec=1;
			cPrm.optimMethod='linProg';		% 'linProg' or 'SPG'
		case 'svmc'
			cPrm.cost=3;
		otherwise
			error(sprintf('Unknown classifier: %s (in %s)', classifier, mfilename));
	end
	return
end
if nargin<3|isempty(trainPrm), trainPrm=feval(mfilename, classifier, 'defaultOpt'); end
if nargin<4, showPlot=0; end

if ~isfield(trainPrm, 'prior'), trainPrm.prior=dsClassSize(DS); end

[dim, dataNum]=size(DS.input);
classNum=length(unique(DS.output));

% Identify parameters for each class
switch(lower(classifier))
	case 'qc'
		for i=1:classNum
			index=find(DS.output==i);
			temp=gaussianMle(DS.input(:, index));
			cPrm.class(i).mu=temp.mu;
			cPrm.class(i).sigma=temp.sigma;		% How can we combine this into a single statement?
			cPrm.class(i).invSigma=inv(cPrm.class(i).sigma);
			cPrm.class(i).gconst=-0.5*(dim*log(2*pi)+log(det(cPrm.class(i).sigma)));
		end
	case 'nbc'
		for i=1:classNum
			index=find(DS.output==i);
			for j=1:dim
				temp=gaussianMle(DS.input(j, index));
				if (temp.sigma==0)
					range=max(DS.input(j,:))-min(DS.input(j,:));
					if range==0
						error('%s: Range of input %d is zero!', j, mfilename);
					end
					temp.sigma=range/100;
					fprintf('%s: Input %d of class %d is of the same value, a range-based sigma of %f is used instead.\n', mfilename, j, i, temp.sigma);
				end
				cPrm.class(i).dim(j).mu=temp.mu;
				cPrm.class(i).dim(j).sigma=temp.sigma;
				cPrm.class(i).dim(j).invSigma=inv(cPrm.class(i).dim(j).sigma);
				cPrm.class(i).dim(j).gconst=-0.5*(dim*log(2*pi)+log(det(cPrm.class(i).dim(j).sigma)));
			end
		end
	case 'gmmc'
	%	if nargin==2, cPrm=gmmcTrain(DS); end
	%	if nargin==3, cPrm=gmmcTrain(DS, trainPrm); end
	%	if nargin==4, cPrm=gmmcTrain(DS, trainPrm, showPlot); end
		
		gmmcOpt=trainPrm;
		% ====== Collect data
		classLabel=unique(DS.output);
		classNum=length(classLabel);
		if length(gmmcOpt.config.gaussianNum)==1
			gmmcOpt.config.gaussianNum=gmmcOpt.config.gaussianNum*ones(classNum, 1);
		end
		% ====== Train GMM for each class
		for i=1:classNum
		%	fprintf('Training GMM for class %d...\n', i);
			index=find(DS.output==classLabel(i));
			data{i}=DS.input(:, index);
			theGmmOpt=gmmcOpt;
			theGmmOpt.config.gaussianNum=gmmcOpt.config.gaussianNum(i);
			[cPrm.class(i).gmmPrm, logLike{i}] = gmmTrain(data{i}, theGmmOpt);
		end
	case 'knnc'
		if isfield(DS, 'dataName'), cPrm.dataName=DS.dataName; end
		if isfield(DS, 'inputName'), cPrm.inputName=DS.inputName; end
		if isfield(DS, 'outputName'), cPrm.outputName=DS.outputName; end
		cPrm.trainMethod=trainPrm.method;
		cPrm.k=1;	% k in KNNC, default to be 1
		% ===== KNNC training
		switch(lower(trainPrm.method))
			case lower('none')
				for i=1:classNum
					index=find(DS.output==i);
					cPrm.class(i).data=DS.input(:, index);
				end
			case lower('kMeans')
				% === K-means clustering
				if ~isfield(trainPrm, 'centerNum4eachClass')
					trainPrm.centerNum4eachClass=4;
				end
				for i=1:classNum
					index=find(DS.output==i);
					theData=DS.input(:, index);
					cPrm.class(i).data=kMeansClustering(theData, trainPrm.centerNum4eachClass);
				end
			otherwise
				error('Unknown mode!');
		end
	case {'src', 'src2'}
		cPrm.useUnitFeaVec=trainPrm.useUnitFeaVec;
		cPrm.optimMethod=trainPrm.optimMethod;
		uniqClass=unique(DS.output);
		classNum=length(uniqClass);
		for i=1:classNum
			classDataIndex=find(uniqClass(i)==DS.output);
			cPrm.class(i).input=DS.input(:, classDataIndex);
			cPrm.class(i).index=classDataIndex;			% Index into [cPrm.class.input]
		end
	case 'svmc'
		addpath([mltRoot, '/externalTool/libsvm-3.11/matlab']);		% Add the path of libsvm by Prof. Chih-Jen Lin
		svmOpt=['-q -t 2 -c ' num2str(trainPrm.cost)];
		cPrm=svmtrain(DS.output', DS.input', svmOpt);
	otherwise
		error(sprintf('Unknown classifier: %s (in %s)', classifier, mfilename));
end

if ~strcmp(classifier, 'svmc')	% The following extra fields cause svmpredict to return empty vectors!
	if isfield(DS, 'dataName'), cPrm.dataName=DS.dataName; end
	if isfield(DS, 'inputName'), cPrm.inputName=DS.inputName; end
	if isfield(DS, 'outputName'), cPrm.outputName=DS.outputName; end
	cPrm.prior=trainPrm.prior;
end

switch(lower(classifier))
	case {'qc', 'nbc', 'gmmc', 'knnc', 'svmc'}
		[computedClass, logLike, recogRate, hitIndex]=classifierEval(classifier, DS, cPrm);
	case {'src', 'src2'}
		computedClass=DS.output;
		logLike=inf*ones(classNum, dataNum);
		for i=1:dataNum, logLike(DS.output(i), i)=0; end
		recogRate=1;	% 100% for SRC
		hitIndex=1:dataNum;
	otherwise
		error(sprintf('Unknown classifier: %s (in %s)', classifier, mfilename));
end

if showPlot & dim==2
	if isfield(DS, 'output')
		DS.hitIndex=find(computedClass==DS.output);	% For classifierPlot
	end
	classifierPlot(classifier, DS, cPrm, 'decBoundary');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
