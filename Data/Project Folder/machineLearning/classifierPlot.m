function surfObj=classifierPlot(classifier, DS, cPrm, mode)
% qcPlot: Plot the results of a given classifier after training
%
%	Usage:
%		classifierPlot(classifier, DS, cPrm)
%		classifierPlot(classifier, DS, cPrm, mode)
%		surfObj=classifierPlot(classifier, DS, cPrm, ...)
%
%	Description:
%		classifierPlot(classifier, DS, cPrm) plots the training results of a given classifier.
%			classifier: a string specifying a classifier
%				classifier='qc' for quadratic classifier
%				classifier='nbc' for naive Bayes classifier
%				classifier='gmmc' for GMM classifier
%				classifier='linc' for linear classifier
%				classifier='knnc' for k-nearest-neighbor classifier
%			DS: dataset used for training the classifier
%			cPrm: parameters of the classifier
%		classifierPlot(classifier, DS, cPrm, mode) uses a string variable to specify the plot mode
%			mode='1dPdf' for 1D PDF plot (for nbc only)
%			mode='2dPdf' for 2D PDF plot
%			mode='2dPosterior' for 2D posterior probability plot
%			mode='decBoundary' for decision boundary plot
%		surfObj=classifierPlot(classifier, DS, cPrm, ...) return the surface object for plotting instead of plotting directly.
%
%	Example:
%		% === 1-D PDF plot for a naive Bayes classifier:
%		DS=prData('3classes');
%		classifier='nbc';
%		cPrm=classifierTrain(classifier, DS);
%		figure; classifierPlot(classifier, DS, cPrm, '1dPdf');
%		% === 2-D PDF plot for a GMM classifier:
%		DS=prData('3classes');
%		classifier='gmmc';
%		cPrm=classifierTrain(classifier, DS);
%		figure; classifierPlot(classifier, DS, cPrm, '2dPdf');
%		% === 2-D posterior prob. plot for a GMM classifier:
%		DS=prData('3classes');
%		classifier='gmmc';
%		cPrm=classifierTrain(classifier, DS);
%		figure; classifierPlot(classifier, DS, cPrm, '2dPosterior');
%		% === Decision boundary plot for a GMM classifier:
%		DS=prData('3classes');
%		classifier='gmmc';
%		cPrm=classifierTrain(classifier, DS);
%		figure; classifierPlot(classifier, DS, cPrm, 'decBoundary');
%		% === For KNNC
%		classifier='knnc';
%		[trainSet, testSet]=prData('3classes');
%		cPrm=knncTrain(trainSet);
%		cPrm.k=1;
%		% === Plot 2D posterior-like function:
%		figure; classifierPlot(classifier, trainSet, cPrm, '2dPosterior');
%		% === Plot decision boundary:
%		figure; classifierPlot(classifier, trainSet, cPrm, 'decBoundary');

%
%	See also classifierTrain, classifierEval.

%	Category: Classifier plot
%	Roger Jang, 20110506

if nargin<1, selfdemo; return; end
if nargin<2, classifier='qc'; end
if nargin<4, mode='2dPdf'; end

if strcmpi(classifier, 'src')
	fprintf('SRC is not supported in classifierPlot yet.\n');
	return
end

DS=dsNameAdd(DS);	% Put names for plot's labels, etc.
classNum=length(unique(DS.output));
[dim, dataNum]=size(DS.input);
if dim~=2, error('%s is only for 2d dataset!', mfilename); end
pointNum=51;

% ====== For NBC
if strcmpi(classifier, 'nbc') && strcmpi(mode, lower('1dPdf'))
	bound=[min(DS.input, [], 2), max(DS.input, [], 2)];
	for i=1:dim
		xMat(i,:)=linspace(bound(i,1), bound(i,2), pointNum);
	end
	for i=1:classNum
		index=DS.output==i;
		for j=1:dim
			data{i,j}=DS.input(j, index);
			pdf{i,j}=gaussian(xMat(j,:), cPrm.class(i).dim(j));
		end
	end
	for i=1:classNum
		for j=1:dim
			subplot(classNum, dim, (i-1)*dim+j);
			h=plot(xMat(j,:), pdf{i,j});
			set(h, 'color', getColor(i));
			set(gca, 'xlim', bound(j,:));
			axisLimit=axis;
			h=line(data{i,j}, 0.1*(axisLimit(4)-axisLimit(3))*rand(length(data{i,j}),1), 'marker', '.', 'lineStyle', 'none');
			set(h, 'color', getColor(i));
			xlabel(strPurify(sprintf('dim %d (%s)', j, DS.inputName{j})));
			ylabel(strPurify(sprintf('class %d (%s)', i, DS.outputName{j})));
		end
	end
	surfObj=[];
	return
