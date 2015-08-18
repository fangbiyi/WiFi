function [computedClass, invDist, recogRate, hitIndex]=srcEval(DS, srcModel, plotOpt)
% srcEval: Evaluation of SRC (sparse-representation classifier)
%
%	Usage:
%		[computedClass, invDist, recogRate, hitIndex]=srcEval(DS, srcModel)
%		If DS does not have "output" field, then this command won't return "recogRate" and "hitIndex".
%
%	Description:
%		[computedClass, invDist, recogRate, hitIndex]=srcEval(DS, srcModel, plotOpt) returns the evaluation results of SRC
%
%	Example:
%		DS=prData('iris');
%		trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
%		 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
%		opt=srcTrain('defaultOpt');
%		srcModel=srcTrain(trainSet, opt);
%		[computedClass, invDist, recogRate, hitIndex]=srcEval(testSet, srcModel);
%		fprintf('Outside recog rate = %g%% via %s\n', recogRate*100, opt.optimMethod);
%		opt.optimMethod='SPG';
%		opt.useUnitFeaVec=0;
%		srcModel=srcTrain(trainSet, opt);
%		[computedClass, invDist, recogRate, hitIndex]=srcEval(testSet, srcModel);
%		fprintf('Outside recog rate = %g%% via %s\n', recogRate*100, opt.optimMethod);
%
%	See also srcTrain, srcPlot.

%	Category: Sparse-representation classifier
%	Roger Jang, 20111029

if nargin<1, selfdemo; return; end
if nargin<2, srcModel=[]; end
if nargin<3, plotOpt=0; end
[computedClass, invDist, recogRate, hitIndex]=classifierEval('src', DS, srcModel, plotOpt);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
