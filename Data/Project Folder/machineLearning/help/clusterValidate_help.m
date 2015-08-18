%% clusterValidate
% Cluster validation
%% Syntax
% * 		bestClusterNum=clusterValidate(data)
% * 		bestClusterNum=clusterValidate(data, maxClusterNum)
% * 		bestClusterNum=clusterValidate(data, maxClusterNum, opt)
% * 		[bestClusterNum, distortion]=clusterValidate(...)
%% Description
%
% <html>
% <p>clusterValidate(data, maxClusterNum, opt) returns the best number of clusters based on cluster validation.
% 	<ul>
% 	<li>data: Data for clustering, with each column being an entry
% 	<li>maxClusterNum: Maximum no. of clusters
% 	<li>opt: options for the function
% 		<ul>
% 		<li>opt.trialNum: no. of trials for each k-means clustering
% 		<li>opt.plot: 1 for plotting the result
% 		</ul>
% 	<li>bestClusterNum: the returned best number of clusters
% 	<li>distortion: distortion for each k-means from cluster number from 2 to maxClusterNum.
% 	</ul>
% </html>
%% Example
%%
%
DS=dcData(6);
maxClusterNum=8;
opt.trialNum=10;
opt.plot=1;
bestClusterNum=clusterValidate(DS.input, maxClusterNum, opt);
