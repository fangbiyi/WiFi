%gmmGrowDemo: Example of using gmmGrow.m for growing a GMM
%
%	Usage:
%		gmmGrowDemo
%
%	Description:
%		gmmGrowDemo demonstrates the use of gmmGrow.m for growing a GMM
%
%	Example:
%		gmmGrowDemo

%	Category: GMM
%	Roger Jang, 20080801

DS = dcData(2);
data=DS.input;
gmmOpt=gmmTrain('defaultOpt');
gmmOpt.config.gaussianNum=1;
gmmOpt.config.covType=3;
gmmOpt.train.useKmeans=1;
gmmOpt.train.showInfo=1;
gmmOpt.train.maxIteration=500;

for i=1:5
	close all;
	[gmmPrm, lp] = gmmTrain(data, gmmOpt);
	gmmOpt.config.gaussianNum=2*gmmOpt.config.gaussianNum;
	gmmPrm = gmmGrow(gmmPrm, gmmOpt.config.gaussianNum);
end

pointNum = 40;
x = linspace(min(data(1,:)), max(data(1,:)), pointNum);
y = linspace(min(data(2,:)), max(data(2,:)), pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:) yy(:)]';
z = gmmEval(data, gmmPrm);
zz = reshape(z, pointNum, pointNum);
figure; mesh(xx, yy, zz); axis tight; box on; rotate3d on
figure; contour(xx, yy, zz, 30); axis image