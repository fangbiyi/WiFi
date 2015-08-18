function xTickLabelRotate(degree, fontSize, horizontalAlign)
% xTickLabelRotate: Rotate the labels of xtick
%
%	Usage:
%		xTickLabelRotate(degree)
%		xTickLabelRotate(degree, fontSize)
%		xTickLabelRotate(degree, fontSize, horizontalAlign)
%
%	Description:
%		xTickLabelRotate(degree) rotates the tick label of x-axis to the given degree.
%		xTickLabelRotate(degree, fontSize) uses the given font size.
%		xTickLabelRotate(degree, fontSize, horizontalAlign) use the given option for horizontal alignment
%
%	Example:
%		xTickLabel={'Rock', 'Jazz', 'Classic', 'Country', 'Metal', '\alpha', '\pi', '\beta'};
%		subplot(2,1,1);
%		plot(1:10, 1:10);
%		xTickLabelRename(xTickLabel);
%		xTickLabelRotate(330, 10, 'left');
%		subplot(2,1,2);
%		plot(1:10, 1:10);
%		xTickLabelRename(xTickLabel);
%		xTickLabelRotate(60, 10, 'right');
%
%	See also xTickLabelRename.

if nargin<1, selfdemo; return; end
if nargin<2, fontSize=10; end
if nargin<3, horizontalAlign='right'; end

xTick=get(gca, 'xtick');
xTickLabel=get(gca, 'xticklabel');
% Change xTickLabel into a cell string
if isstr(xTickLabel)
	temp={};
	for i=1:size(xTickLabel, 1)
		temp={temp{:}, deblank(xTickLabel(i,:))};
	end
	xTickLabel=temp;
end
set(gca, 'xticklabel', {});
yLim=get(gca,'YLim');

for k =1:length(xTickLabel)
	text(xTick(k), yLim(1)-(yLim(2)-yLim(1))/40, xTickLabel{k});
end

h = findobj(gca, 'type', 'text');
set(h, 'rot', degree, 'fontsize', fontSize, 'hori', horizontalAlign);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
