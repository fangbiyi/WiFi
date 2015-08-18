function gmmPrm=gmmInitPrmSet(data, gmmOpt);
% gmmInitPrmSet: Set initial parameters for GMM
%
%	Usage:
%		gmmPrm=gmmInitPrmSet(data);
%		gmmPrm=gmmInitPrmSet(data, gmmOpt);
%
%	Description:
%		gmmPrm=gmmInitPrmSet(data, gmmOpt) return the initial parameters for GMM.
%			gmmOpt.config.gaussianNum: No. of Gaussians
%			gmmOpt.config.covType: Type of covariance matrix
%		The parameters are usually used as the initial values for GMM training.
%
%	Example:
%		DS=dcData(4);
%		gmmOpt=gmmTrain('defaultOpt');
%		gmmPrm=gmmInitPrmSet(DS.input, gmmOpt)
%
%	See also gmmTrain, gmmEval.

%	Category: GMM
%	Roger Jang, 20080726, 20110616

if nargin<1, selfdemo; return; end
if nargin<2,
	gmmOpt=gmmTrain('defaultOpt');
	gmmOpt.config.gaussianNum=3;
	gmmOpt.config.covType=1;
end

gaussianNum=gmmOpt.config.gaussianNum;
covType=gmmOpt.config.covType;
if isfield(data, 'input'), data=data.input; end;	% data is in the format of dataset
[dim, dataNum]=size(data);

for i=1:gaussianNum
	gmmPrm(i).mu = zeros(dim, 1);
	gmmPrm(i).w = 1/gaussianNum;
	switch covType
		case 1
			gmmPrm(i).sigma = 1;
		case 2
			gmmPrm(i).sigma = ones(dim, 1);
		case 3
			gmmPrm(i).sigma = diag(ones(dim, 1));
		otherwise
			disp('Unknown covType!')
	end
end

% === Set the mean vectors
% Here we try several methods to find the initial mean vectors
if gmmOpt.train.useKmeans
	if gmmOpt.train.showInfo, fprintf('\tStart KMEANS to find the initial mean vectors...\n'); end
%	muMat = kMeansClusteringMex(data, gaussianNum, 0);		% Method 1: Fast but less robust
	muMat = kMeansClustering(data, gaussianNum, 0);			% Method 2: Slow but more robust
	if any(any(~isfinite(muMat)))
		muMat = vectorQuantize(data, gaussianNum, 0);			% Try another method of LBG
	end
	if any(any(~isfinite(muMat)))
		muMat = data(:, 1+floor(rand(gaussianNum,1)*dataNum));	% Try another method of random selection
	end	
else
	muMat = data(:, 1+floor(rand(gaussianNum,1)*dataNum));	% Randomly select several data points as the centers
end
% Set the intitial mean vectors of gmmPrm
meanCell=mat2cell(muMat, dim, ones(1, gaussianNum));
[gmmPrm.mu]=deal(meanCell{:});

% ====== Set the initial covariance matrix
dataRange=max(data, [], 2)-min(data, [], 2);
if gmmOpt.train.useKmeans
	% ====== Set the initial covariance matrix as the min squared distance between centers
	sqrDist=distSqrPairwise(muMat);
%	sqrDist(1:(gaussianNum+1):gaussianNum^2)=inf;	% Diagonal elements are inf
	meanSqrDist = mean(mean(sqrDist))/2*log(2);;			% Initial variance for each Gaussian
	meanSqrDist = max(meanSqrDist, gmmOpt.train.minVariance);
	if gaussianNum==1, meanSqrDist=(mean(dataRange)/5)^2; end	% If there is only a single Gaussian, set it to a reasonable value
	% Set the initial covariance matrix of gmmPrm
	for i=1:gaussianNum
		gmmPrm(i).sigma=meanSqrDist*gmmPrm(i).sigma;
	end
else
	% ====== Set the initial covariance matrix by the range of the input data
	switch covType
		case 1
			for i=1:gaussianNum
				gmmPrm(i).sigma = (mean(dataRange)/5)^2;
			end
		case 2
			for i=1:gaussianNum
				gmmPrm(i).sigma = (dataRange/5).^2;
			end
		case 3
			for i=1:gaussianNum
				gmmPrm(i).sigma = diag((dataRange/5).^2);
			end
		otherwise
			disp('Unknown covType!')
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
