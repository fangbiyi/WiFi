%% inputNormalize_b
% Input (feature) normalization to have zero mean and unity variance for each feature
%% Syntax
% * 		[data2, mu1, sigma1] = inputNormalize(data)
% * 		data2 = inputNormalize(data, mu, sigma)
%% Description
%
% <html>
% <p>data2=inputNormalize(data) normalized the given data matrix (with each column being an observation) such that each row of the returned matrix data2 has a zero mean and unity variance.
% <p>[data2, mu, sigma]=inputNormalize(data) returned the transformed data in data2, as well as the mean and standard deviation of the original data.
% <p>data2=inputNormalize(data, mu, sigma) use the given mean and standard deviation to normalize the given data.
% </html>
%% Example
%%
%
dataNum=100;
x=8*randn(1, dataNum);
y=randn(1, dataNum)+100;
data=[x; y];
data2=inputNormalize(data);
subplot(1,2,1);
plot(data(1,:), data(2,:), '.'); axis image
title('Original data');
subplot(1,2,2);
plot(data2(1,:), data2(2,:), '.'); axis image
title('Normalized data');
