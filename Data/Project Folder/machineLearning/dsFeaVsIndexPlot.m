function out = dsFeaVsIndexPlot(DS)
%dsFeaVsIndexPlot: Plot of feature vs. data index
%
%	Usage:
%		out = dsFeaVsIndexPlot(DS)
%
%	Description:
%		out = dsFeaVsIndexPlot(DS) plot featuers vs. data index.
%
%	Example:
%		DS=prData('iris');
%		dsFeaVsIndexPlot(DS);
%
%	See also dsFeaVsIndexPlot.

%	Category: Dataset visualization
%	Roger Jang, 20041209

if nargin<1, selfdemo; return, end

[featureNum, dataNum]=size(DS.input);
distinctClass = elementCount(DS.output);
classNum = length(distinctClass);
plotNum = featureNum;
side = ceil(sqrt(plotNum));
k = 1;
for i = 1:side,
	for j = 1:side,
		if k <= plotNum,
			subplot(side, side, k);
			for p=1:classNum
				index=find(DS.output==distinctClass(p));
				line(index, DS.input(k,index), 'marker', '.', 'lineStyle', 'none', 'color', getColor(p));
			end
			box on; axis([-inf inf -inf inf]);
			xlabel('Data index');
			if isfield(DS, 'inputName')
				ylabel(['x', num2str(k), ': ', DS.inputName{k}]);
			else
				ylabel(['x', num2str(k)]);
			end

			k = k+1;
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
