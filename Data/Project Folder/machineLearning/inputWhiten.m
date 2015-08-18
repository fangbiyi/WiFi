function [X2, meanVec, A]=inputWhiten(X, plotOpt)
%inputWhiten: Whitening transformation based on eigen decomposition
%
%	Usage:
%		X2=inputWhiten(X)
%		X2=inputWhiten(X, plotOpt)
%		[X2, meanVec, A]=inputWhiten(...)
%
%	Description:
%		[X2, meanVec, A]=inputWhiten(X) takes the input data matrix X (with each column being an observation vector) and returns the whitened data matrix X2 which has a identity covariance matrix, with meanVec being the mean vector of the original data matrix X, and A being the transformation matrix. 
%		For any given data matrix Y to go through the same whitening process, the code is like this:
%		Y2=A*(Y-meanVec*ones(1, size(Y,2)))
%
%	Example:
%		dataNum=1000;
%		X=randn(2,dataNum);
%		meanVec=[20; -10];
%		A=[9, 6; 3, 1];
%		X=A*X+meanVec*ones(1,dataNum);
%		X2=inputWhiten(X, 1);
%
%	Reference:
%		[1] R.O. Duda, P.E. Hart, and D.G. Stork, Pattern Classification,
%			New York: John Wiley & Sons, 2001, pp. 34.

%	Category: Dataset manipulation
%	Roger Jang, 20110214

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0;  end

[dim, dataNum]=size(X);
meanVec=mean(X, 2);
Y=X-meanVec*ones(1, dataNum);
[V, D]=eig(Y*Y'/dataNum);
A=(D^-0.5)*V';
X2=A*Y;

if plotOpt==1 && dim==2
	subplot(1,2,1);
	plot(X(1,:), X(2,:), '.'); axis image; title('Original data');
	title('Original data');
	subplot(1,2,2);
	plot(X2(1,:), X2(2,:), '.'); axis image; title('After whitening');
	title('Whitened data');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
