function [bestClusterNum, distortion]=clusterValidate(data, maxClusterNum, opt)
% clusterValidate: Cluster validation
%
%	Usage:
%		bestClusterNum=clusterValidate(data)
%		bestClusterNum=clusterValidate(data, maxClusterNum)
%		bestClusterNum=clusterValidate(data, maxClusterNum, opt)
%		[bestClusterNum, distortion]=clusterValidate(...)
%
%	Description:
%		clusterValidate(data, maxClusterNum, opt) returns the best number of clusters based on cluster validation.
%			data: Data for clustering, with each column being an entry
%			maxClusterNum: Maximum no. of clusters
%			opt: options for the function
%				opt.trialNum: no. of trials for each k-means clustering
%				opt.plot: 1 for plotting the result
%			bestClusterNum: the returned best number of clusters
%			distortion: distortion for each k-means from cluster number from 2 to maxClusterNum.
%
%	Example:
%		DS=dcData(6);
%		maxClusterNum=8;
%		opt.trialNum=10;
%		opt.plot=1;
%		bestClusterNum=clusterValidate(DS.input, maxClusterNum, opt);

%	Category: Vector quantization
%	Roger Jang, 20110126

if nargin<1, selfdemo; return; end
if nargin<2, maxClusterNum=10; end
if nargin<3
	opt.trialNum=10;
	opt.plot=0;
end

distortion=nan*ones(maxClusterNum, 1);
for i=2:maxClusterNum
	for j=1:opt.trialNum
	% === use kMeansClustering
	%	[center, U, distortion0]=kMeansClustering(data, i);
	%	obj=distortion0(end);
	% === use kmeans from Stat toolbox
		[index, center, kmDist]=kmeans(data', i);
		obj=sum(kmDist);
	end
	distortion(i)=min(obj);
end
slopeDiff=[nan; diff(diff(distortion))];
[junk, bestClusterNum]=max(slopeDiff);

if opt.plot
	subplot(2,1,1); stem(distortion); xlabel('No. of clusters'); ylabel('Distortion');
	subplot(2,1,2); plot(slopeDiff, '.-');
	line(bestClusterNum, slopeDiff(bestClusterNum), 'marker', 'o', 'color', 'r');
	xlabel('No. of clusters'); ylabel('Diff in slopes');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);