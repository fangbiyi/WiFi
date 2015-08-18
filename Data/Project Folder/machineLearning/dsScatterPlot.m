function pointH=dsScatterPlot(DS, opt, dummy4callback)
% dsScatterPlot: Scatter plot of the first 2 dimensions of the given dataset
%
%	Usage:
%		dsScatterPlot(DS)
%		dsScatterPlot(DS, opt)
%
%	Description:
%		dsScatterPlot(DS) give a 2D scatter plot of the dataset stored in DS.
%			DS: data to be displayed
%				DS.input: input part
%				DS.output: output part (this part could be missing for DC)
%				DS.dataName: data name (or description)
%				DS.inputName: data input name
%				DS.annotation: annotation for each data point
%		dsScatterPlot(DS, opt) use the info in opt to show annotation or legend. 
%			opt.showAnnotation: 1 to show the annotation of a data instance (when the cursor is near the data instance)
%			opt.showLegend: 1 to show the legend is shown.
%
%	Example:
%		dataNum=100;
%		DS.input=2*rand(2, dataNum)-1;
%		DS.output=1+(DS.input(1,:)+DS.input(2,:)>0);
%		DS.dataName='Test Data (Click the data point to show its index)';
%		for i=1:length(DS.output)
%			DS.annotation{i}=sprintf('Data point %d\n(%f, %f)', i, DS.input(1,i), DS.input(2,i));
%		end
%		dsScatterPlot(DS);
%
%	See also dsScatterPlot3, dsProjPlot1, dsProjPlot2, dsProjPlot3.

%	Category: Dataset visualization
%	Roger Jang, 20040910

if nargin<1, selfdemo; return; end
if nargin<2|isempty(opt)
	opt.showAnnotation=0;
	opt.showLegend=1;
end
if nargin==3	% This part is used for callback
	userData=get(gcf, 'userdata');
	inData=userData.inData;
	pointLabel=userData.pointLabel;
	circleH=userData.circleH;
	textH=userData.textH;
	temp = get(gca, 'CurrentPoint');
	pos(1,1) = temp(1,1);
	pos(2,1) = temp(1,2);
	xlim=get(gca, 'xlim');
	ylim=get(gca, 'ylim');
	if (xlim(1)<=pos(1) & pos(1)<=xlim(2) & ylim(1)<=pos(2) & pos(2)<=ylim(2))
		distance=distSqrPairwise(pos, inData(1:2, :));
		[minValue, minIndex]=min(distance);
		set(circleH, 'xdata', inData(1, minIndex), 'ydata', inData(2, minIndex));
		set(textH, 'string', pointLabel{minIndex}, 'position', [inData(1:2, minIndex); 0]');
	end
	return
end

[dim, dataNum]=size(DS.input);
if dim<2, fprintf('Warning: Given data dimension is less than 2! Skipping...\n'); return; end
if dim>2, fprintf('Warning: data dim is larger than 2. The plot is based on the first 2 dimensions\n'); end

DS=dsNameAdd(DS);
markerSize=1;
pointH=[];
if isfield(DS, 'output')
	classNum=length(unique(DS.output));
	for i=1:classNum
		index=find(DS.output==i);
		if isempty(index)
			continue;
		%	error(sprintf('No data found for class=%d', i));
		end
		xData=DS.input(1, index);
		yData=DS.input(2, index);
	%	pointH(i)=line(xData, yData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(i), 'markerFaceColor', getColor(i), 'markerEdgeColor', 'k');
		pointH(i)=line(xData, yData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(i), 'markerFaceColor', getColor(i));
	end
else
	xData=DS.input(1, :);
	yData=DS.input(2, :);
%	pointH=line(xData, yData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(1), 'markerFaceColor', getColor(i), 'markerEdgeColor', 'k');
	pointH=line(xData, yData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(1), 'markerFaceColor', getColor(1));
end

box on
xlabel(strPurify(DS.inputName{1}));
ylabel(strPurify(DS.inputName{2}));
title(strPurify(DS.dataName));
if isfield(DS, 'output') & opt.showLegend
	if ~isempty(pointH)
		legend(pointH, DS.outputName, 'location', 'northOutside', 'orientation', 'horizontal');
	end
end
axis image

% For visual display of annotation on each data point of the plot
if opt.showAnnotation
	circleH=line(nan, nan, 'marker', 'o', 'color', 'k', 'erase', 'xor');
	textH=text(0, 0, '', 'hori', 'center', 'vertical', 'top', 'erase', 'xor');
	userData.inData=DS.input;
	userData.pointLabel=DS.annotation;
	userData.circleH=circleH;
	userData.textH=textH;
	set(gcf, 'userData', userData);
	set(gcf, 'WindowButtonMotionFcn', 'dsScatterPlot dummy dummy dummy');
	axis image
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
