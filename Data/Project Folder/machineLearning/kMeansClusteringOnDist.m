function [centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum, option)
% kMeansClusteringOnDist: K-means clustering on the distance matrix only
%
%	Usage:
%		centerIndex = kMeansClusteringOnDist(distMat, clusterNum)
%		centerIndex = kMeansClusteringOnDist(distMat, clusterNum, option)
%		[centerIndex, U, objFun] = kMeansClusteringOnDist(...)
%
%	Description:
%		[centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum) performs Forgy's k-means clustering on a given distance matrix.
%			distMat: distance matrix whose elements are the pairwise distances of the data objects to be clustered
%			clusterNum: number of clusters
%			centerIndex: final indices of cluster centers
%			U: final partition matrix
%			objFun: values of the objective function during iterations
%			option is an optional argument to control clustering parameters, stopping criteria, and message display during iteration:
%				option.maxIter:		Max. number of iteration (default: 100)
%				option.minImprovement:	Min. amount of improvement (default 1e-5)
%				option.messageDisplay:	Message display during iteration (default: 1)
%		The clustering process stops when the max. number of iteration is reached, or when the objective function improvement between two consecutive iteration is less than the min. amount of improvement specified.
%		This function is different from kMeansClustering in that the given input is a distance matrix instead of a data matrix.
%	
%	Example:
%		data=dcData(6);
%		data=data.input;
%		distMat=distPairwise(data, data);
%		clusterNum=4;
%		[centerIndex, U, objFun] = kMeansClusteringOnDist(distMat, clusterNum);
%		plot(data(1,:), data(2,:), 'ok'); axis image;
%		maxU = max(U);
%		for i=1:clusterNum
%			index=find(U(i, :) == maxU);
%			line(data(1,index), data(2,index), 'linestyle', 'none', 'marker', '*', 'color', getColor(i));
%		end
%
%	See also kMeansClustering, vqCenterObjInit.

%	Category: Vector quantization
%	Roger Jang, 20000206, 20100730

if nargin<1, selfdemo; return; end
if nargin<3
	option.maxIter=100;		% Max. number of iteration
	option.minImprovement=1e-5;	% Min. amount of improvement
	option.messageDisplay=1;		% Info display during iteration
end

dataNum = size(distMat, 1);
objFun = zeros(option.maxIter, 1);		% Array for objective function

centerIndex = vqCenterObjInit(distMat, clusterNum, 3);	% Initial center index
% Main loop
for i=1:option.maxIter
	[centerIndex, objFun(i), U]=kmeansOnDistMatStep(centerIndex, distMat);
	if option.messageDisplay 
		fprintf('Iteration count = %d, obj. function = %f\n', i, objFun(i));
	end
	% check termination condition
	if (i>1) & (abs(objFun(i)-objFun(i-1))<option.minImprovement), break; end,
end
iterNum=i;	% Actual number of iterations 
objFun(iterNum+1:option.maxIter)=[];

% ====== One step of kMeansClusteringOnDist.m
function [centerIndex, objFun, U] = kmeansOnDistMatStep(centerIndex, distMat)
%kmeansOnDistMatStep: One step in k-means clustering with distance matrix only
%
%	Usage:
%		[centerIndex, objFun, U] = kmeansOnDistMatStep(centerIndex, distMat)
%
%	Description: 
%		[centerIndex, objFun, U] = kmeansOnDistMatStep(centerIndex, distMat) return the results from one iteration of k-means clustering on distance matrix.
%			distMat: distance matrix
%			centerIndex: index of center objects
%		This function is primarily used in kMeansClusteringOnDist.m.
%	Category: Vector quantization
%	Roger Jang, 20100731
centerNum = length(centerIndex);
dataNum = size(distMat, 1);
% === Find the U (partition matrix)
[a,b] = min(distMat(centerIndex, :));
index = b+centerNum*(0:dataNum-1);
U = zeros(centerNum, dataNum);
U(index) = ones(size(index));
% === Find the new centers
for i = 1:centerNum,
	dataIndex = find(U(i,:)==1);
	[junk, min_index] = min(sum(distMat(dataIndex, dataIndex)));
	centerIndex(i) = dataIndex(min_index); 
end
% === Find the new objective function
objFun = sum(sum((distMat(centerIndex, :).^2).*U));		% objective function

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
