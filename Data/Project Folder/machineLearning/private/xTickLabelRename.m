function xTickLabelRename(vecToBeLabeled)
%xTickLabelRename: Rename tick labels on x axis sequentially
%
%	Example:
%		vecToBeLabeled=3:3:20;
%		n=length(vecToBeLabeled);
%		subplot(2,1,1);
%		plot(1:n, 1:n);
%		xTickLabelRename(vecToBeLabeled);
%		subplot(2,1,2);
%		vecToBeLabeled={'\pi', '2^5', 'e^{-3}', '\alpha'};
%		n=length(vecToBeLabeled);
%		subplot(2,1,2);
%		plot(1:n, 1:n);
%		xTickLabelRename(vecToBeLabeled);

if nargin<1; selfdemo; return; end

xTick=get(gca, 'xtick');
xTickLabel={};
for i=1:length(xTick)
	if xTick(i)>=1 & xTick(i)<=length(vecToBeLabeled) & round(xTick(i))==xTick(i)
		if isnumeric(vecToBeLabeled)
			xTickLabel={xTickLabel{:}, mat2str(vecToBeLabeled(xTick(i)))};
		else
			xTickLabel={xTickLabel{:}, vecToBeLabeled{xTick(i)}};
		end
	else
		xTickLabel={xTickLabel{:}, ''};
	end
end
set(gca, 'xticklabel', xTickLabel);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
