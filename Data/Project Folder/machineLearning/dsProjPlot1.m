function opt=dsProjPlot1(DS, opt)
%dsProjPlot1: Plot of output classes vs. each feature
%
%	Usage:
%		dsProjPlot1(DS)
%
%	Description:
%		dsProjPlot1(DS) plot output classes vs each feature. The number of subplots is equal to the number of features.
%
%	Example:
%		DS=prData('iris');
%		dsProjPlot1(DS);
%
%	See also dsProjPlot2, dsProjPlot3, dsFeaVsIndexPlot.

%	Category: Dataset visualization
%	Roger Jang, 20041209

if nargin<1, selfdemo; return, end
if ischar(DS) & strcmp(lower(DS), lower('defaultOpt'))
	opt.showAxisLabel=1;
	opt.showAxisTick=1;
	opt.showClassName=1;
	return
end
if nargin<2, opt=feval(mfilename, 'defaultOpt'); end

clf;
DS=dsNameAdd(DS);
[featureNum, dataNum]=size(DS.input);
distinctClass = elementCount(DS.output);
classNum = length(distinctClass);
plotNum = featureNum;
side = ceil(sqrt(plotNum));
k = 1;
for i=1:side,
	for j=1:side,
		if k<=plotNum,
			myAxis(k)=subplot(side, side, k);
			cla;
			for p = 1:classNum
				index = find(DS.output==distinctClass(p));
				plot(DS.input(k, index), DS.output(index), ['.', getColor(p)]);
				if p==1, hold on; end
			end
			hold off;
			axis([-inf inf -inf inf]);
			if ~opt.showAxisTick, set(gca, 'xtick', [], 'ytick', [], 'ztick', []); end
			if opt.showAxisLabel
				if isfield(DS, 'inputName')
					xlabel(['x', num2str(k), ': ', DS.inputName{k}]);
				else
					xlabel(['x', num2str(k)]);
				end
			end
			if opt.showClassName
				if k==1 & isfield(DS, 'outputName')
					legendH=legend(DS.outputName, 'location', 'northOutside', 'orientation', 'horizontal');
					position=get(myAxis(k), 'position');
				end
			end
			if opt.showAxisLabel
				ylabel('Class');
			end
			k = k+1;
		end
	end
end

% ====== Adjust subplot according to the one with legend
%height=position(end);
%for i=1:length(myAxis)
%	thePos=get(myAxis(i), 'position');
%	thePos(end)=height;
%	set(myAxis(i), 'position', thePos);
%end
% ====== Put legend to the center
if opt.showClassName
	legendPos=get(legendH, 'pos');
	legendPos(1)=(1-legendPos(3))/2;
	legendPos(2)=1-legendPos(4)-0.01;
	set(legendH, 'pos', legendPos);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
