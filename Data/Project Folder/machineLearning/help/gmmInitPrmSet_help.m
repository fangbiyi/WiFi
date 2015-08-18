%% gmmInitPrmSet
% Set initial parameters for GMM
%% Syntax
% * 		gmmPrm=gmmInitPrmSet(data);
% * 		gmmPrm=gmmInitPrmSet(data, gmmOpt);
%% Description
%
% <html>
% <p>gmmPrm=gmmInitPrmSet(data, gmmOpt) return the initial parameters for GMM.
% 	<ul>
% 	<li>gmmOpt.config.gaussianNum: No. of Gaussians
% 	<li>gmmOpt.config.covType: Type of covariance matrix
% 	</ul>
% <p>The parameters are usually used as the initial values for GMM training.
% </html>
%% Example
%%
%
DS=dcData(4);
gmmOpt=gmmTrain('defaultOpt');
gmmPrm=gmmInitPrmSet(DS.input, gmmOpt)
%% See Also
% <gmmTrain_help.html gmmTrain>,
% <gmmEval_help.html gmmEval>.
