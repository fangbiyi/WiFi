function gmmPrm=gmmGrow(gmmPrm, targetGaussianNum)
% gmmGrow: Increase no. of gaussian components within a GMM
%
%	Usage:
%		gmmPrm=gmmGrow(gmmPrm, targetGaussianNum)
%
%	Description:
%		gmmPrm=gmmGrow(gmmPrm, targetGaussianNum) performs center splitting until the target no. of Gaussian components is reached.
%		The target number of Gaussian components should be less than or equal to the original number of Gaussian components.
%
%	Example:
%		gmmGrowDemo
%
%	See also gmmTrain, gmmEval.

%	Category: GMM
%	Roger Jang, 20080727

if nargin<1, selfdemo; return; end

gaussianNum=length(gmmPrm);
if targetGaussianNum>2*gaussianNum
	error('Error: the targetGaussianNum should be less than or equal to twice of the original no. of Gaussian components!');
end

dim=length(gmmPrm(1).mu);
index=randperm(gaussianNum);
for i=1:targetGaussianNum-gaussianNum
	% To clone a gaussian, weight is lowered first
	gmmPrm(index(i)).w=gmmPrm(index(i)).w/2;
	% Start clone
	gmmPrm(end+1)=gmmPrm(index(i));
	% Find sigma to guide the center splitting
	sigma=gmmPrm(end).sigma;
	if length(sigma)==1, sigma=sigma*eye(dim); end
	if numel(sigma)==dim*dim, sigma=diag(sigma); end
	% Center splitting
	gmmPrm(end).mu=gmmPrm(end).mu+randn(dim, 1).*sigma;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
