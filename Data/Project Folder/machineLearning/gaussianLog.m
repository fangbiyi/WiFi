function out = gaussianLog(data, gPrm, gConst);
% gaussianLog: Multi-dimensional log Gaussian propability density function
%
%	Usage:
%		out = gaussianLog(data, gPrm, gConst)
%
%	Description:
%		out=gaussianLog(data, gPrm) return the log likelihood of given data over Gaussian PDF with parameter gPrm.
%			data: d x n data matrix, representing n data vector of dimension d
%			mu: d x 1 vector
%			sigma: d x d covariance matrix
%				d x 1 vector
%				1 x 1 scalar
%			out: 1 x n vector of log likelihood
%
%	See also gaussian, gaussianMle.
%
%	Example:
%		x = linspace(-10, 10);
%		gPrm.mu = 0;
%		gPrm.sigma = 0.1;
%		y1 = log(gaussian(x, gPrm));
%		y2 = gaussianLog(x, gPrm);
%		difference = abs(y1-y2);
%		subplot(2,1,1); plot(x, y1, x, y2); title('Curves of log(gaussian()) and gaussianLog()');
%		subplot(2,1,2); plot(x, difference); title('Diff. between log(gaussian()) and gaussianLog()');

%	Category: Gaussian PDF
%	Roger Jang, 20050327, 20100616

if nargin<1, selfdemo; return; end
[dim, dataNum]=size(data);

mexFile='gaussianLogMex';
mFile='gaussianLogM';
command=mexFile;
if exist(command)~=3
	command=mFile;
end

if numel(gPrm.sigma)~=1 & numel(gPrm.sigma)~=dim		% Full covariance is not supported in mex files
	out=feval(mFile, data, gPrm);
else
	out=feval(command, data, gPrm);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
