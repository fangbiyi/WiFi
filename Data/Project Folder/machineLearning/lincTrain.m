function [coef, recogRate, allCoef, allRecogRate]=lincTrain(DS, trainPrm)
%lincTrain: Linear classifier (Perceptron) training 
%
%	Usage:
%		[recogRate, coef, allRecogRate, allCoef] = lincTrain(DS, trainPrm)
%
%	Description:
%		[recogRate, coef] = lincTrain(DS) trains a linear classifier based on the given dataset DS.
%
%	Example:
%		DS=prData('linSeparable');
%		trainPrm=lincOptSet('animation', 'yes');
%		coef=lincTrain(DS, trainPrm);
%
%	See also lincTrain, lincEval, lincOptSet.

%	Category: Linear classifier
%	Roger Jang, 20040910, 20101231

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	coef=lincOptSet;
	return
end
if nargin<2||isempty(trainPrm), trainPrm=feval(mfilename, 'defaultOpt'); end

[dim, dataNum]=size(DS.input);
uniqueOutput=unique(DS.output);
if length(uniqueOutput)~=2, error('lincTrain is only for 2-class problems!'); end

if strcmp(lower(trainPrm.method), lower('batchLearning'))
	if strcmp(trainPrm.animation, 'yes') & dim==2,
		dsScatterPlot(DS);
		axis image
		limit=axis;
		lineH = line(limit(1:2), limit(3:4), 'linewidth', 2, 'erase', 'xor', 'color', 'k');
	end

	allRecogRate=-ones(1, trainPrm.maxIter);
	allCoef=cell(1, trainPrm.maxIter);

	if strcmp(trainPrm.useMreOnce, 'yes')
		tempPrm=lincOptSet('method', 'minRegressionError');
		[coef, allRecogRate(1)]=lincTrain(DS, tempPrm);	% Initial parameters via mrecTrain
	else
		coef=randn(dim+1,1);				% Initial parameters via random number
	end

	% The main loop
	for i=1:trainPrm.maxIter
		computed = lincEval(DS, coef);
		allCoef{i}=coef;
		allRecogRate(i)=sum(DS.output==computed)/dataNum;
		if mod(i, trainPrm.printInterval)==0
			fprintf('Iteration=%d/%d, recog. rate=%g%%\n', i, trainPrm.maxIter, allRecogRate(i)*100);
		end
		% === Vectorized version, suitable for small data set
	%	coef=coef+trainPrm.learningRate*sum([DS.input; ones(1,dataNum)]*diag(DS.output-computed), 2);
		% === For-loop version, suitable for big data set
		grad=0*coef;
		for j=1:dataNum
			grad=grad+(computed(j)-DS.output(j))*[DS.input(:,j); 1];
		end
		gradLength=norm(grad);
		if gradLength==0, break; end
		coef=coef-trainPrm.learningRate*grad/norm(grad);		% Normalized version of steepest descent
		if strcmp(trainPrm.animation, 'yes') & dim==2,
			set(lineH, 'ydata', (-coef(3)+1.5-coef(1)*limit(1:2))/coef(2));
			drawnow
		end
		% ====== Update step size
		if i>=5
			if all(diff(allRecogRate(i-4:i))>0)
				trainPrm.learningRate = 1.1*trainPrm.learningRate;
			%	fprintf('\tIncrease trainPrm.learningRate to %f\n', trainPrm.learningRate);
			end
			if all(sign(diff(allRecogRate(i-4:i)))==[-1 1 -1 1]) | all(sign(diff(allRecogRate(i-4:i)))==[1 -1 1 -1])
				trainPrm.learningRate = 0.9*trainPrm.learningRate;
			%	fprintf('\tDecrease trainPrm.learningRate to %f\n', trainPrm.learningRate);
			end
		end
	end

	index=find(allRecogRate<0);
	allRecogRate(index)=[];
	allCoef(index)=[];

	[recogRate, index]=max(allRecogRate);
	coef=allCoef{index};

%	if strcmp(trainPrm.animation, 'yes')
%		figure
%		plot(1:length(allRecogRate), allRecogRate*100, 1:length(allRecogRate), allRecogRate*100, '.');
%		xlabel('No. of iteration');
%		ylabel('Recognition rate (%)');
%		grid on
%		line(index, allRecogRate(index)*100, 'marker', 'o', 'color', 'r');
%		fprintf('Max. recog. rate = %.2f at %d iteration.\n', allRecogRate(index)*100, index);
%	end
elseif strcmp(lower(trainPrm.method), lower('sequentialLearning'))
	if strcmp(trainPrm.animation, 'yes') & dim==2,
		dsScatterPlot(DS);
		axis image
		limit=axis;
		lineH = line(limit(1:2), limit(3:4), 'linewidth', 2, 'erase', 'xor', 'color', 'k');
		r = 0.03;
		theta = linspace(0, 2*pi);
		circleX = r*cos(theta); 
		circleY = r*sin(theta); 
		circleH = line(nan, nan, 'color', 'k', 'erase', 'xor');
	end

	% The main loop
	coef=randn(dim+1,1);
	for i=1:trainPrm.maxIter
		picked = ceil(rand*dataNum);
		input = DS.input(:, picked);
		target = DS.output(:, picked);
		computed = 1+(dot(coef, [input; 1])>1.5);
		coef=coef+trainPrm.learningRate*(target-computed)*[input; 1];
		if strcmp(trainPrm.animation, 'yes') & dim==2,
			set(circleH, 'xdata', circleX+DS.input(1, picked), 'ydata', circleY+DS.input(2, picked));
			set(lineH, 'ydata', (-coef(3)+1.5-coef(1)*limit(1:2))/coef(2));
			drawnow
		end
		if mod(i, trainPrm.printInterval)==0
			fprintf('Iteration=%d/%d\n', i, trainPrm.maxIter);
		end
	end
elseif strcmp(lower(trainPrm.method), lower('minRegressionError'))
	% ====== Preapre A matrix for A*x=desired
	A=[DS.input', ones(dataNum,1)];
	coef=A\DS.output';
end

[lincOutput, recogRate, errorIndex1, errorIndex2, regOutput, regError]=lincEval(DS, coef);
	
if strcmp(trainPrm.animation, 'yes') & dim==2
	clf
	dsScatterPlot(DS); axis image
	xMin=min(DS.input(1,:));
	xMax=max(DS.input(1,:));
	yMin=min(DS.input(2,:));
	yMax=max(DS.input(2,:));
	a=coef(1); b=coef(2); c=coef(3)-1.5;
	x1=xMin;
	y1=(-c-a*x1)/b;
	x2=xMax;
	y2=(-c-a*x2)/b;
	line([x1, x2], [y1, y2], 'color', 'k', 'linewidth', 2);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
