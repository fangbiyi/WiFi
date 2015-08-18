function dsScatterPlot3(DS)
% dsScatterPlot3: Scatter plot of the first 3 dimensions of the given dataset
%
%	Usage:
%		dsScatterPlot3(DS)
%
%	Description:
%		dsScatterPlot3(DS) give a 3D scatter plot of the dataset stored in DS.
%			DS: data to be displayed
%				DS.input: input part
%				DS.output: output part (this part could be missing for DC)
%				DS.dataName: data name (or description)
%				DS.inputName: data input name
%				DS.annotation: data annotation for each data point 
%		You can click and drag the mouse to change the viewing angle.
%
%	Example:
%		DS=prData('random3');
%		dsScatterPlot3(DS);
%
%	See also dsScatterPlot, dsProjPlot1, dsProjPlot2, dsProjPlot3.

%	Category: Dataset visualization
%	Roger Jang, 20060507

if nargin<1, selfdemo; return; end
if nargin<2, displayAnnotation=1; end

[dim, dataNum]=size(DS.input);
if dim<3, error('Given data dimension is less than 3!'); end
if dim>3, fprintf('Warning: data dim is larger than 3. The plot is based on the first 3 dimensions\n'); end

DS=dsNameAdd(DS);
markerSize=5;
if isfield(DS, 'output')
	classNum=length(unique(DS.output));
	for i=1:classNum
		index=find(DS.output==i);
		xData=DS.input(1, index);
		yData=DS.input(2, index);
		zData=DS.input(3, index);
		line(xData, yData, zData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(i));
	end
else
	xData=DS.input(1, :);
	yData=DS.input(2, :);
	zData=DS.input(3, :);
	line(xData, yData, zData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(1));
end

box on
xlabel(DS.inputName{1});
ylabel(DS.inputName{2});
zlabel(DS.inputName{3});
title(DS.dataName);
axis image
rotate3d on
view(-37.5, 30);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
