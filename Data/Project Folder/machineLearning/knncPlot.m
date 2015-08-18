function knncPlot(DS, knncPrm, mode)
% knncPlot: Plot the results of KNNC (k-nearest-neighbor classifier) after training
%
%	Usage:
%		knncPlot(DS, knncPrm, mode)
%
%	Description:
%		knncPlot(DS, knncPrm)
%			DS: data set used for training (This is only used to obtain the range of the plot.)
%			knncPrm: parameters of KNNC obtain from knncTrain
%			mode: a string that specifies mode of plot
%				'2dPosterior': for plot of the posterior-like function
%				'decBoundary': for plot of the decision boundary
%
%	Example:
%		% === This example uses the Taiji dataset for classification:
%		[trainSet, testSet]=prData('3classes');
%		knncPrm=knncTrain(trainSet);
%		knncPrm.k=1;
%		% === Plot 2D posterior-like function:
%		figure; knncPlot(trainSet, knncPrm, '2dPosterior');
%		% === Plot decision boundary:
%		figure; knncPlot(trainSet, knncPrm, 'decBoundary');
%
%	See also knncTrain, knncEval.

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 20110428

if nargin<1; selfdemo; return; end
if nargin<3, mode='decBoundary'; end

DS=dsNameAdd(DS);	% Put names for plot's labels, etc.
classNum=length(unique(DS.output));
[dim, dataNum]=size(DS.input);
if dim~=2, error('%s is only for 2D dataset!', mfilename); end

% ======= Create knncPrm from DS if knncPrm is empty
singlePlot=0;
if isempty(knncPrm)||strcmp(knncPrm.trainMethod, 'none')
	singlePlot=1;
	for i=1:classNum
		index=find(DS.output==i);
		knncPrm.class(i).data=DS.input(:, index);
	end
	knncPrm.k=1;
end

% Posterior-like function for each class
pointNum=51;
x=linspace(min(DS.input(1,:)), max(DS.input(1,:)), pointNum);
y=linspace(min(DS.input(2,:)), max(DS.input(2,:)), pointNum);
[xx, yy] = meshgrid(x, y);
data = [xx(:), yy(:)]';
TS.input=data;
uniqueOutput=unique(DS.output);
classNum=length(uniqueOutput);
[computedOutput, logLike]=knncEval(TS, knncPrm);
for i=1:classNum
	out=logLike(i,:);
	surfObj.class(i).surface = reshape(out, pointNum, pointNum);
end
surfObj.xx=xx;
surfObj.yy=yy;

if nargout>0, return; end	% Return surfObj with plotting

prmSet.input=[];
prmSet.output=[];
for i=1:classNum
%	fprintf('i=%d\n', i);
	prmSet.input=[prmSet.input, knncPrm.class(i).data];
	prmSet.output=[prmSet.output, i*ones(1, size(knncPrm.class(i).data, 2))];
end

clf;
switch(lower(mode))
	case lower('2dPosterior')
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
			title(['Class-', num2str(i), ' posterior']);
			axis([-inf inf -inf inf -inf inf]);
			% ====== Contour plot
			subplot(2, classNum, classNum+i);
			contourf(xx, yy, surfObj.class(i).surface); axis image
			xlabel(strPurify(DS.inputName{1}));
			ylabel(strPurify(DS.inputName{2}));
			shading flat;
		%	colorbar
			title(['Contours of class-', num2str(i), ' posterior']);
		end
	case lower('decBoundary')
		if singlePlot
			decisionBoundaryPlot(surfObj, prmSet, 'max');
			title('Dataset and decision boundary');
		else
			subplot(1,2,1);
			[patchH, pointH]=decisionBoundaryPlot(surfObj, prmSet, 'max');
			set(pointH, 'markerSize', 30);	% Make the prototypes bigger!
			% Plotting the training data
			classNum=length(unique(DS.output));
			for i=1:classNum
				index=find(DS.output==i);
				if isempty(index)
					error('No data found for class=%d', i);
				end
				xData=DS.input(1, index);
				yData=DS.input(2, index);
				pointH(i)=line(xData, yData, 'marker', '.', 'lineStyle', 'none', 'color', getColor(i));
			end
			title('Prototypes and decision boundary');
			subplot(1,2,2);
			decisionBoundaryPlot(surfObj, DS, 'max');
			title('Test data');
			if isfield(DS, 'hitIndex')
				title(strPurify(sprintf('Test data, RR=%.2f%%', 100*length(DS.hitIndex)/length(DS.output))));
			end
		end
	otherwise
		error('Unknown mode!');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
