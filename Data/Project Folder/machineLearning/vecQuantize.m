function [center, U, centerHistory] = vecQuantize(data, codeBookSize, showPlot, kmeansFcn)
%vecQuantize: Vector quantization using LBG method of center splitting
%
%	Usage:
%		center=vecQuantize(data, codeBookSize)
%		center=vecQuantize(data, codeBookSize, showPlot)
%		[center, U]=vecQuantize(data, codeBookSize, ...)
%       [center, U, centerHistory]=vecQuantize(data, codeBookSize, ...)
%
%	Description:
%		center=vecQuantize(data, codeBookSize) returns the centers (codebook) of k-means via LBG method, where
%			data: data matrix where each column is an observation
%			codeBookSize: codebook size or number of cluster centers (should be the power of 2)
%			center: codebook matrix where each column is a codeword
%		center=vecQuantize(data, codeBookSize, 1) display the animation and messages during training.
%		[center, U]=vecQuantize(data, codeBookSize, ...) returns extra info of the partition matrix U.
%       [center, U, centerHistory]=vecQuantize(data, codeBookSize, ...) returns extra info of all the centers after each iteration.
%
%	Example:
%		DS=dcData(2);
%		data=DS.input;
%		codeBookSize=2^5;
%		showPlot=1;
%		codebook=vecQuantize(data, codeBookSize, showPlot);
%
%	See also kMeansClustering, vqDataPlot.
%
%	Reference:
%		Y. Linde, A. Buzo, and R.M. Gray, "An Algorithm for Vector Quantizer Design", IEEE Transactions on Communications, vol. 28, pp. 84-94, 1980.

%	Category: Vector quantization
%	Roger Jang, 20030330

if nargin<1, selfdemo; return; end
if nargin<3, showPlot=0; end
if nargin<4, kmeansFcn='kMeansClustering'; end

data=double(data);

% ====== Error checking
[dataDim, dataNum] = size(data);

% Initial Centers: mean of all data
center= mean(data,2);
historyIndex=0;

if showPlot
	plot(data(1,:), data(2,:), 'b.');
	centerH=line(center(1,:), center(2,:), 'color', 'r', 'marker', 'o', 'linestyle', 'none', 'linewidth', 2);
	axis image
end

% Do while-loop to increase center number till it is equal to or greater than codebook size.
maxLoopCount=100;
centerNum=size(center,2);
while (centerNum<codeBookSize)
	if showPlot
	%	fprintf('Hit return to start center splitting...\n'); pause;
		pause(1.0);
	end
	center=[center-1000*eps, center+1000*eps];	% Center splitting
	centerNum=size(center,2);
	[center, U, distortion] = feval(kmeansFcn, data, center, showPlot);	% VQ using K-means function
	historyIndex=historyIndex+1;
	centerHistory{historyIndex}=center;
	fprintf('No. of centers = %g, loop count = %g, distortion = %g\n', centerNum, length(distortion), distortion(end));   
end
if showPlot, vqDataPlot(data, center); end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
