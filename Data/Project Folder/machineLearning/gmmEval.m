function [logLike, gaussianProb] = gmmEval(data, gmmPrm, chunkSize);
% gmmEval: Evaluation of a GMM (Gaussian mixture model)
%
%	Usage:
%		[logLike, gaussianProb] = gmmEval(data, gmmPrm);
%		[logLike, gaussianProb] = gmmEval(data, gmmPrm, chunkSize);
%
%	Description:
%		[logLike, gaussianProb] = gmmEval(data, gmmPrm) returns the log likelihood of a GMM model for each column of the given data matrix, where
%		data: dim x dataNum matrix where each column is a data point
%		gmmPrm(i): Parameters for Gaussian component i
%			gmmPrm(i).mu: a mean vector of dim x 1
%			gmmPrm(i).sigma: a covariance matrix of 3 possible dimensions:
%				1 x 1: identity covariance matrix times a constant for each Gaussian
%				dim x 1: diagonal covariance matrix for each Gaussian
%				dim x dim: full covariance matrix for each Gaussian
%			gmmPrm(i).w: a weighting factor
%		chunkSize: size of a chunk for vectorization
%			1 for fully for-loop version
%			inf for fully vectorized version (which could cause "out of memory" is data size is large)
%			(To see the effects of chunkSize, try gmmEvalSpeedTest.m under test folder of DCPR toolbox.)
%		logLike: 1 x dataNum vector of output probabilities
%		gaussianProb(i,j) is the probability of data(:,j) to the i-th Gaussian (This is for gmmTrain.m only)
%
%	Example:
%		% === The following example plots GMM results of 1-D data:
%		data=linspace(-10, 10, 101);
%		gmmPrm(1).mu = -5; gmmPrm(1).sigma = 1; gmmPrm(1).w = 0.1;
%		gmmPrm(2).mu =  0; gmmPrm(2).sigma = 4; gmmPrm(2).w = 0.5;
%		gmmPrm(3).mu =  5; gmmPrm(3).sigma = 3; gmmPrm(3).w = 0.4;
%		logLike = gmmEval(data, gmmPrm);
%		prob=exp(logLike);
%		figure; plot(data, prob, '.-');
%		line(data, gmmPrm(1).w*gaussian(data, gmmPrm(1)), 'color', 'r');
%		line(data, gmmPrm(2).w*gaussian(data, gmmPrm(2)), 'color', 'm');
%		line(data, gmmPrm(3).w*gaussian(data, gmmPrm(3)), 'color', 'g');
%		% === The following example plots GMM results of 2-D data:
%		gmmPrm(1).mu = [-3, 3]'; gmmPrm(1).sigma = [5, 2]'; gmmPrm(1).w = 0.3;
%		gmmPrm(2).mu = [3, -3]'; gmmPrm(2).sigma = [4, 1]'; gmmPrm(2).w = 0.3;
%		gmmPrm(3).mu =  [3, 3]'; gmmPrm(3).sigma = [1, 4]'; gmmPrm(3).w = 0.4;
%		bound = 8;
%		pointNum = 51;
%		x = linspace(-bound, bound, pointNum);
%		y = linspace(-bound, bound, pointNum);
%		[xx, yy] = meshgrid(x, y);
%		data = [xx(:), yy(:)]';
%		logLike = gmmEval(data, gmmPrm);
%		zz = reshape(exp(logLike), pointNum, pointNum);
%		subplot(2,2,1);
%		mesh(xx, yy, zz); axis tight; box on
%		subplot(2,2,2);
%		contour(xx, yy, zz, 30); axis image; box on
%
%%	See also gmmTrain.

%	Category: GMM
%	Roger Jang, 20000602, 20080726

if nargin<1, selfdemo; return; end
if nargin<3, chunkSize=10000; end

if isfield(data, 'input'), data=data.input; end;	% data is in the format of dataset
[dim, dataNum]=size(data);
gaussianNum=length(gmmPrm);
log2pi=log(2*pi);
logLike=zeros(1, dataNum);
logGaussianProb=zeros(gaussianNum, dataNum);
covElementNum=numel(gmmPrm(1).sigma);	% No. of cov. elements of an gaussian component

% ====== Partial vectorized version, which operates with a chunk of 10000 entries of data at a time to avoid "out of memory" error.
chunkNum=ceil(dataNum/chunkSize);
if chunkNum==0, chunkNum=1; end		% This happens when chunkSize=inf
logLike=zeros(1, dataNum);

