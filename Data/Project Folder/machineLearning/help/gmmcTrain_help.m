%% gmmcTrain
% Train a GMM classifier
%% Syntax
% * 		[cPrm, logLike] = gmmcTrain(DS)
% * 		[cPrm, logLike] = gmmcTrain(DS, opt)
%% Description
%
% <html>
% <p>[cPrm, logLike] = gmmcTrain(DS) returns the parameters of a GMM classifier based on the training of the give dataset DS.
% 	<ul>
% 	<li>DS: Design dataset
% 	<li>opt: GMMC options
% 		<ul>
% 		<li>opt.config.gaussianNum: A column vector indicating no. of Gaussians for each class
% 		<li>opt.config.covType: Type of covariance matrix
% 		<li>tmmcOpt.train: Parameters for training each GMM, which can be obtained via gmmcTrain('defaultOpt').
% 		</ul>
% 	<li>cPrm: Parameters for GMM classifier
% 		<ul>
% 		<li>cPrm.gmm(i): Parameters for class i, which is modeled as a GMM
% 			<ul>
% 			<li>cPrm.gmm(i).gmmPrm(j).mu: a mean vector of dim x 1 for Gaussian component j
% 			<li>cPrm.gmm(i).gmmPrm(j).sigma: a covariance matrix for Gaussian component j
% 			<li>cPrm.gmm(i).gmmPrm(j).w: a weighting factor for Gaussian component j
% 			</ul>
% 		<li>cPrm.prior: Vector of priors, or simply the vector holding no. of entries in each class
% 		<li>(To obtain the class sizes, you can use "dsClassSize".
% 		</ul>
% 	<li>logLike: Vector of log likelihood during training
% 	</ul>
% </html>
%% Example
%%
%
DS=prData('iris');
DS.input=DS.input(3:4, :);
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
opt=gmmcTrain('defaultOpt');
cPrm=gmmcTrain(trainSet, opt);
cOutput=gmmcEval(trainSet, cPrm);
recogRate1=sum(trainSet.output==cOutput)/length(trainSet.output);
fprintf('Inside-test recog. rate = %g%%\n', recogRate1*100);
cOutput=gmmcEval(testSet, cPrm);
recogRate2=sum(testSet.output==cOutput)/length(testSet.output);
fprintf('Outside-test recog. rate = %g%%\n', recogRate2*100);
TS.hitIndex=find(testSet.output==cOutput);
gmmcPlot(testSet, cPrm, 'decBoundary');
%% See Also
% <gmmcEval_help.html gmmcEval>,
% <gmmEval_help.html gmmEval>,
% <gmmTrain_help.html gmmTrain>,
% <gmmMixNumEstimate_help.html gmmMixNumEstimate>.
