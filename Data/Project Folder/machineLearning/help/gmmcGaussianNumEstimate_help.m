%% gmmcGaussianNumEstimate
% GMM training and test, w.r.t. varying number of mixtures
%% Syntax
% * 		gmmcData=gmmcGaussianNumEstimate(DS, TS)
% * 		gmmcData=gmmcGaussianNumEstimate(DS, TS, gmmcOpt)
% * 		[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(...)
%% Description
%
% <html>
% <p>[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(DS, TS, gmmcOpt)
% 	<ul>
% 	<li>DS: training set
% 	<li>TS: test set
% 	<li>gmmcOpt.config.gaussianNum: an matrix indicating numbers of Gaussian components, where each column is the number of Gaussian components for each class during a trial
% 	<li>gmmcOpt.config.covType: type of covariance matrix, 1: identity times a constant, 2: diagonal, 3: full
% 	<li>gmmcOpt.train: parameter for training GMM
% 	<li>gmmcData: GMM parameters
% 		<ul>
% 		<li>gmmcData(i): in which class j has gmmcOpt.config.gaussianNum(j, i) gaussians
% 		<li>gmmcData(i).class(j): gmm of class j at case i
% 		<li>gmmcData(i).class(j).gmmPrm(k): gaussian k of class j at case i
% 		<li>gmmcData(i).class(j).gmmPrm(k).mu: mean vector
% 		<li>gmmcData(i).class(j).gmmPrm(k).sigma: covariance matrix
% 		<li>gmmcData(i).class(j).gmmPrm(k).w: weight
% 		</ul>
% 	<li>recogRate1: inside-test recognition rate
% 	<li>recogRate2: outside-test recognition rate
% 	<li>validTrialIndex: Actually valid index for
% 	<li>gmmcOpt.config.gaussianNum. (We need to have this output
% 	<li>parameters since sometimes we are given a large number of mixtures which cannot be used for GMM training at all.)
% 	</ul>
% </html>
%% Example
%%
%
[DS, TS]=prData('nonlinearSeparable');
gmmcOpt=gmmcTrain('defaultOpt');
gmmcOpt.config.gaussianNum=1:10;
gmmcOpt.config.covType=1;
gmmcOpt.train.maxIteration=50;
plotOpt=1;
[gmmcData, recogRate1, recogRate2, validTrialIndex]=gmmcGaussianNumEstimate(DS, TS, gmmcOpt, plotOpt);
[rr, index]=max(recogRate2);
figure; gmmcPlot(TS, gmmcData(index), '2dPdf');
figure; gmmcPlot(TS, gmmcData(index), 'decBoundary');
