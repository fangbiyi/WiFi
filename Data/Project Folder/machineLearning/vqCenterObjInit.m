function centerIndex=vqCenterObjInit(distMat, clusterNum, method)
% vqCenterObjInit: Find the initial centers (objects) for K-means clustering with the distance matrix only
%
%	Usage:
%		centerIndex=vqCenterObjInit(distMat, clusterNum, method)
%
%	Description:
%		centerIndex=vqCenterObjInit(distMat, clusterNum, method) return the initial center index for starting the iteration of k-means clustering on distance matrix.
%			distMat: Distance matrix whose elements are the pairwise distances of the data objects to be clustered
%			centerIndex: final indices of cluster centers
%		This function is primarily used in kmeansOnDistMat.m.
%
%	Example:
%		data=dcData(6);
%		data=data.input;
%		[dim, dataNum]=size(data);
%		distMat=distPairwise(data, data);
%		clusterNum=10;
%		for i=1:3
%			method=i;
%			centerIndex=vqCenterObjInit(distMat, clusterNum, method);
%			subplot(2,2,i);
%			plot(data(1,:), data(2,:), '.'); axis image;
%			for i=1:clusterNum,
%				line(data(1,centerIndex(i)), data(2,centerIndex(i)), 'linestyle', 'none', 'marker', 'o', 'color', 'r');
%			end
%			if method==1, title('Random centers'); end
%			if method==2, title('Centers nearest to the mean'); end
%			if method==3, title('Centers farthest to the mean'); end
%		end

%	Category: Vector quantization
%	Roger Jang, 20000206, 20100730

if nargin<1, selfdemo; return; end

switch method
	case 1	% ====== Method 1: Randomly pick clusterNum data points as cluster centers
		dataNum=size(distMat, 1);
		tmp=randperm(dataNum);
		centerIndex=tmp(1:clusterNum);
	case 2	% ====== Method 2: Choose clusterNum data points closest to the mean vector
		[junk, mean_index]=min(sum(distMat));
		[a,b]=sort(distMat(mean_index, :));
		centerIndex=b(1:clusterNum);
	case 3	% ====== Method 3: Choose clusterNum data points furthest to the mean vector
		[junk, mean_index]=min(sum(distMat));
		[a,b]=sort(distMat(mean_index, :));
		b=fliplr(b);
		centerIndex=b(1:clusterNum);
	otherwise
		disp(['Unknown method in ', mfilename, '!']);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
