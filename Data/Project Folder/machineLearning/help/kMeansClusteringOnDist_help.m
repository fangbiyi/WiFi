%% kMeansClusteringOnDist
% K-means clustering on the distance matrix only
%% Syntax
% * 		centerIndex = kMeansClusteringOnDist(distMat, clusterNum)
% * 		centerIndex = kMeansClusteringOnDist(distMat, clusterNum, option)
% * 		[centerIndex, U, objFun] = kMeansClusteringOnDist(...)
%% Description
%
% <html>
% <p>[centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum) performs Forgy's k-means clustering on a given distance matrix.
% 	<ul>
% 	<li>distMat: distance matrix whose elements are the pairwise distances of the data objects to be clustered
% 	<li>clusterNum: number of clusters
% 	<li>centerIndex: final indices of cluster centers
% 	<li>U: final partition matrix
% 	<li>objFun: values of the objective function during iterations
% 	<li>option is an optional argument to control clustering parameters, stopping criteria, and message display during iteration:
% 		<ul>
% 		<li>option.maxIter:Max. number of iteration (default: 100)
% 		<li>option.minImprovement:Min. amount of improvement (default 1e-5)
% 		<li>option.messageDisplay:Message display during iteration (default: 1)
% 		</ul>
% 	</ul>
% <p>The clustering process stops when the max. number of iteration is reached, or when the objective function improvement between two consecutive iteration is less than the min. amount of improvement specified.
% <p>This function is different from kMeansClustering in that the given input is a distance matrix instead of a data matrix.
% <li>
% <li>Example:
% <ul>
% <p>data=dcData(6);
% <p>data=data.input;
% <p>distMat=distPairwise(data, data);
% <p>clusterNum=4;
% <p>[centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum);
% <p>plot(data(1,:), data(2,:), 'ok'); axis image;
% <p>maxU = max(U);
% <p>for i=1:clusterNum
% 	<ul>
% 	<li>index=find(U(i, :) == maxU);
% 	<li>line(data(1,index), data(2,index), 'linestyle', 'none', 'marker', '*', 'color', getColor(i));
% 	</ul>
% <p>end
% </html>
%% Example
%%
%
data=dcData(6);
data=data.input;
distMat=distPairwise(data, data);
clusterNum=4;
[centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum);
plot(data(1,:), data(2,:), 'ok'); axis image;
maxU = max(U);
for i=1:clusterNum
	index=find(U(i, :) == maxU);
	line(data(1,index), data(2,index), 'linestyle', 'none', 'marker', '*', 'color', getColor(i));
end
%% See Also
% <kMeansClustering_help.html kMeansClustering>,
% <vqCenterObjInit_help.html vqCenterObjInit>.
