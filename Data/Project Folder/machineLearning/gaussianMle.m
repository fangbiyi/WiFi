function gPrm = gaussianMle(data, plotOpt)
% mleGaussian: MLE (maximum likelihood estimator) for Gaussian PDF
%
%	Usage:
%		gPrm = mleGaussian(data)
%		gPrm = gaussianMle(data, plotOpt)
%
%	Description:
%		gPrm = gaussianMle(data) returns the optimum parameters for Gaussian PDF via MLE
%			data: data matrix where each column corresponds to a vector
%			gPrm: Parameters for Gaussian PDF
%				gPrm.mu: MLE of the mean
%				gPrm.sigma: MLE of the variance
%
%	Example:
%		% === 1D example
%		dataNum=1000;
%		x = randn(dataNum, 1);
%		plotOpt=1;
%		subplot(2,1,1);
%		gPrm=gaussianMle(x, plotOpt);
%		title('1D Gaussian PDF identified by MLE');
%		% === 2D example
%		DS=dcData(7);
%		gPrm=gaussianMle(DS.input);
%		xMax=max(abs(DS.input(1,:)));
%		yMax=max(abs(DS.input(1,:)));
%		pointNum = 101;
%		x = linspace(-xMax, xMax, pointNum);
%		y = linspace(-yMax, yMax, pointNum);
%		[xx, yy] = meshgrid(x, y);
%		data = [xx(:), yy(:)]';
%		out = gaussian(data, gPrm);
%		zz = reshape(out, pointNum, pointNum);
%		subplot(2,2,3);
%		contour(xx, yy, zz, 15);
%		for i=1:size(DS.input,2)
%			line(DS.input(1,i), DS.input(2,i), 'color', 'k', 'marker', '.');
%		end
%		axis image; title('Scattered data and contours of PDF');
%		subplot(2,2,4);
%		mesh(xx, yy, zz);
%		axis([-inf inf -inf inf -inf inf]);
%		set(gca, 'box', 'on');
%		title('2D Gaussian PDF identified by MLE');

%	Category: Gaussian PDF
%	Roger Jang, 20000428, 20080726

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

if size(data, 2)==1, data=data'; end
[dim, dataNum] = size(data);
if dataNum<=dim
	warning('Warning in %s: dataNum (%d) <= dim (%d), the resulting parameters are not trustworthy!\n', mfilename, dataNum, dim);
end

gPrm.mu = mean(data, 2);
gPrm.sigma = (data*data'-dataNum*gPrm.mu*gPrm.mu')/(dataNum-1);

if plotOpt
	if dim==1
		binNum = 20;
		[N, X] = hist(data, binNum);
		maxX=max(data);
		minX=min(data);
		rangeX=maxX-minX;
		k = dataNum*rangeX/binNum;
		bar(X, N/k, 1);
		xi = linspace(minX-rangeX/2, maxX+rangeX/2);
		yi = gaussian(xi, gPrm);
		hold on
		h = plot(xi, yi);
		hold off
		set(h, 'linewidth', 2, 'color', 'r');
		title('Gaussian PDF');
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
