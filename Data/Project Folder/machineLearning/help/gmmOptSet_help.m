%% gmmOptSet
% Set the options of a GMM (Gaussian mixture model) for configuration and training
%% Syntax
% * 		gmmOpt=gmmOptSet;
%% Description
%
% <html>
% <p>gmmOpt=gmmOptSet return the options of a GMM.
% 	<ul>
% 	<li>gmmOpt.config: Configuration of GMM
% 	<li>gmmOpt.config.guassianNum: No. of Gaussian components
% 	<li>gmmOpt.config.covType: Type of covariance matrix
% 	<li>gmmOpt.train: Training options, see gmmTrainOptSet.m
% 	</ul>
% </html>
%% Example
%%
%
DS=dcData(4);
gmmOpt=gmmOptSet;
gmmPrm=gmmInitPrmSet(DS.input, gmmOpt);
%% See Also
% <gmmTrain_help.html gmmTrain>,
% <gmmEval_help.html gmmEval>,
% <gmmTrainOptSet_help.html gmmTrainOptSet>.
