%% lincEval
% Evaluation of linear classifier
%% Syntax
% * 		[lincOutput, recogRate, errorIndex1, errorIndex2, regOutput, regError]=lincEval(DS, coef)
%% Description
% 		lincOutput=lincEval(DS, coef) returns the evaluation result of a linear classifier based on the given dataset DS and coefficients coef.
%% Example
%%
%
DS=prData('linSeparable');
coef=lincTrain(DS);
output=lincEval(DS, coef);
fprintf('Recog. rate = %.2f%%\n', 100*sum(output==DS.output)/length(output));
%% See Also
% <lincTrain_help.html lincTrain>,
% <lincEval_help.html lincEval>,
% <lincOptSet_help.html lincOptSet>.
