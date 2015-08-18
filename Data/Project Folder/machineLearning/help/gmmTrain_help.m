%% gmmTrain
% GMM training for parameter identification
%% Syntax
% * 		gmmModel = gmmTrain(data, gmmOpt)
% * 		gmmModel = gmmTrain(data, gmmOpt, showPlot)
% * 		[gmmModel, logLike] = gmmTrain(...)
% * 		gmmOpt = gmmTrain('defaultOpt');
%% Description
%
% <html>
% <p>gmmModel = gmmTrain(data, opt) performs GMM training and returns the parameters in gmmModel. I/O arguments are as follows:
% 	<ul>
% 	<li>data: dim x dataNum matrix where each column is a data point
% 	<li>opt: gmm options for configuration and training
% 		<ul>
% 		<li>opt.config.gaussianNum: No. of Gaussians
% 		<li>opt.config.covType: Type of covariance matrix
% 		<li>opt.train.showInfo: Displaying info during training
% 		<li>opt.train.useKmeans: Use k-means to find initial centers
% 		<li>opt.train.maxIteration: Max. number of iterations
% 		<li>opt.train.minImprove: Min. improvement over the previous iteration
% 		<li>opt.train.minVariance: Min. variance for each mixture
% 		<li>opt.train.usePartialVectorization specifies the use of vectorized operations, as follows:
% 			<ul>
% 			<li>0 for fully vectorized operation
% 			<li>1 (default) for partial vectorized operation (which is slower but uses less memory)
% 			</ul>
% 		</ul>
% 	<li>gmmModel: The final model for GMM
% 	</ul>
% <p>[gmmModel, logLike] = gmmTrain(data, opt) also returns the log likelihood during the training process.
% <p>For demos, please refer to
% 	<ul>
% 	<li>1-d example: gmmTrainDemo1d.
% 	<li>2-d example: gmmTrainDemo2dCovType01.m, gmmTrainDemo2dCovType02.m, and gmmTrainDemo2dCovType03.
% 	</ul>
% <p>Note that opt.config determines the configuraton of GMM, which is then used to determine the initial GMM parameters by gmmInitPrmSet.m. In fact, opt.config could be a valid GMM parameters that specify the GMM configuration directly. On the other hand, opt.train determines the parameters for training.
% </html>
%% Example
%%
%
DS=dcData(2);
trainingData=DS.input;
opt=gmmTrain('defaultOpt');
opt.config.gaussianNum=8;
opt.config.covType=1;
opt.train.useKmeans=0;
opt.train.showInfo=1;
opt.train.maxIteration=50;
[gmmModel, logLike]=gmmTrain(trainingData, opt, 1);
%% See Also
% <gmmEval_help.html gmmEval>,
% <gmmPlot_help.html gmmPlot>,
% <gmmInitPrmSet_help.html gmmInitPrmSet>.
