function opt=dsProjPlot3(DS, opt)
%dsProjPlot3: Plot of all possible 3D projection of the given dataset
%
%	Usage:
%		dsProjPlot3(DS)
%
%	Description:
%		dsProjPlot3(DS) plot all possible 3D projection of the dataset DS.
%
%	Example:
%		DS=prData('iris');
%		dsProjPlot3(DS);
%
%	See also dsProjPlot1, dsProjPlot2, dsScatterPlot, dsScatterPlot3.

%	Category: Dataset visualization
%	Roger Jang, 20041209

if nargin<1, selfdemo; return, end
% ====== Set the default options
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
sequence = combine(1:featureNum, 3);
plotNum = size(sequence,1);
side = ceil(sqrt(plotNum));
side2 = ceil(sqrt(plotNum));
side1=side2;
if side2*(side2-1)>=plotNum
	side1=side2-1;
end

k = 1;
for i = 1:side1
	for j = 1:side2
		if k <= plotNum,
			myAxis(k)=subplot(side1, side2, k);
			cla;
			for p=1:classNum
				index=find(DS.output==distinctClass(p));
				line(DS.input(sequence(k,1),index), DS.input(sequence(k,2),index), DS.input(sequence(k,3),index),'marker', '.', 'lineStyle', 'none', 'color', getColor(p));
			end
			box on; axis([-inf inf -inf inf]); axis image; view(-37.5, 30);
			if ~opt.showAxisTick, set(gca, 'xtick', [], 'ytick', [], 'ztick', []); end
			if opt.showAxisLabel
				if isfield(DS, 'inputName')
					xlabel(['x', num2str(sequence(k,1)), ': ', DS.inputName{sequence(k,1)}]);
					ylabel(['x', num2str(sequence(k,2)), ': ', DS.inputName{sequence(k,2)}]);
					zlabel(['x', num2str(sequence(k,3)), ': ', DS.inputName{sequence(k,3)}]);
				else
					xlabel(['x', num2str(sequence(k,1))]);
					ylabel(['x', num2str(sequence(k,2))]);
					zlabel(['x', num2str(sequence(k,3))]);
				end
			end
			if opt.showClassName
				if k==1 & isfield(DS, 'outputName')
					legendH=legend(DS.outputName, 'location', 'northOutside', 'orientation', 'horizontal');
					position=get(myAxis(k), 'position');
				end
			end
			k = k+1;
		end
	end
end
rotate3d on
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
