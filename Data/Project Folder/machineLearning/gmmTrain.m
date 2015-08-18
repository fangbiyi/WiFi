function [gmmModel, logLike] = gmmTrain(data, opt, showPlot)
% gmmTrain: GMM training for parameter identification
%
%	Usage:
%		gmmModel = gmmTrain(data, gmmOpt)
%		gmmModel = gmmTrain(data, gmmOpt, showPlot)
%		[gmmModel, logLike] = gmmTrain(...)
%		gmmOpt = gmmTrain('defaultOpt');
%
%	Description:
%		gmmModel = gmmTrain(data, opt) performs GMM training and returns the parameters in gmmModel. I/O arguments are as follows:
%			data: dim x dataNum matrix where each column is a data point
%			opt: gmm options for configuration and training
%				opt.config.gaussianNum: No. of Gaussians
%				opt.config.covType: Type of covariance matrix
%				opt.train.showInfo: Displaying info during training
%				opt.train.useKmeans: Use k-means to find initial centers
%				opt.train.maxIteration: Max. number of iterations
%				opt.train.minImprove: Min. improvement over the previous iteration
%				opt.train.minVariance: Min. variance for each mixture
%				opt.train.usePartialVectorization specifies the use of vectorized operations, as follows:
%					0 for fully vectorized operation
%					1 (default) for partial vectorized operation (which is slower but uses less memory)
%			gmmModel: The final model for GMM
%		[gmmModel, logLike] = gmmTrain(data, opt) also returns the log likelihood during the training process.
%		For demos, please refer to
%			1-d example: gmmTrainDemo1d.
%			2-d example: gmmTrainDemo2dCovType01.m, gmmTrainDemo2dCovType02.m, and gmmTrainDemo2dCovType03.
%		Note that opt.config determines the configuraton of GMM, which is then used to determine the initial GMM parameters by gmmInitPrmSet.m. In fact, opt.config could be a valid GMM parameters that specify the GMM configuration directly. On the other hand, opt.train determines the parameters for training.
%
%	Example:
%		DS=dcData(2);
%		trainingData=DS.input;
%		opt=gmmTrain('defaultOpt');
%		opt.config.gaussianNum=8;
%		opt.config.covType=1;
%		opt.train.useKmeans=0;
%		opt.train.showInfo=1;
%		opt.train.maxIteration=50;
%		[gmmModel, logLike]=gmmTrain(trainingData, opt, 1);
%
%	See also gmmEval, gmmPlot, gmmInitPrmSet.

%	Category: GMM
%	Roger Jang 20000610, 20080726

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(data) && strcmpi(data, 'defaultOpt')
	% === Configuration options
	gmmModel.config.gaussianNum=2;
	gmmModel.config.covType=2;
	% === Training options for gmmTrain()
	gmmModel.train.showInfo=0;		% Display info during training
	%gmmTrainOpt.plotOpt=0;			% Display rr with respect to mix numbers
	gmmModel.train.useKmeans=1;		% Use kmeans to find the initial centers
	gmmModel.train.maxIteration=100;	% Max. iteration
	gmmModel.train.minImprove=eps;		% Min. improvement
	gmmModel.train.minVariance=eps;		% Min. variance
	gmmModel.train.usePartialVectorization=1;
	% Optins for gmmcGaussianNumEstimate()
	gmmModel.train.useCenterSplitting=0;	% Use center splitting (Only if the no. of gaussians increases by the power of 2.)
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if isfield(opt.config, 'gaussianNum')
	gaussianNum = opt.config.gaussianNum;
	covType = opt.config.covType;
else	% opt.config is in fact the gmmModel.
	gmmModel = opt.config;
	gaussianNum = length(gmmModel);
end

if isfield(data, 'input'), data=data.input; end;	% data is in the format of dataset

% ======= Error checking
[dim, dataNum] = size(data);
if (dataNum<=gaussianNum)
	error(sprintf('The given data size is less than the Gaussian number!\n', dataNum, gaussianNum));
end
range=max(data, [], 2)-min(data, [], 2);
if any(range==0)
	error('Warning in %s: Some of dimensions has the same data. Perhaps you should remove data of those dimensions first.\n', mfilename);
elseif max(range)/min(range)>10000
	fprintf('Warning in %s: max(range)/min(range)=%g>10000 ===> Perhaps you should normalize the data first.\n', mfilename, max(range)/min(range));
end
if any(isnan(data(:))) | any(isinf(data(:)))
	error('Some element is nan or inf in the given data!');
end

% ====== Set initial parameters
if isfield(opt.config, 'gaussianNum')
	gmmModel=gmmInitPrmSet(data, opt);
end

% ====== Start EM iteration
logLike = zeros(opt.train.maxIteration, 1);   % Array for objective function
if opt.train.showInfo & dim==2, gmmDisplay(data, gmmModel); end

for i=1:opt.train.maxIteration
	% ====== Expectation step:
	% P(i,j) is the probability of data(:,j) to the i-th Gaussian
	[logLikes, P]=gmmEval(data, gmmModel);
