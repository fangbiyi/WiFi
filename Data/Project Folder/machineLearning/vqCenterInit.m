function center = vqCenterInit(data, clusterNum, method)
% vqCenterInit: Find initial centers for VQ of k-means
%
%	Usage:
%		center = vqCenterInit(data, clusterNum)
%		center = vqCenterInit(data, clusterNum, method)
%
%	Description:
%		center=vqCenterInit(data, clusterNum) returns the initial centers for k-means clustering.
%		center=vqCenterInit(data, clusterNum, method) uses the given method for computing the initial centers.
%			method=1: Randomly pick data points as cluster centers
%			method=2: Choose data points closest to the mean vector
%			method=3: Choose data points furthest to the mean vector
%			method=4: Choose the first few data as the centers
%
%	Example:
%		data=dcData(6);
%		data=data.input;
%		clusterNum=10;
%		for i=1:7
%			method=i;
%			center=vqCenterInit(data, clusterNum, method);
%			subplot(3,3,i);
%			plot(data(1,:), data(2,:), '.'); axis image;
%			for i=1:clusterNum
%				line(center(1,i), center(2,i), 'linestyle', 'none', 'marker', 'o', 'color', 'r');
%			end
%			if method==1, title('Random centers'); end
%			if method==2, title('Centers nearest to the mean'); end
%			if method==3, title('Centers farthest to the mean'); end
%			if method==4, title('Centers from the beginning few data points of the dataset'); end
%			if method==5, title('A greedy selection for centers'); end
%			if method==6, title('KKZ'); end
%			if method==7, title('Kevin'); end
%		end
%
%	Reference:
%		M. Al-Daoud and S. Roberts, "New methods for the initialisation of clusters", Technical Report 94.34, School of Computer Studies, University of Leeds, 1994
%		J. He, M. Lan, C.-L. Tan, S.-Y. Sung, and H.-B. Low, "Initialization of Cluster Refinement Algorithms: A Review and Comparative Study", Proc. IEEE Int. Joint Conf. Neural Networks, pp. 297-302, 2004.
%
%	Category: Vector quantization
%	Roger Jang, 20041204

if nargin<1, selfdemo; return; end
if nargin<3; method=6; end

data=double(data);
[dim, dataNum]=size(data);
switch method
	case 1
		% ====== Method 1: Randomly pick clusterNum data points as cluster centers
		temp = randperm(dataNum);
		center = data(:, temp(1:clusterNum));
	case 2
		% ====== Method 2: Choose clusterNum data points closest to the mean vector
		meanVec = mean(data, 2);
		distMat = distSqrPairwise(meanVec, data);
		[minDist, colIndex] = sort(distMat);
		center = data(:, colIndex(1:clusterNum));
	case 3
		% ====== Method 3: Choose clusterNum data points furthest to the mean vector
		meanVec = mean(data, 2);
		distMat = distSqrPairwise(meanVec, data);
		[minDist, colIndex] = sort(-distMat);
		center = data(:, colIndex(1:clusterNum));
	case 4
		% ====== Method 4: Choose first few data as the centers
		center = data(:, 1:clusterNum);
	case 5
		% ====== Method 5: A greedy algorithm
		distMat=distPairwise(data);
		[maxValue, centerIndex]=maxxy(distMat);
		center=data(:, centerIndex);
		distMat(centerIndex(1), centerIndex(2))=0;
		distMat(centerIndex(2), centerIndex(1))=0;
		for i=3:clusterNum
			theDist=distMat(centerIndex, :);
			[junk, index]=max(sum(theDist));
			for j=1:length(centerIndex);
				distMat(index, centerIndex(j))=0;
				distMat(centerIndex(j), index)=0;
			end
			centerIndex=[centerIndex, index];	
		end
		center=data(:, centerIndex);
	case 6
		% ====== Method 6: KKZ
		if dataNum>2000
			% === Resample the data to avoid "out of memory"
			ratio=ceil(dataNum/2000);
			dataIndex=1:ratio:dataNum;	% Between 1000 and 2000
			if clusterNum>length(dataIndex)
				error('Cannot use this type of center initialization since the number of clusters is larger than the reduced dataset!');
			end
			data=data(:, dataIndex);
			dataNum=size(data,2);
		end
		distMat=distPairwise(data);
		[maxValue, centerIndex]=maxxy(distMat);
		center=data(:, centerIndex);
		distMat(1:dataNum+1:dataNum^2)=inf;	% Set the diagonal to be inf
		distMat(centerIndex(1), centerIndex(2))=0;
		distMat(centerIndex(2), centerIndex(1))=0;
		for i=3:clusterNum
			[minValue, minIndex]=min(distMat(centerIndex, :));
			[maxValue, index]=max(minValue);
			for j=1:length(centerIndex);
				distMat(index, centerIndex(j))=0;
				distMat(centerIndex(j), index)=0;
			end
			centerIndex=[centerIndex, index];
		end
		center=data(:, centerIndex);
        
    case 7, % Kevin Ren @ 20110604
        % ====== Method 7: Choose centers one by one based on K-means++
        % Arthur, D. and Vassilvitskii, S. (2007). "k-means++: the
        % advantages of careful seeding". Proceedings of the 18 annual 
        % ACM-SIAM symposium on Discrete algorithms. pp. 1027¡V1035.
        
        dataNum = size(data,2);
        % step 1: Choose an initial center c_1 uniformly at random from data
        [tmp, idx] = sort(rand(1,dataNum));
        center = data(:,idx(1));
        % step 2: choose centers one by one until a total of clusterNum
            % centers are choosen
        selCenterNum=1;
        while (1),
            if selCenterNum == clusterNum, break; end
            % step 2.1: For each data point x, compute D(x), the distance between
            % x and the nearest center that has already been chosen.
            distMat = distPairwise(center, data);
            
            % step 2.2: Choose the next center c_n, selecting c_n with
            % probability D(x)^2 / summation of all D(x)^2
            if selCenterNum > 1,
                distMat = min(distMat);
            end
            distMat = distMat / sum(distMat); % probability
            % accumlated probability of each data point
            cumProb = cumsum(distMat);
            % randomly select data point with accumulated probability
            val = rand(1);
            cumProb = cumProb - val;
            idx = find(cumProb>=0);
            center = [center, data(:,idx(1))];
            
            selCenterNum=selCenterNum+1;
        end        
        
	otherwise
		error('Unknown method!');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
