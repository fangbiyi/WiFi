%% lincTrain
% Linear classifier (Perceptron) training 
%% Syntax
% * 		[recogRate, coef, allRecogRate, allCoef] = lincTrain(DS, trainPrm)
%% Description
% 		[recogRate, coef] = lincTrain(DS) trains a linear classifier based on the given dataset DS.
%% Example
%%
%
DS=prData('linSeparable');
trainPrm=lincOptSet('animation', 'yes');
coef=lincTrain(DS, trainPrm);
%% See Also
% <lincTrain_help.html lincTrain>,
% <lincEval_help.html lincEval>,
% <lincOptSet_help.html lincOptSet>.
