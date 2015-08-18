%% svmcEval2
% Evaluation of SVM (support vector machine) classifier
%% Syntax
% * 		computedClass=svmTrain(DS, svmModel)
% * 		[computedClass, ~, recogRate, hitIndex]=svmcEval(DS, svmModel)
%% Description
%
% <html>
% <p><p><tt>computedClass=svmcEval(DS, svmModel)</tt> returns values of SVM (support vector machine) based on the given dataset DS and the SVM model svmModel.
% <p>Note that this function calls the mex files of libsvm directly. If the mex file libsvmpredict.mex* under [mltRoot, '/private'] is not found, you need to obtain it from libsvm website at "http://www.csie.ntu.edu.tw/~cjlin/libsvm/".
% </html>
%% Example
%%
%
DS=prData('iris');
DS.input=DS.input(3:4, :);
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
[svmPrm, logLike1, recogRate1]=svmcTrain(trainSet);
[computedClass, logLike2, recogRate2, hitIndex]=svmcEval(testSet, svmPrm);
fprintf('Inside recog. rate = %g%%\n', recogRate1*100);
fprintf('Outside recog. rate = %g%%\n', recogRate2*100);
%% See Also
% <svmTrain_help.html svmTrain>.
