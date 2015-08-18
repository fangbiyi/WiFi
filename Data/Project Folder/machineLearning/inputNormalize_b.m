function [data2, mu1, sigma1] = inputNormalize(data, mu, sigma)
% inputNormalize: Input (feature) normalization to have zero mean and unity variance for each feature
%
%	Usage:
%		[data2, mu1, sigma1] = inputNormalize(data)
%		data2 = inputNormalize(data, mu, sigma)
%
%	Description:
%		data2=inputNormalize(data) normalized the given data matrix (with each column being an observation) such that each row of the returned matrix data2 has a zero mean and unity variance.
%		[data2, mu, sigma]=inputNormalize(data) returned the transformed data in data2, as well as the mean and standard deviation of the original data.
%		data2=inputNormalize(data, mu, sigma) use the given mean and standard deviation to normalize the given data.
%
%	Example:
%		dataNum=100;
%		x=8*randn(1, dataNum);
%		y=randn(1, dataNum)+100;
%		data=[x; y];
%		data2=inputNormalize(data);
%		subplot(1,2,1);
%		plot(data(1,:), data(2,:), '.'); axis image
%		title('Original data');
%		subplot(1,2,2);
%		plot(data2(1,:), data2(2,:), '.'); axis image
%		title('Normalized data');

%	Category: Dataset manipulation
%	Roger Jang, 20040925

if nargin<1, selfdemo; return; end

[dim, dataNum] = size(data);

if nargin==1
	mu1 = mean(data, 2);
	sigma1 = sqrt(var(data, 0, 2));
%	if any(sigma1==0)
%		error('Some value in sigma1 is zero!');
%	end
%	data2 = data-mu1*ones(1,dataNum,1);
%	data2 = diag(1./sigma1)*data2;	% Comment out this to avoid memory hog
	for i=1:dim
		data2(i,:)=(data(i,:)-mu1(i))/sigma1(i);
	end
elseif nargin==3
	for i=1:dim
		data2(i,:)=(data(i,:)-mu(i))/sigma(i);
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
