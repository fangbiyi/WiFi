function bbTree=bbTreeGen(data, clusterNum, levelNum, plotOpt);
%bbTreeGen: BB (branch-and-Bound) tree generation for nearest neighbor search
%	Usage:
%		bbTree=bbTreeGen(data, clusterNum, levelNum, plotOpt);
%
%	Description:
%		bbTree=bbTreeGen(data, clusterNum, levelNum) returns a BB (branch and bound) tree for efficient search of nearest neighbors, where
%			data: Data matrix with each column being an observation vector
%			clusterNum: No. of clusters (or children) for each node
%			levelNum: No. of level of the BB tree
%			bbTree: the returned BB tree with the following fields:
%				bbTree(i).mean: mean vector of a tree node i
%				bbTree(i).radius: radius vector of a tree node i
%				bbTree(i).child: indices of children for a non-terminal node i
%				bbTree(i).dataIndex: indices of data for a terminal node i
%				bbTree(i).dist2mean: distance to mean of a terminal node i
%
%	Example:
%		data=rand(2,1000);
%		clusterNum=3;
%		level=4;
%		plotOpt=1;
%		bbTree=bbTreeGen(data, clusterNum, level, plotOpt);
%
%	See also bbTreeSearch.

%	Category: Nearest Neighbor Search
%	Roger Jang, 20001207

if nargin<1, selfdemo; return; end
if nargin<2, clusterNum=3; end
if nargin<3, levelNum=4; end
if nargin<4, plotOpt=0; end

[dim, dataNum]=size(data);
bbTree=bbTreeNodeGen(data, 1:dataNum, clusterNum, levelNum);

if plotOpt && dim==2
	plot(data(1,:), data(2,:), 'k.');
	axis image
	for i=1:length(bbTree)
		if length(bbTree(i).dataIndex)<=2
			continue;
		end
		level=bbTree(i).level;
		x=data(1, bbTree(i).dataIndex);
		y=data(2, bbTree(i).dataIndex);
		k=convhull(x,y);
		line(x(k), y(k), 'linestyle', '-', 'marker', 'o', 'color', getColor(level), 'linewidth', level);
		text(bbTree(i).mean(1), bbTree(i).mean(2), int2str(i), 'color', getColor(level), 'fontsize', level*10);
	end
end

% ====== Sub function
function bbTree=bbTreeNodeGen(data, index, clusterNum, level, bbTree)
if nargin<5, bbTree=[]; end

theData=data(:,index);
[~, dataCount]=size(theData);

node.level=level;
node.dataIndex=index;
node.mean = mean(theData, 2);
node.dist2mean = distPairwise(node.mean, theData);
node.radius = max(node.dist2mean);
node.child = [];
if isempty(bbTree)
	bbTree=node;
else
	bbTree(end+1)=node;
end

if level==1 || dataCount==1		% Terminal node
	return;
end

% Non-terminal node ===> Create children
[~, U] = kMeansClustering(theData, clusterNum);
currentNodeIndex=length(bbTree);
for i=1:clusterNum
%	fprintf('level=%d, i=%d\n', node.level, i); keyboard
	bbTree(currentNodeIndex).child(end+1)=length(bbTree)+1;
	index0=find(U(:,i));
	index1=index(index0);
	bbTree=bbTreeNodeGen(data, index1, clusterNum, level-1, bbTree);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
