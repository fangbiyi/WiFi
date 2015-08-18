function hierClusteringPlot(level)
%hierClusteringPlot: Plot of the result from agglomerative hierarchical clustering, also known as dendrogram
%
%	Usage:
%		hierClusteringPlot(level)
%			level: the hierarchical clustering output from hierClustering
%
%	Description:
%		hierClusteringPlot(level) plots the output of hierarchical clustering.
%
%	Example:
%		% === This example plots the dendrogram:
%		data=rand(2, 200);           		% 200 data instances of dim 2
%		distMat=distPairwise(data, data);	% Distance matrix of 50 by 50
%		hcOutput=hierClustering(distMat);
%		figure; hierClusteringPlot(hcOutput);		% Plot the dendrogram
%		% === We can also show the animation during clustering:
%		figure; hierClusteringAnim(data, distMat, hcOutput);
%
%	See also hierClustering, hierClusteringAnim.

%	Category: Hierarchical clustering
%	Roger Jang, 19981027, 20100731

if nargin<1, selfdemo; return, end

set(gca, 'xticklabel', []);
xticklabel=level(end).cluster{1};
dataNum=length(level);
axis([1, dataNum, 0, level(end).height]); 
xlabel('Data index');
ylabel('Distance');
title('Dendrogram');
for i=1:dataNum,
	h=text(i, 0, num2str(level(end).cluster{1}(i)));
	set(h, 'rot', 90, 'fontsize', 8, 'hori', 'right');
end

% Generate necessary information for plotting dendrogram
% cap_center is the leg position for future cluster
cap_center(xticklabel)=1:dataNum;
levelinfo(1).cap_center=cap_center; 
% cap_height is the height for each cap
levelinfo(1).cap_height=zeros(1, dataNum);
for i=2:dataNum,
	m=level(i).merged(1);
	n=level(i).merged(2);
	% Find cap_center
	levelinfo(i).cap_center=levelinfo(i-1).cap_center;
	levelinfo(i).cap_center(m)=...
		(levelinfo(i).cap_center(m)+levelinfo(i).cap_center(n))/2; 
	levelinfo(i).cap_center(n)=[];
	% Find cap_height
	levelinfo(i).cap_height=levelinfo(i-1).cap_height;
	levelinfo(i).cap_height(m)=level(i).height;
	levelinfo(i).cap_height(n)=[];
end

% Plot caps for the dendrogram
center=1:dataNum;	% center for each cluster
for i=2:dataNum
	height=level(i).height;
	m=level(i).merged(1);
	n=level(i).merged(2);
	cluster1=level(i-1).cluster{m};
	cluster2=level(i-1).cluster{n};
	left_point=cluster1(end);
	right_point=cluster2(1);
	left=find(xticklabel==left_point);
	right=find(xticklabel==right_point);

	left_x=levelinfo(i-1).cap_center(m);
	left_y=levelinfo(i-1).cap_height(m);
	right_x=levelinfo(i-1).cap_center(n);
	right_y=levelinfo(i-1).cap_height(n);
	line([left_x left_x], [left_y, height]);
	line([right_x right_x], [right_y, height]);
	line([left_x right_x], [height, height]);
end

% Plot level lines for the dendrogram
%for i=1:dataNum,
%	line([1 dataNum], [level(i).height level(i).height], ...
%		'color', 'c', 'linestyle', ':');
%end

% ====== Self demo ======
function selfdemo
mObj=mFileParse(which(mfilename));
for i=1:length(mObj.example), eval(mObj.example{i}); end

