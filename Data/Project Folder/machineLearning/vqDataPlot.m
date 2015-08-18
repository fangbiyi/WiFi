function vqDataPlot(data, center, assignment, mode)
%vqDataPlot: Plot the data and the result of vector quantization
%
%	Usage:
%		vqDataPlot(data, center)
%
%	Description:
%		vqDataPlot(data, center) plots the scatter data during vector quantization.
%		This function is primarily used in kMeansClustering.m and vecQuantize.m.
%
%	Example:
%		DS=dcData(2);
%		data=DS.input;
%		center=data(:, [10 3 9 2]);
%		vqDataPlot(data, center);
%
%	See also kMeansClustering, vecQuantize.

%	Category: Vector quantization
%	Roger Jang, 20030330

if nargin<2, selfdemo; return; end
if nargin<4, mode='chunk'; end

data=double(data);
dim = size(data, 1);
dataNum = size(data, 2);
clusterNum = size(center, 2);

if nargin<3		% Find assignment
	switch(mode)	% Copied from kMeansClustering.m
		case 'chunk'
			distMat=distSqrPairwise(data, center);
		case 'circle'
			distMat=zeros(dataNum, clusterNum);
			for i=1:clusterNum
				param=center(:,i);
				distMat(:,i)=abs(sqrt((data(1,:)'-param(1)).^2+(data(2,:)'-param(2)).^2)-param(3));
			end
		otherwise
			error('Unknown mode = %s', mode);
	end
	[minDist, rowMinIndex] = min(distMat, [], 2);
	assignment=zeros(size(distMat));
	assignment((rowMinIndex-1)*dataNum+(1:dataNum)')=1;
end

% Plot data
DS.input=data;
[junk, DS.output]=max(assignment, [], 2);
opt.showAnnotation=0;
opt.showLegend=0;
dsScatterPlot(DS, opt);

% Display the centers
switch(mode)
	case 'chunk'
		for i=1:clusterNum
			line(center(1,i), center(2,i), 'marker', 'o', 'linestyle', 'none', 'linewidth', 2, 'markerSize', 10, 'markerFaceColor', getColor(i), 'markerEdgeColor', 'k');
		end
	case 'circle'
		t=linspace(0, 2*pi);
		for i=1:clusterNum
			param=center(:,i);
			x=param(1)+param(3)*cos(t);
			y=param(2)+param(3)*sin(t);
			line(x, y, 'color', getColor(i));
		end
	otherwise
		error('Unknown mode=%s\n', mode);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
