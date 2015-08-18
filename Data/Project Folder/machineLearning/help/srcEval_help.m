%% srcEval
% Evaluation of SRC (sparse-representation classifier)
%% Syntax
% * 		[computedClass, invDist, recogRate, hitIndex]=srcEval(DS, srcModel)
% * 		If DS does not have "output" field, then this command won't return "recogRate" and "hitIndex".
%% Description
% 		[computedClass, invDist, recogRate, hitIndex]=srcEval(DS, srcModel, plotOpt) returns the evaluation results of SRC
%% Example
%%
%
DS=prData('iris');
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
opt=srcTrain('defaultOpt');
srcModel=srcTrain(trainSet, opt);
[computedClass, invDist, recogRate, hitIndex]=srcEval(testSet, srcModel);
fprintf('Outside recog rate = %g%% via %s\n', recogRate*100, opt.optimMethod);
opt.optimMethod='SPG';
opt.useUnitFeaVec=0;
srcModel=srcTrain(trainSet, opt);
[computedClass, invDist, recogRate, hitIndex]=srcEval(testSet, srcModel);
fprintf('Outside recog rate = %g%% via %s\n', recogRate*100, opt.optimMethod);
%% See Also
% <srcTrain_help.html srcTrain>,
% <srcPlot_help.html srcPlot>.
