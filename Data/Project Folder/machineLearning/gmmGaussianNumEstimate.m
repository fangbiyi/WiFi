function [bestGaussianNum, trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData, gmmOpt, plotOpt)
%gmmGaussianNumEstimate: Estimate the best number of Gaussians via cross validation
%
%	Usage:
%		[bestGaussianNum, trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData)
%		[...]=gmmGaussianNumEstimate(trainData, testData, gmmOpt)
%		[...]=gmmGaussianNumEstimate(trainData, testData, gmmOpt, plotOpt)
%
%	Description:
%		[bestGaussianNum, trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData, gmmOpt) returns the estimated number of Gaussians, together with training and test log likelihood for both the training and test data.
%		The best number of gaussians is determined according to where the minimum of test log likelihood occurs. (Usually the estimated number of Gaussians is usuallylarger than the desired number of Gaussians, as shown in the example.)
%
%	See also gmmEval, gmmTrain, gmmInitPrmSet.
%
%	Example:
%		DS=dcData(9);
%		data=DS.input;
%		subplot(2,1,1); hist(data, 50);
%		title('Histogram of the dataset');
%		trainData=data(:, 1:2:end);
%		testData=data(:, 2:2:end);
%		gmmOpt=gmmTrain('defaultOpt');
%		gmmOpt.config.gaussianNum=1:2:25;
%		plotOpt=1;
%		subplot(2,1,2);
%		[trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData, gmmOpt, plotOpt);

%	Category: GMM
%	Roger Jang, 20071222

if nargin<1, selfdemo; return; end
if nargin<3, gmmOpt=gmmTrain('defaultOpt'); end
if nargin<4, plotOpt=0; end

vecOfGaussianNum=gmmOpt.config.gaussianNum;
if (length(vecOfGaussianNum)<2), error('Given vector of Gaussian numbers must have a length larger than 1!'); end
trialNum=length(vecOfGaussianNum);
trainLl=nan*zeros(1, trialNum);
testLl=nan*zeros(1, trialNum);
for i=1:trialNum
	% ====== Training GMM model
	theGmmOpt=gmmOpt;
	theGmmOpt.config.gaussianNum=vecOfGaussianNum(i);
	[gmmPrm, logLikelihood] = gmmTrain(trainData, theGmmOpt);
	trainLl(i)=max(logLikelihood);
	testLl(i)=sum(gmmEval(testData, gmmPrm));
	if plotOpt
		fprintf('%d/%d: No. of Gaussians=%d, training LL=%f, test LL=%f\n', i, trialNum, vecOfGaussianNum(i), trainLl(i), testLl(i));
	end
end
[bestValue, bestIndex]=max(testLl);
bestGaussianNum=vecOfGaussianNum(bestIndex);

if plotOpt
	plot(1:trialNum, trainLl, '-o', 1:trialNum, testLl, '-o');
	xlabel('No. of Gaussians');
	ylabel('Log likelihood');
	line(bestIndex, bestValue, 'marker', '*', 'color', 'r');
	legend('Training log likelihood', 'Test log likelihood', 'Location', 'SouthEast');
	xTickLabelRename(vecOfGaussianNum);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
