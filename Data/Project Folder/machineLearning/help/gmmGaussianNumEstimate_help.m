%% gmmGaussianNumEstimate
% Estimate the best number of Gaussians via cross validation
%% Syntax
% * 		[bestGaussianNum, trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData)
% * 		[...]=gmmGaussianNumEstimate(trainData, testData, gmmOpt)
% * 		[...]=gmmGaussianNumEstimate(trainData, testData, gmmOpt, plotOpt)
%% Description
%
% <html>
% <p>[bestGaussianNum, trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData, gmmOpt) returns the estimated number of Gaussians, together with training and test log likelihood for both the training and test data.
% <p>The best number of gaussians is determined according to where the minimum of test log likelihood occurs. (Usually the estimated number of Gaussians is usuallylarger than the desired number of Gaussians, as shown in the example.)
% </html>
%% Example
%%
%
DS=dcData(9);
data=DS.input;
subplot(2,1,1); hist(data, 50);
title('Histogram of the dataset');
trainData=data(:, 1:2:end);
testData=data(:, 2:2:end);
gmmOpt=gmmTrain('defaultOpt');
gmmOpt.config.gaussianNum=1:2:25;
plotOpt=1;
subplot(2,1,2);
[trainLl, testLl]=gmmGaussianNumEstimate(trainData, testData, gmmOpt, plotOpt);
%% See Also
% <gmmEval_help.html gmmEval>,
% <gmmTrain_help.html gmmTrain>,
% <gmmInitPrmSet_help.html gmmInitPrmSet>.
