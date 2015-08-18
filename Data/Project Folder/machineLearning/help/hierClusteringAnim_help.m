%% hierClusteringAnim
% Display the cluster formation of agglomerative hierarchical clustering
%% Syntax
% * 		hierClusteringAnim(dataMat, distMat, level)
%% Description
%
% <html>
% <p>hierClusteringAnim(dataMat, distMat, level) shows the animation of linking 2D data points during agglomerative hierarchical clustering
% 	<ul>
% 	<li>dataMat: data matrix where each column is an observation
% 	<li>distMat: distance matrix of the pattern matrix
% 	<li>level: hierarchical clustering result of the patern matrix
% 	</ul>
% </html>
%% Example
%%
%
DS=dcData(6);
data=DS.input;
distMat=distPairwise(data);
method='single';			% 'single' or 'complete'
hcOutput=hierClustering(distMat, method);
figure; hierClusteringAnim(data, distMat, hcOutput);
figure; hierClusteringPlot(hcOutput);
%% See Also
% <hierClustering_help.html hierClustering>,
% <hierClusteringPlot_help.html hierClusteringPlot>.
