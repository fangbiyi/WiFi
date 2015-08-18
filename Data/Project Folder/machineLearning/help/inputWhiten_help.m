%% inputWhiten
% Whitening transformation based on eigen decomposition
%% Syntax
% * 		X2=inputWhiten(X)
% * 		X2=inputWhiten(X, plotOpt)
% * 		[X2, meanVec, A]=inputWhiten(...)
%% Description
%
% <html>
% <p>[X2, meanVec, A]=inputWhiten(X) takes the input data matrix X (with each column being an observation vector) and returns the whitened data matrix X2 which has a identity covariance matrix, with meanVec being the mean vector of the original data matrix X, and A being the transformation matrix.
% <p>For any given data matrix Y to go through the same whitening process, the code is like this:
% <p>Y2=A*(Y-meanVec*ones(1, size(Y,2)))
% </html>
%% References
% # 		[1] R.O. Duda, P.E. Hart, and D.G. Stork, Pattern Classification,
% # 			New York: John Wiley & Sons, 2001, pp. 34.
%% Example
%%
%
dataNum=1000;
X=randn(2,dataNum);
meanVec=[20; -10];
A=[9, 6; 3, 1];
X=A*X+meanVec*ones(1,dataNum);
X2=inputWhiten(X, 1);
