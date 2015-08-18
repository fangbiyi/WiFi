%% srcTrain
% Training the SRC (sparse-representation classifier)
%% Syntax
% * 		cPrm=srcTrain(DS, opt, showPlot)
% * 			DS: data set for training
% * 			opt: parameters for training (whic is passed to srcEval and used there)
% * 			showPlot: 1 for plotting (which is not used for now)
% * 			cPrm: which is the same as DS for now
%% Description
% 		cPrm=srcTrain(DS, opt, showPlot) returns the training results of SRC
%% Example
%%
%
DS=prData('iris');
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
[cPrm, logLike1, recogRate1]=srcTrain(trainSet);
[computedClass, logLike2, recogRate2, hitIndex]=srcEval(testSet, cPrm);
fprintf('Inside recog rate = %g%%\n', recogRate1*100);
fprintf('Outside recog rate = %g%%\n', recogRate2*100);
%% See Also
% <srcEval_help.html srcEval>.
