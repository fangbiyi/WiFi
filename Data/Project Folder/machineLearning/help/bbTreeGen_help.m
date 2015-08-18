%% bbTreeGen
% BB (branch-and-Bound) tree generation for nearest neighbor search
%% Syntax
% * 		bbTree=bbTreeGen(data, clusterNum, levelNum, plotOpt);
%% Description
%
% <html>
% <p>bbTree=bbTreeGen(data, clusterNum, levelNum) returns a BB (branch and bound) tree for efficient search of nearest neighbors, where
% 	<ul>
% 	<li>data: Data matrix with each column being an observation vector
% 	<li>clusterNum: No. of clusters (or children) for each node
% 	<li>levelNum: No. of level of the BB tree
% 	<li>bbTree: the returned BB tree with the following fields:
% 		<ul>
% 		<li>bbTree(i).mean: mean vector of a tree node i
% 		<li>bbTree(i).radius: radius vector of a tree node i
% 		<li>bbTree(i).child: indices of children for a non-terminal node i
% 		<li>bbTree(i).dataIndex: indices of data for a terminal node i
% 		<li>bbTree(i).dist2mean: distance to mean of a terminal node i
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
data=rand(2,1000);
clusterNum=3;
level=4;
plotOpt=1;
bbTree=bbTreeGen(data, clusterNum, level, plotOpt);
%% See Also
% <bbTreeSearch_help.html bbTreeSearch>.
