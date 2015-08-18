%% gmmGrow
% Increase no. of gaussian components within a GMM
%% Syntax
% * 		gmmPrm=gmmGrow(gmmPrm, targetGaussianNum)
%% Description
%
% <html>
% <p>gmmPrm=gmmGrow(gmmPrm, targetGaussianNum) performs center splitting until the target no. of Gaussian components is reached.
% <p>The target number of Gaussian components should be less than or equal to the original number of Gaussian components.
% </html>
%% Example
%%
%
gmmGrowDemo
%% See Also
% <gmmTrain_help.html gmmTrain>,
% <gmmEval_help.html gmmEval>.