%	[logLikes, P]=gmmEvalMex(data, M, V, W);
	logLike(i)=sum(logLikes);
	if opt.train.showInfo, fprintf('\tGMM iteration: %d/%d, log likelihood. = %f\n', i-1, opt.train.maxIteration, logLike(i)); end
	W=[gmmModel.w]';
	PW=repmat(W, 1, dataNum).*P;
	sumPW=sum(PW, 1);
	if any(sumPW==0)
		warning('Warning in %s: Some entries of sumPW==0! You need to make sure each point is at least covered by a Gaussian!', mfilename);
		sumPW(sumPW==0)=eps;
	end
	BETA=PW./repmat(sumPW, gaussianNum, 1);		% BETA(i,j) is beta_i(x_j)
	sumBETA=sum(BETA,2);
	
	% ====== Maximization step:  eqns (2.96) to (2.98) from Bishop p.67:
	% === Compute mu
	M = (data*BETA')./repmat(sumBETA', dim, 1);
	% Distribute the parameters to gmmModel
	meanCell=mat2cell(M, dim, ones(1, gaussianNum));
	[gmmModel.mu]=deal(meanCell{:});
	% === Compute w
	W = (1/dataNum)*sumBETA;					% (2.98)
	wCell=mat2cell(W', 1, ones(1, gaussianNum));
	[gmmModel.w]=deal(wCell{:});
	% === Compute sigma
	DISTSQ = distSqrPairwise(M, data);						% Distance of M to data
	if numel(gmmModel(1).sigma)==1	% identity covariance matrix times a constant for each Gaussian
		V = max((sum(BETA.*DISTSQ, 2)./sumBETA)/dim, opt.train.minVariance);	% (2.97)
		for j=1:gaussianNum
			gmmModel(j).sigma=V(j);
		end
	elseif numel(gmmModel(1).sigma)==dim	% diagonal covariance matrix for each Gaussian
		% This segment remains to be double checked
		if ~opt.train.usePartialVectorization	% Fully vectorized version
			for j=1:gaussianNum
				dataMinusMu = data-repmat(gmmModel(j).mu, 1, dataNum);
				weight = repmat(BETA(j,:), dim, 1);
				gmmModel(j).sigma=sum((weight.*dataMinusMu).*dataMinusMu, 2)/sum(BETA(j,:));
				gmmModel(j).sigma=max(gmmModel(j).sigma, opt.train.minVariance);
			end
		else				% Partially vectorized version, which process each row sequentially
			for j=1:gaussianNum
				for k=1:dim	% Process each row
					dataMinusMu=data(k,:)-gmmModel(j).mu(k);
					gmmModel(j).sigma(k)=sum(BETA(j,:).*dataMinusMu.*dataMinusMu)/sum(BETA(j,:));
				end
				gmmModel(j).sigma=max(gmmModel(j).sigma, opt.train.minVariance);
			end
		end
	else	% full covariance matrix for each Gaussian
		for j=1:gaussianNum
			dataMinusMu = data-repmat(gmmModel(j).mu, 1, dataNum);
			weight = repmat(BETA(j,:), dim, 1);
			gmmModel(j).sigma=(weight.*dataMinusMu)*dataMinusMu'/sum(BETA(j,:));
			gmmModel(j).sigma=max(gmmModel(j).sigma, opt.train.minVariance);
		end
	end
	% === Animation
	if opt.train.showInfo & dim==2, gmmDisplay(data, gmmModel); end
	
	% ====== Check stopping criterion
	if i>1, if logLike(i)-logLike(i-1)<opt.train.minImprove, break; end; end
end
[logLikes, P]=gmmEval(data, gmmModel);
logLike(i)=sum(logLikes);

if opt.train.showInfo, fprintf('\tGMM total iteration count = %d, log likelihood. = %f\n',i, logLike(i)); end
logLike(i+1:opt.train.maxIteration) = [];

if showPlot
	if opt.train.showInfo & dim==2; figure; end
	plot(logLike, '.-'); xlabel('Iteration index'); ylabel('Log likelihood');
end

% ====== Subfunctions ======
function gmmDisplay(data, gmmModel)
% Display function for EM algorithm
figureH=findobj(0, 'tag', mfilename);
if isempty(figureH)
	figureH=figure;
	set(figureH, 'tag', mfilename);
	plot(data(1,:), data(2,:),'.r'); axis image
	for i=1:length(gmmModel)
		[xData, yData]=halfHeightContour(gmmModel(i));
		circleH(i)=line(xData, yData, 'color', 'k', 'linewidth', 3);
	end
	set(circleH, 'tag', 'circleH', 'erasemode', 'xor');
else
	circleH=findobj(figureH, 'tag', 'circleH');
	for i=1:length(gmmModel)
		[xData, yData]=halfHeightContour(gmmModel(i));
		set(circleH(i), 'xdata', xData, 'ydata', yData);
	end
	drawnow
end

% ====== Obtain the contour data at half height of an Gaussian
function [xData, yData]=halfHeightContour(gPrm)
dim=length(gPrm.mu);
theta=linspace(-pi, pi, 21);
if numel(gPrm.sigma)==1	% identity covariance matrix times a constant for each Gaussian
	r=sqrt(2*log(2)*gPrm.sigma);	% Gaussian reaches it's 50% height at this distance from the mean
	xData=r*cos(theta)+gPrm.mu(1);
	yData=r*sin(theta)+gPrm.mu(2);
elseif numel(gPrm.sigma)==dim	% diagonal covariance matrix for each Gaussian
	r1=sqrt(2*log(2)*gPrm.sigma(1));
	r2=sqrt(2*log(2)*gPrm.sigma(2));
	xData=r1*cos(theta)+gPrm.mu(1);
	yData=r2*sin(theta)+gPrm.mu(2);
else	% full covariance matrix for each Gaussian
	[V, D]=eig(gPrm.sigma);
	r1=sqrt(2*log(2)*D(1,1));
	r2=sqrt(2*log(2)*D(2,2));
	rotatedData=[r1*cos(theta); r2*sin(theta)];
	origData=V*rotatedData;
	xData=origData(1,:)+gPrm.mu(1);
	yData=origData(2,:)+gPrm.mu(2);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
