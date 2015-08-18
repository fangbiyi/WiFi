%% qcEval
% Evaluation for the QC (quadratic classifier)
%% Syntax
% * 		computedClass=qcEval(DS)
% * 		computedClass=qcEval(DS, cPrm)
% * 		computedClass=qcEval(DS, cPrm, showPlot)
% * 		[computedClass, logLike, recogRate, hitIndex]=qcEval(...)
%% Description
%
% <html>
% <p>[computedClass, logLike, recogRate, hitIndex]=qcEval(DS, cPrm) returns the evaluation results of QC
% 	<ul>
% 	<li>DS: dataset
% 	<li>cPrm: QC parameters
% 	<li>computedClass: computed class of each data instance
% 	<li>logLike: log likelihood of each data instance
% 	<li>recogRate: recognition rate of the QC
% 	<li>hitIndex: vector of the hit indices of the dataset
% 	</ul>
% <p>If DS does not have "output" field, then this command won't return "recogRate" and "hitIndex".
% </html>
%% Example
%%
%
DS=prData('iris');
DS.input=DS.input(3:4, :);
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
[cPrm, logLike1, recogRate1]=qcTrain(trainSet);
[computedClass, logLike2, recogRate2, hitIndex]=qcEval(testSet, cPrm, 1);
fprintf('Inside recog rate = %g%%\n', recogRate1*100);
fprintf('Outside recog rate = %g%%\n', recogRate2*100);
%% See Also
% <qcTrain_help.html qcTrain>.
