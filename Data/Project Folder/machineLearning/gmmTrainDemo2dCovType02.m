%gmmTrainDemo2dCovType02: Animation of GMM training with covType=2 (diagonal cov. matrix) for 2D data
%
%	Usage:
%		gmmTrainDemo2dCovType02
%
%	Description:
%		gmmTrainDemo2dCovType02 demonstrates animation of GMM training with
%		covType=2 (diagonal cov. matrix) for 2D data.
%
%	Example:
%		gmmTrainDemo2dCovType02

%	Category: GMM
%	Roger Jang, 20080731

% Data collection
DS = dcData(2);
data=DS.input;

% GMM training
opt=gmmTrain('defaultOpt');
opt.config.gaussianNum=4;
opt.config.covType=2;
opt.train.useKmeans=0;
opt.train.showInfo=1;
opt.train.maxIteration=500;
[gmmPrm, lp] = gmmTrain(data, opt);

% Surface and contour plots
pointNum = 40;
x = linspace(min(data(1,:)), max(data(1,:)), pointNum);
y = linspace(min(data(2,:)), max(data(2,:)), pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:) yy(:)]';
z = gmmEval(data, gmmPrm);
zz = reshape(z, pointNum, pointNum);
figure; mesh(xx, yy, zz); axis tight; box on; rotate3d on
figure; contour(xx, yy, zz, 30); axis image
