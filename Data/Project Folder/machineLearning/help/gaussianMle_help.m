%% gaussianMle
% MLE (maximum likelihood estimator) for Gaussian PDF
%% Syntax
% * 		gPrm = mleGaussian(data)
% * 		gPrm = gaussianMle(data, plotOpt)
%% Description
%
% <html>
% <p>gPrm = gaussianMle(data) returns the optimum parameters for Gaussian PDF via MLE
% 	<ul>
% 	<li>data: data matrix where each column corresponds to a vector
% 	<li>gPrm: Parameters for Gaussian PDF
% 		<ul>
% 		<li>gPrm.mu: MLE of the mean
% 		<li>gPrm.sigma: MLE of the variance
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
% 1D example
dataNum=1000;
x = randn(dataNum, 1);
plotOpt=1;
subplot(2,1,1);
gPrm=gaussianMle(x, plotOpt);
title('1D Gaussian PDF identified by MLE');
%%
% 2D example
DS=dcData(7);
gPrm=gaussianMle(DS.input);
xMax=max(abs(DS.input(1,:)));
yMax=max(abs(DS.input(1,:)));
pointNum = 101;
x = linspace(-xMax, xMax, pointNum);
y = linspace(-yMax, yMax, pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:), yy(:)]';
out = gaussian(data, gPrm);
zz = reshape(out, pointNum, pointNum);
subplot(2,2,3);
contour(xx, yy, zz, 15);
for i=1:size(DS.input,2)
	line(DS.input(1,i), DS.input(2,i), 'color', 'k', 'marker', '.');
end
axis image; title('Scattered data and contours of PDF');
subplot(2,2,4);
mesh(xx, yy, zz);
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
title('2D Gaussian PDF identified by MLE');
