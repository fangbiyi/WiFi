function [classSize, classLabel] = dsClassSize(DS, plotOpt)
%dsClassSize: Data count for each class for a data set
%
%	Usage:
%		classSize=dsClassSize(DS)
%		[classSize, classLabel]=dsClassSize(DS)
%		[...]=dsClassSize(DS, plotOpt)
%
%	Description:
%		classSize=dsClassSize(DS) returns the size of each class.
%		[classSize, classLabel]=dsClassSize(DS) returns the class labels as well.
%		[...]=dsClassSize(DS, plotOpt) plot the class sizes as a bar chart.
%
%	Example:
%		DS=prData('abalone');
%		[classSize, classLabel]=dsClassSize(DS, 1);

%	Category: Dataset manipulation
%	Roger Jang, 1997xxxx, 20041208, 20080827

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

[featureNum, dataNum] = size(DS.input);		% no. of features
[classLabel, classSize] = elementCount(DS.output);

% Plot class data distribution
if plotOpt
	fprintf('%g features\n', featureNum);
	fprintf('%g instances\n', dataNum);
	fprintf('%g classes\n', length(classLabel));
	bar(classLabel, classSize);
%	xlabel('Classes');
	ylabel('Class sizes');
	if isfield(DS, 'dataName'), title(sprintf('Class distribution for "%s"', DS.dataName)); end
	set(gca, 'xtick', 1:length(DS.outputName));
	xTickLabelRename(DS.outputName);
	xTickLabelRotate(300, 10, 'left')
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
