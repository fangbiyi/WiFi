function out=distLpNorm(vec, p)
%distLpNorm: Lp norm of a vector
%
%	Usage:
%		out=distLpNorm(vec, p)
%
%	Description:
%		out=distLpNorm(x, p) returns the Lp norm of a given vector x.
%			x: a column vector or a matrix
%			p: a parameter between 0 and infinity
%		If x is a matrix, then Lp norm is applied to each column vector.
%
%	Example:
%		vec=[3; 4];
%		fprintf('distLpNorm([3; 4], 1) = %f\n', distLpNorm(vec, 1));
%		fprintf('distLpNorm([3; 4], 2) = %f\n', distLpNorm(vec, 2));
%		fprintf('distLpNorm([3; 4], inf) = %f\n', distLpNorm(vec, inf));

%	Category: Distance and similarity
%	Roger Jang, 20100730

if nargin<1, selfdemo; return; end
if nargin<2, p=2; end

if p<=0, error('p must be greater than zero!'); end
if isinf(p), out=max(abs(vec), [], 1); return ;end

temp=sum(abs(vec).^p, 1);
out=temp.^(1/p);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
