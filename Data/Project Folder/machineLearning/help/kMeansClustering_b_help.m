%% kMeansClustering_b
% VQ (vector quantization) of K-means clustering using Forgy's batch-mode method
%% Syntax
% * 		center = kMeansClustering(data, clusterNum)
% * 		[center, assignment, distortion, allCenter] = kMeansClustering(data, clusterNum, plotOpt)
%% Description
%
% <html>
% <p>center = kMeansClustering(data, clusterNum, plotOpt) returns the centers after k-means clustering, where
% 	<ul>
% 	<li>data (dim x dataNum): data set to be clustered; where each column is a sample data
% 	<li>clusterNum: number of clusters (greater than one), or matrix of columns of centers
% 	<li>plotOpt: 1 for animation if the dimension is 2
% 	<li>center (dim x clusterNum): final cluster centers, where each column is a center
% 	</ul>
% <p>[center, assignment, distortion, allCenter] = kMeansClustering(data, clusterNum, plotOpt) also returns assignment and distortion, where
% 	<ul>
% 	<li>assignment: final assignment matrix, with assignment(i,j)=1 if data instance i belongs to cluster j
% 	<li>distortion: values of the objective function during iterations
% 	</ul>
% </html>
%% Example
%%
%
DS=dcData(2);
centerNum=8;
plotOpt=1;
[center, assignment, distortion] = kMeansClustering(DS.input, centerNum, plotOpt);
%% See Also
% <vecQuantize_help.html vecQuantize>,
% <vqDataPlot_help.html vqDataPlot>.