end

% ====== For KNNC
if strcmpi(classifier, 'knnc')
	knncPlot(DS, cPrm, mode)
	return
end

% PDF for each class
x=linspace(min(DS.input(1,:)), max(DS.input(1,:)), pointNum);
y=linspace(min(DS.input(2,:)), max(DS.input(2,:)), pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:), yy(:)]';
classNum=length(cPrm.class);
if strcmp(lower(classifier), 'knnc')
	TS.input=data;
	[computedOutput, logLike]=knncEval(TS, cPrm);
end
for i=1:classNum
	switch(lower(classifier))
		case 'qc'
			out=cPrm.prior(i)*gaussian(data, cPrm.class(i));	% Multiplied by priors
		case 'nbc'
			pdf{i,1}=gaussian(x, cPrm.class(i).dim(1));
			pdf{i,2}=gaussian(y, cPrm.class(i).dim(2));
			out=cPrm.prior(i)*(pdf{i,2}'*pdf{i,1});		% Multiplied by priors
		case 'gmmc'
			out=cPrm.prior(i)*exp(gmmEval(data, cPrm.class(i).gmmPrm));	% Multiplied by priors
		otherwise
			error(sprintf('Unknown classifier: %s'), classifier);
	end
 	surfObj.class(i).surface=reshape(out, pointNum, pointNum);	% Priors are multiplied already.
end
surfObj.xx=xx;
surfObj.yy=yy;

if nargout>0, return; end	% Return surfObj with plotting

clf;
switch(lower(mode))
	case lower('2dPdf')		
		for i=1:classNum
			subplot(2, classNum, i);
			mesh(xx, yy, surfObj.class(i).surface);
			xlabel(strPurify(DS.inputName{1}));
			ylabel(strPurify(DS.inputName{2}));
			% ====== Aspect ratio
			xRange=max(DS.input(1,:))-min(DS.input(1,:));
			yRange=max(DS.input(2,:))-min(DS.input(2,:));
			zRange=max(surfObj.class(i).surface(:))-min(surfObj.class(i).surface(:));
			daspect([1 1 zRange/max(xRange, yRange)]);
			title(['Class-', num2str(i), ' PDF']);
			axis([-inf inf -inf inf -inf inf]);
			% ====== Contour plot
			subplot(2, classNum, classNum+i);
			contourf(xx, yy, surfObj.class(i).surface); axis image
			xlabel(strPurify(DS.inputName{1}));
			ylabel(strPurify(DS.inputName{2}));
			shading flat;
		%	colorbar
			title(['Contours of class-', num2str(i), ' PDF']);
		end
	case lower('2dPosterior')
		sumPdf=sum(cat(3, surfObj.class.surface), 3);
		for i=1:length(surfObj.class)
			surfObj.class(i).posterior=surfObj.class(i).surface./sumPdf;
	 	end
		for i=1:classNum
			subplot(2, classNum, i);
			mesh(xx, yy, surfObj.class(i).posterior);
			xlabel(strPurify(DS.inputName{1}));
			ylabel(strPurify(DS.inputName{2}));
			% ====== Aspect ratio
			xRange=max(DS.input(1,:))-min(DS.input(1,:));
			yRange=max(DS.input(2,:))-min(DS.input(2,:));
			zRange=max(surfObj.class(i).posterior(:))-min(surfObj.class(i).posterior(:));
			daspect([1 1 zRange/max(xRange, yRange)]);
			title(['Class-', num2str(i), ' posterior prob.']);
			axis([-inf inf -inf inf -inf inf]);
			% ====== Contour plot
			subplot(2, classNum, classNum+i);
			contourf(xx, yy, surfObj.class(i).posterior); axis image
			xlabel(strPurify(DS.inputName{1}));
			ylabel(strPurify(DS.inputName{2}));
			shading flat;
		%	colorbar
			title(['Contours of class-', num2str(i), ' posterior prob.']);
		end
	case lower('decBoundary')
		decisionBoundaryPlot(surfObj, DS);
	otherwise
		error('Unknown mode!');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
