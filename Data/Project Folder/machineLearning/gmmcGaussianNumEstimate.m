function [gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(DS, TS, gmmcOpt, plotOpt)
% gmmcGaussianNumEstimate: GMM training and test, w.r.t. varying number of mixtures
%
%	Usage:
%		gmmcData=gmmcGaussianNumEstimate(DS, TS)
%		gmmcData=gmmcGaussianNumEstimate(DS, TS, gmmcOpt)
%		[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(...)
%
%	Description:
%		[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(DS, TS, gmmcOpt)
%			DS: training set
%			TS: test set
%			gmmcOpt.config.gaussianNum: an matrix indicating numbers of Gaussian components, where each column is the number of Gaussian components for each class during a trial
%			gmmcOpt.config.covType: type of covariance matrix, 1: identity times a constant, 2: diagonal, 3: full
%			gmmcOpt.train: parameter for training GMM
%			gmmcData: GMM parameters
%				gmmcData(i): in which class j has gmmcOpt.config.gaussianNum(j, i) gaussians
%				gmmcData(i).class(j): gmm of class j at case i
%				gmmcData(i).class(j).gmmPrm(k): gaussian k of class j at case i
%				gmmcData(i).class(j).gmmPrm(k).mu: mean vector
%				gmmcData(i).class(j).gmmPrm(k).sigma: covariance matrix
%				gmmcData(i).class(j).gmmPrm(k).w: weight
%			recogRate1: inside-test recognition rate
%			recogRate2: outside-test recognition rate
%			validTrialIndex: Actually valid index for
%			gmmcOpt.config.gaussianNum. (We need to have this output
%			parameters since sometimes we are given a large number of mixtures which cannot be used for GMM training at all.)
%
%	Example:
%		[DS, TS]=prData('nonlinearSeparable');
%		gmmcOpt=gmmcTrain('defaultOpt');
%		gmmcOpt.config.gaussianNum=1:10;
%		gmmcOpt.config.covType=1;
%		gmmcOpt.train.maxIteration=50;
%		plotOpt=1;
%		[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(DS, TS, gmmcOpt, plotOpt);
%		[rr, index]=max(recogRate2);
%		figure; gmmcPlot(TS, gmmcData(index), '2dPdf');
%		figure; gmmcPlot(TS, gmmcData(index), 'decBoundary');

%	Category: GMM classifier
%	Roger Jang, 20070516

if nargin<1, selfdemo; return; end
if nargin<3, gmmcOpt=gmmcTrain('defaultOpt'); end

uniqueOutput=unique(DS.output);
classNum=length(uniqueOutput);
gaussianNum=gmmcOpt.config.gaussianNum;	% This should be a matrix of C by K, where C is the no. of classes and K is the no. of trials
if size(gaussianNum, 2)==1, gaussianNum=gaussianNum'; end
if size(gaussianNum, 1)==1, gaussianNum=ones(classNum, 1)*gaussianNum; end
trialNum=size(gaussianNum, 2);

recogRate1=zeros(trialNum, 1);
recogRate2=zeros(trialNum, 1);
[dim, dsNum]=size(DS.input);
[dim, tsNum]=size(TS.input);
fprintf('DS data count = %d, TS data count = %d\n', dsNum, tsNum);
classSizeDS=dsClassSize(DS); fprintf('DS class data count = %s\n', mat2str(classSizeDS));
classSizeTS=dsClassSize(TS); fprintf('TS class data count = %s\n', mat2str(classSizeTS));

% ====== Perform training and compute recognition rates
errorTrialIndex=0;
errorClassIndex=0;
for j=1:trialNum
	fprintf('%d/%d: No. of Gaussian = %s ===> ', j, trialNum, mat2str(gaussianNum(:,j)));
	% ====== Training GMM model for each class
	gmmcData(j).prior=classSizeDS;
	for i=1:classNum
	%	fprintf(' class %d... ', i);
		index=find(DS.output==uniqueOutput(i));
		theData=DS.input(:, index);
		try
			theGmmSpec=gmmcOpt;
			theGmmSpec.config.gaussianNum=gaussianNum(i,j);
			[gmmcData(j).class(i).gmmPrm, logProb] = gmmTrain(theData, theGmmSpec);
		catch
			errorClassIndex=i;
			break;
		end
	end
	if errorClassIndex>0
		errorTrialIndex=j;
		fprintf('Error out on errorTrialIndex=%d and errorClassIndex=%d\n', errorTrialIndex, errorClassIndex);
		break;
	end
	% ====== Compute inside-test recognition rate
%	outProb=zeros(classNum, dsNum);
%	for i=1:classNum
%		outProb(i,:)=gmmEval(DS.input, gmmcData(j).class(i).gmmPrm);
%	end
%	[maxValue, computedClassIndex]=max(outProb);
	computedClassIndex = gmmcEval(DS, gmmcData(j));
	recogRate1(j)=sum(DS.output==computedClassIndex)/length(DS.output);
%	clear outProb computedClassIndex
	% ====== Compute outside-test recognition rate
%	outProb=zeros(classNum, tsNum);
%	for i=1:classNum
%		outProb(i,:)=gmmEval(TS.input, gmmcData(j).class(i).gmmPrm);
%	end
%	[maxValue, computedClassIndex]=max(outProb);
	computedClassIndex = gmmcEval(TS, gmmcData(j));
	recogRate2(j)=sum(TS.output==computedClassIndex)/length(TS.output);
%	clear outProb computedClassIndex
	% ====== Printing
	fprintf('inside RR = %g%%, outside RR = %g%%\n', recogRate1(j)*100, recogRate2(j)*100);
end

validTrialIndex=length(gmmcOpt.config.gaussianNum);
if errorTrialIndex>0
	gmmcData(errorTrialIndex:end)=[];
	recogRate1(errorTrialIndex:end)=[];
	recogRate2(errorTrialIndex:end)=[];
	gaussianNum(:,errorTrialIndex:end)=[];
	validTrialIndex=errorTrialIndex-1;
end

% ====== Plot the result
if plotOpt
	plot(1:validTrialIndex, recogRate1*100, 'o-', 1:validTrialIndex, recogRate2*100, 'square-'); grid on
	[bestValue, bestIndex]=max(recogRate2);
	line(bestIndex, 100*bestValue, 'marker', '*', 'color', 'r');
	legend('Inside test', 'Outside test', 4);
	title('RR wrt trials of various no. of Gaussian components'); ylabel('Recognition Rates (%)');
	vecToBeLabeled={};
	for i=1:size(gaussianNum,2)
		vecToBeLabeled={vecToBeLabeled{:}, mat2str(gaussianNum(:,i))};
	end
	set(gca, 'xtick', 1:size(gaussianNum,2));
	set(gca, 'xticklabel', vecToBeLabeled);
	xTickLabelRotate(90, 10, 'right');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
