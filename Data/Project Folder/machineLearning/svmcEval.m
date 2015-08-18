function [computedClass, logLike, recogRate, hitIndex]=svmcEval(DS, cPrm, showPlot)
% svmTrain: Evaluation of SVM (support vector machine) classifier
%
%	Usage:
%		computedClass=svmTrain(DS, cPrm)
%		[computedClass, ~, recogRate, hitIndex]=svmcEval(DS, cPrm)
%
%	Description:
%		<p><tt>computedClass=svmcEval(DS, cPrm)</tt> returns values of SVM (support vector machine) based on the given dataset DS and the SVM model cPrm.
%		Note that this function calls the mex files of libsvm directly. If the mex file libsvmpredict.mex* under [mltRoot, '/private'] is not found, you need to obtain it from libsvm website at "http://www.csie.ntu.edu.tw/~cjlin/libsvm/".
%
%	Example:
%		DS=prData('iris');
%		trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
%		testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
%		[svmPrm, logLike1, recogRate1]=svmcTrain(trainSet);
%		[computedClass, logLike2, recogRate2, hitIndex]=svmcEval(testSet, svmPrm);
%		fprintf('Inside recog. rate = %g%%\n', recogRate1*100);
%		fprintf('Outside recog. rate = %g%%\n', recogRate2*100);
%
%	See also svmTrain.

%	Category: Support vector machine
%	Roger Jang, 20111029

classifier='svmc';
if nargin<1, selfdemo; return; end
if nargin<2, cPrm=[]; end
if nargin<3, showPlot=0; end

[computedClass, logLike, recogRate, hitIndex]=classifierEval(classifier, DS, cPrm, showPlot);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
