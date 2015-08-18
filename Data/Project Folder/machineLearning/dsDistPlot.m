function out=dsDistPlot(DS, opt)
%dsDistPlot: Plot the distribution of features in a data set
%
%	Usage:
%		dsDistPlot(DS)
%
%	Description:
%		dsDistPlot(DS) plot the range of input variables within DS.
%
%	Example:
%		DS=prData('wine');
%		dsDistPlot(DS);

%	Category: Dataset visualization
%	Roger Jang, 20130514

if nargin<1, selfdemo; return; end
if nargin==1 && ischar(DS) && strcmpi(DS, 'defaultOpt')		% Set the default options
	out.useSameAxisLimit=1;
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

outputNum=max(DS.output);
for i=1:outputNum
	index=find(DS.output==i);
	theFeature=DS.input(:, index);
	subplot(1, outputNum, i);
	boxplot(theFeature', DS.inputName, 'plotstyle', 'compact'); title(sprintf('Class %d (%d)', i, length(index)));
end
if opt.useSameAxisLimit
	axisLimitSame;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
