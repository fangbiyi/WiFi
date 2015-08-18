function hierClusteringAnim(dataMat, distMat, level)
% hierClusteringAnim: Display the cluster formation of agglomerative hierarchical clustering
%
%	Usage:
%		hierClusteringAnim(dataMat, distMat, level)
%
%	Description:
%		hierClusteringAnim(dataMat, distMat, level) shows the animation of linking 2D data points during agglomerative hierarchical clustering
%			dataMat: data matrix where each column is an observation
%			distMat: distance matrix of the pattern matrix
%			level: hierarchical clustering result of the patern matrix
%
%	Example:
%		DS=dcData(6);
%		data=DS.input;
%		distMat=distPairwise(data);
%		method='single';			% 'single' or 'complete'
%		hcOutput=hierClustering(distMat, method);
%		figure; hierClusteringAnim(data, distMat, hcOutput);
%		figure; hierClusteringPlot(hcOutput);
%
%	See also hierClustering, hierClusteringPlot.

%	Category: Hierarchical clustering
%	Roger Jang, 19981027, 20100731

if nargin<1, selfdemo; return, end

plot(dataMat(1,:), dataMat(2,:), 'bo'); axis image
dataNum=size(dataMat, 2);
for i=2:dataNum,
	if i>=3, set(h, 'color', 'k'); end
	[m, n]=find(distMat==level(i).height);
	h=line(dataMat(1,m), dataMat(2,m), 'color', 'r', 'linewidth', 3, 'erase', 'none');
	drawnow;
%	fprintf('Press any key to form %g clusters ...\n', dataNum-i+1); pause;
%	pause(0.2);
end

% ====== Self demo ======
function selfdemo
mObj=mFileParse(which(mfilename));
for i=1:length(mObj.example), eval(mObj.example{i}); end
