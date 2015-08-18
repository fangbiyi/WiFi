function [center, assignment, distortion, allCenter] = kMeansClustering(data, clusterNum, plotOpt)
% kMeansClustering: VQ (vector quantization) of K-means clustering using Forgy's batch-mode method
%
%	Usage:
%		center = kMeansClustering(data, clusterNum)
%		[center, assignment, distortion, allCenter] = kMeansClustering(data, clusterNum, plotOpt)
%
%	Description: 
%		center = kMeansClustering(data, clusterNum, plotOpt) returns the centers after k-means clustering, where
%			data (dim x dataNum): data set to be clustered; where each column is a sample data
%			clusterNum: number of clusters (greater than one), or matrix of columns of centers
%			plotOpt: 1 for animation if the dimension is 2
%			center (dim x clusterNum): final cluster centers, where each column is a center
%		[center, assignment, distortion, allCenter] = kMeansClustering(data, clusterNum, plotOpt) also returns assignment and distortion, where
%			assignment: final assignment matrix, with assignment(i,j)=1 if data instance i belongs to cluster j
%			distortion: values of the objective function during iterations
%
%	Example:
%		DS=dcData(2);
%		centerNum=6;
%		plotOpt=1;
%		[center, assignment, distortion] = kMeansClustering(DS.input, centerNum, plotOpt);
%
%	See also vecQuantize, vqDataPlot.

%	Category: Vector quantization
%	Roger Jang, 20030330

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

if ~isa(data, 'double'), data=double(data); end		% Convert to double if necessary
[dim, dataNum]=size(data);
if clusterNum==1 | (size(clusterNum,1)>1 & size(clusterNum,2)==1)	% A single cluster
	center=mean(data, 2);
	assignment=ones(dataNum, 1);
	distortion=sum(sum((data-center*ones(1,dataNum)).^2));
	allCenter=center;
	return;
end

maxIterCount = 200;				% Max. iteration
distortion = zeros(maxIterCount, 1);		% Array for objective function
if length(clusterNum)==1
	center = vqCenterInit(data, clusterNum);	% Initial cluster centers
else
	center = clusterNum;				% The passed argument is actually a matrix of cluster centers
end
if nargout==4, allCenter(:,:,1)=center; end

if plotOpt & dim==2
	plot(data(1,:), data(2,:), 'b.');
	centerH=line(center(1,:), center(2,:), 'color', 'r', 'marker', 'o', 'linestyle', 'none', 'linewidth', 2);
	axis image
end

% Main loop
for i = 1:maxIterCount,
	[center, distortion(i), assignment] = vqUpdateCenter(center, data);
	if nargout==4, allCenter(:,:,i+1)=center; end
	if plotOpt, fprintf('Iteration count = %d/%d, distortion = %f\n', i, maxIterCount, distortion(i)); end
	if plotOpt & dim==2 
	%	set(centerH, 'xdata', center(1,:), 'ydata', center(2,:));
	%	drawnow;
	clf; vqDataPlot(data, center, assignment); drawnow;
	end
	% check termination condition
	if (i>1) & (abs(distortion(i-1)-distortion(i))<eps), break; end
end
loopCount = i;	% Actual number of iterations 
distortion(loopCount+1:maxIterCount) = [];
%if plotOpt & dim==2, figure; vqDataPlot(data, center, assignment); end

% ========== subfunctions ==========

% ====== Update centers
function [center, distortion, assignment] = vqUpdateCenter(center, data)
[dim, dataNum] = size(data);
centerNum = size(center, 2);
% ====== Compute distance matrix
distMat=distSqrPairwise(data, center);
% ====== Find the U (partition matrix)
[minDist, rowMinIndex] = min(distMat, [], 2);
assignment=zeros(size(distMat));
assignment((rowMinIndex-1)*dataNum+(1:dataNum)') = 1;
distortion = sum(minDist);	% objective function
% ====== Find new centers
index=find(sum(assignment)==0);
emptyGroupNum=length(index);
if emptyGroupNum==0	% Find the new centers (with no empty cluster)
	center = (data*assignment)./(ones(dim,1)*sum(assignment));	% Find the new centers
else	% Add new centers for the empty clusters
	fprintf('Found %d empty group(s)!\n', emptyGroupNum);
	assignment(:,index)=[];
	center = (data*assignment)./(ones(dim,1)*sum(assignment));	% Find the new centers
	if emptyGroupNum<=centerNum/2	% 找出 distortion 最大的幾個 cluster 來進行 center splitting
		fprintf('Try center splitting...\n');
		distMat(:,index)=[];
		distortionByGroup=sum(distMat.*assignment);
		[junk, index]=sort(-distortionByGroup);   % Find the indices of the centers to be split
		index=index(1:emptyGroupNum);
		temp=center; temp(:, index)=[];
		center=[temp, center(:,index)-eps, center(:,index)+eps];	% Center splitting
		distMat=distSqrPairwise(data, center);
		[minDist, rowMinIndex] = min(distMat, [], 2);
		assignment = zeros(size(distMat));
		assignment((rowMinIndex-1)*dataNum+(1:dataNum)') = 1;
		distortion = sum(minDist);	% objective function
		center = (data*assignment)./(ones(dim,1)*sum(assignment));
	else	% Select new centers based on random selection on the data points
		fprintf('Try random selection...\n');
		newU = zeros(1,1);
		while ~isempty(find(sum(newU, 2)==0))
			temp=randperm(dataNum);
			selectedIndex=temp(1:emptyGroupNum);
			newU = [zeros(emptyGroupNum, dataNum); U];
			for i=1:emptyGroupNum
				dataIndex=selectedIndex(i);
				index=find(U(:, dataIndex)==1);
				newU(index, dataIndex)=0;
				newU(i, dataIndex)=1;
			end
		end
		U=newU;
		distortion = sum(minDist);	% objective function
		center=[center, data(:, selectedIndex)];
		assignment=U';
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
