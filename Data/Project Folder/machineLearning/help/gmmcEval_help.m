%% gmmcEval
% Evaluation of a GMM classifier with a given vector of priors
%% Syntax
% * 		computedClassIndex = gmmcEval(DS, gmmcPrm)
%% Description
%
% <html>
% <p>computedClassIndex = gmmcEval(DS, gmmcPrm) returns the index of computed class of GMMC for each data instance.
% 	<ul>
% 	<li>DS: dataset
% 	<li>gmmcPrm: Parameters for GMM classifier
% 		<ul>
% 		<li>gmmcPrm.class(i): Parameters for class i, which is modeled as a GMM
% 			<ul>
% 			<li>gmmcPrm.class(i).gmmPrm(j).mu: a mean vector of dim x 1 for Gaussian component j
% 			<li>gmmcPrm.class(i).gmmPrm(j).sigma: a covariance matrix for Gaussian component j
% 			<li>gmmcPrm.class(i).gmmPrm(j).w: a weighting factor for Gaussian component j
% 			</ul>
% 		<li>gmmcPrm.prior: Vector of priors, or simply the vector holding no. of entries in each class (To obtain the class sizes, you can use "dsClassSize".
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
[DS, TS]=prData('nonlinearSeparable');
gmmcOpt=gmmcTrain('defaultOpt');
gmmcOpt.config.gaussianNum=3;
gmmcPrm=gmmcTrain(DS, gmmcOpt);
computedOutput=gmmcEval(DS, gmmcPrm);
recogRate1=sum(DS.output==computedOutput)/length(DS.output);
fprintf('Inside-test recog. rate = %g%%\n', recogRate1*100);
computedOutput=gmmcEval(TS, gmmcPrm);
recogRate2=sum(TS.output==computedOutput)/length(TS.output);
fprintf('Outside-test recog. rate = %g%%\n', recogRate2*100);
TS.hitIndex=find(TS.output==computedOutput);
figure; gmmcPlot(DS, gmmcPrm, '2dPdf');
figure; gmmcPlot(DS, gmmcPrm, 'decBoundary');
