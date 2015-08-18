function level=hierClustering(distMat, method)
%hierClustering: Agglomerative hierarchical clustering
%
%	Usage:
%		level=hierClustering(distMat)
%		level=hierClustering(distMat, method)
%
%	Description:
%		level=hierClustering(distMat, method) returns the result of agglomerative hierarchical clustering
%			distMat: 2D distance matrix of data points, with diagonal elements of "INF"
%			method: "single" for single-linkage, "complete" for complete-linkage
%			level: data structure for a hierarchical clustering result
%				level(i).distMat: distance matrix at level i
%				level(i).height: the minimum distance measure to form level i 
%				level(i).merged: the two clusters (of level i-1) being merged to form level i 
%				level(i).cluster{j}: a vector denotes the data points in j-th cluster of level i 
%
%	Example:
%		dataNum=50;
%		dim=2;
%		data=rand(dim, dataNum);
%		distMat=distPairwise(data, data);
%		distMat(1:dataNum+1:dataNum^2)=inf;	% Diagonal elements should always be inf.
%		level=hierClustering(distMat);
%		hierClusteringPlot(level);	% Plot the dendrogram
%
%	See also hierClusteringPlot, hierClusteringAnim.

%	Category: Hierarchical clustering
%	Roger Jang, 19981027, 20080117, 20100731

if nargin<1, selfdemo; return; end
if nargin<2, method='single'; end

dataNum=size(distMat, 1);
distMat(1:dataNum+1:dataNum^2)=inf;	% Diagonal distances should always be inf.
level(1).distMat=distMat;
level(1).height=0;
level(1).merged=[];
for i=1:dataNum,
	level(1).cluster{i}=[i];
end
for i=2:dataNum,
	level(i)=merge(level(i-1), method);
end

% ====== Merge clusters
function levelOutput=merge(level, method)
% MERGE Merge a level of n clusters into n-1 clusters

[minI, minJ, minValue]=minxy(level.distMat);
if minI>minJ, temp=minI; minI=minJ; minJ=temp; end	% Reorder to have minI < minJ
levelOutput=level;
levelOutput.height=minValue;		% Update height
levelOutput.merged=[minI minJ];	% Update merged cluster
% Update cluster
levelOutput.cluster{minI}=[levelOutput.cluster{minI} levelOutput.cluster{minJ}];
levelOutput.cluster(minJ)=[];	% delete cluster{minJ}

% New distance matrix
distMat2=level.distMat;
% "min" for single-linkage; "max" for complete-linkage
if strcmp(method, 'single'),
	distMat2(:, minI)=min(distMat2(:, minI), distMat2(:, minJ)); 
	distMat2(minI, :)=min(distMat2(minI, :), distMat2(minJ, :)); 
elseif strcmp(method, 'complete'),
	distMat2(:, minI)=max(distMat2(:, minI), distMat2(:, minJ)); 
	distMat2(minI, :)=max(distMat2(minI, :), distMat2(minJ, :)); 
else
	error(sprintf('Unsupported method in %s!', mfilename));
end

distMat2(minJ, :)=[];
distMat2(:, minJ)=[];
distMat2(minI, minI)=inf;
levelOutput.distMat=distMat2;

% ====== Find the minimum value in a matrix
function [i, j, minValue]=minxy(A)
[valueRow, indexRow]=min(A);
[minValue, j]=min(valueRow);
i=indexRow(j);

% ====== Self demo ======
function selfdemo
mObj=mFileParse(which(mfilename));
for i=1:length(mObj.example), eval(mObj.example{i}); end
