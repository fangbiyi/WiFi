function [cPrm, logLike, recogRate, hitIndex]=nbcTrain(DS, opt, showPlot)
% nbcTrain: Training the naive Bayes classifier (NBC)
%
%	Usage:
%		[cPrm, logLike, recogRate, hitIndex]=nbcTrain(DS, opt, showPlot)
%			DS: data set for training
%			opt: parameters for training
%				opt.prior: a vector of class prior probability
%				(Data count based prior is assume if an empty matrix is given.)
%			showPlot: 1 for plotting
%			cPrm: cPrm.class(i) is the parameters for class i, etc.
%			recogRate: recognition rate
%			hitIndex: index of the correctly classified data points
%
%	Description:
%		[cPrm, logLike, recogRate, hitIndex]=nbcTrain(DS, opt, showPlot) returns the training results of the naive bayes classifier
%
%	Example:
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);
%		trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
%		 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
%		[cPrm, logLike1, recogRate1]=nbcTrain(trainSet);
%		[computedClass, logLike2, recogRate2, hitIndex]=nbcEval(testSet, cPrm, 1);
%		fprintf('Inside recog rate = %g%%\n', recogRate1*100);
%		fprintf('Outside recog rate = %g%%\n', recogRate2*100);
%
%	See also nbcEval, nbcPlot.

%	Category: Naive Bayes classifier
%	Roger Jang, 20110428

classifier='nbc';
if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	cPrm=classifierTrain(classifier, 'defaultOpt');
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end
[cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS, opt, showPlot);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
