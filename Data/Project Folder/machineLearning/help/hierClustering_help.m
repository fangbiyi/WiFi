%% hierClustering
% Agglomerative hierarchical clustering
%% Syntax
% * 		level=hierClustering(distMat)
% * 		level=hierClustering(distMat, method)
%% Description
%
% <html>
% <p>level=hierClustering(distMat, method) returns the result of agglomerative hierarchical clustering
% 	<ul>
% 	<li>distMat: 2D distance matrix of data points, with diagonal elements of "INF"
% 	<li>method: "single" for single-linkage, "complete" for complete-linkage
% 	<li>level: data structure for a hierarchical clustering result
% 		<ul>
% 		<li>level(i).distMat: distance matrix at level i
% 		<li>level(i).height: the minimum distance measure to form level i
% 		<li>level(i).merged: the two clusters (of level i-1) being merged to form level i
% 		<li>level(i).cluster{j}: a vector denotes the data points in j-th cluster of level i
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
dataNum=50;
dim=2;
data=rand(dim, dataNum);
distMat=distPairwise(data, data);
distMat(1:dataNum+1:dataNum^2)=inf;	% Diagonal elements should always be inf.
level=hierClustering(distMat);
hierClusteringPlot(level);	% Plot the dendrogram
%% See Also
% <hierClusteringPlot_help.html hierClusteringPlot>,
% <hierClusteringAnim_help.html hierClusteringAnim>.