switch covElementNum
	case 1		% cov. mat. = a constant times the identity matrix
		% Fully vectorized version
	%	for i=1:gaussianNum
	%		dataMinusMu = data-repmat(gmmPrm(i).mu, 1, dataNum);
	%		logGaussianProb(i,:) = (-sum(dataMinusMu.*dataMinusMu, 1)/gmmPrm(i).sigma-dim*(log2pi+log(gmmPrm(i).sigma)))/2;
	%	end
		for j=1:chunkNum
			rangeIndex=((j-1)*chunkSize+1):min(j*chunkSize, dataNum);
			rangeLen=length(rangeIndex);
			for i=1:gaussianNum
				dataMinusMu = data(:, rangeIndex)-repmat(gmmPrm(i).mu, 1, rangeLen);
				logGaussianProb(i,rangeIndex) = (-sum(dataMinusMu.*dataMinusMu, 1)/gmmPrm(i).sigma-dim*(log2pi+log(gmmPrm(i).sigma)))/2;
			end
		end
	case dim	% diagonal covariance matrix
		% Fully vectorized version
	%	for i=1:gaussianNum
	%		dataMinusMu = data-repmat(gmmPrm(i).mu, 1, dataNum);
	%		logGaussianProb(i,:) = (-sum(dataMinusMu.*dataMinusMu./repmat(gmmPrm(i).sigma, 1, dataNum), 1)-dim*log2pi-log(prod(gmmPrm(i).sigma)))/2;
	%	end
		for j=1:chunkNum
			rangeIndex=((j-1)*chunkSize+1):min(j*chunkSize, dataNum);
			rangeLen=length(rangeIndex);
			for i=1:gaussianNum
				dataMinusMu = data(:, rangeIndex)-repmat(gmmPrm(i).mu, 1, rangeLen);
				logGaussianProb(i,rangeIndex) = (-sum(dataMinusMu.*dataMinusMu./repmat(gmmPrm(i).sigma, 1, rangeLen), 1)-dim*log2pi-log(prod(gmmPrm(i).sigma)))/2;
			end
		end
	otherwise	% full covariance matrix for each Gaussian
		% Fully vectorized version
	%	for i=1:gaussianNum
	%		dataMinusMu = data-repmat(gmmPrm(i).mu, 1, dataNum);
	%		logGaussianProb(i,:) = (-sum((inv(gmmPrm(i).sigma)'*dataMinusMu).*dataMinusMu, 1)-dim*log2pi-log(det(gmmPrm(i).sigma)))/2;
	%	end
		for j=1:chunkNum
			rangeIndex=((j-1)*chunkSize+1):min(j*chunkSize, dataNum);
			rangeLen=length(rangeIndex);
			for i=1:gaussianNum
				dataMinusMu = data(:, rangeIndex)-repmat(gmmPrm(i).mu, 1, rangeLen);
				logGaussianProb(i,rangeIndex) = (-sum((inv(gmmPrm(i).sigma)'*dataMinusMu).*dataMinusMu, 1)-dim*log2pi-log(det(gmmPrm(i).sigma)))/2;
			end
		end
end

logw=log([gmmPrm.w]');
for i=1:dataNum
	logLike(i)=mixLogSumMex(logw(:)+logGaussianProb(:,i));
end

if nargout>1
	gaussianProb=exp(logGaussianProb);	% This output is necessary for gmmTrain.m!
end

% ====== Self demo
function selfdemo
gmmPrm(1).mu = [-3, 3]'; gmmPrm(1).sigma = [5, 2]'; gmmPrm(1).w = 0.3;
gmmPrm(2).mu = [3, -3]'; gmmPrm(2).sigma = [4, 1]'; gmmPrm(2).w = 0.3;
gmmPrm(3).mu =  [3, 3]'; gmmPrm(3).sigma = [1, 4]'; gmmPrm(3).w = 0.4;
bound = 8;
pointNum = 51;
x = linspace(-bound, bound, pointNum);
y = linspace(-bound, bound, pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:), yy(:)]';
logLike = gmmEval(data, gmmPrm);
zz = reshape(exp(logLike), pointNum, pointNum);
subplot(2,2,1);
mesh(xx, yy, zz); axis tight; box on
subplot(2,2,2);
contour(xx, yy, zz, 30); axis image; box on