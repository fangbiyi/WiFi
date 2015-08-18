function rangeVec=dsRangePlot(DS)
%dsRangePlot: Plot the range of features in a data set
%
%	Usage:
%		rangeVec = dsRangePlot(DS)
%
%	Description:
%		dsRangePlot(DS) plot the range of input variables within DS.
%
%	Example:
%		DS=prData('abalone');
%		rangeVec=dsRangePlot(DS);

%	Category: Dataset visualization
%	Roger Jang, 20070416, 20100804

if nargin<1, selfdemo; return; end

%rangeVec=range(DS.input');
rangeVec=max(DS.input, [], 2)-min(DS.input, [], 2);
[featureNum, dataNum] = size(DS.input);		% no. of features
bar(1:featureNum, rangeVec);
xlabel('Feature indices');
ylabel('Range');
if isfield(DS, 'dataName')
	title(sprintf('Range Plot for "%s"', DS.dataName))
end
if isfield(DS, 'inputName')
	for i=1:featureNum
		text(i, rangeVec(i), DS.inputName{i}, 'vertical', 'bottom', 'horizon', 'center', 'color', 'r');
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
