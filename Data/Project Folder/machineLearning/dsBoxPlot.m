function dsBoxPlot(DS)
% dsBoxPlot: Box plot for a dataset
%
%	Usage:
%		dsBoxPlot(DS)
%
%	Description:
%		dsBoxPlot(DS) plots the features of each class as a box plot to show the features' distributions.
%
%	Example:
%		DS=prData('iris');
%		dsBoxPlot(DS);
%
%	See also dsProjPlot2, dsProjPlot3, dsFeaVsIndexPlot.

%	Category: Dataset visualization
%	Roger Jang, 20140809

if nargin<1, selfdemo; return; end

if isempty(which('boxplot'))
	fprintf('Error: Cannot find "boxplot"  command...\n');
	fprintf('The command "dsBoxPlot" needs to use "boxplot" in the Statistics Toolbox!\n');
end

classNum=max(DS.output);
if ~isfield(DS, 'inputName')
	for i=1:size(DS.input,1)
		DS.inputName{i}=['in', int2str(i)];
	end
end
if ~isfield(DS, 'outputName')
	for i=1:classNum
		DS.inputName{i}=['out', int2str(i)];
	end
end
for i=1:classNum
	feature=DS.input(:, DS.output==i);
	subplot(1, classNum, i);
	boxplot(feature', DS.inputName, 'plotstyle', 'compact'); title(sprintf('Class %d: "%s"', i, DS.outputName{i}));
end
axisLimitSame;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);