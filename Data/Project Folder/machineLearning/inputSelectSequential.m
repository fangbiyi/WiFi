function [bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime] = inputSelectSequential(DS, inputNum, classifier, param, plotOpt)
% inputSelectSequential: Input selection via sequential forward selection
%
%	Usage:
%		bestSelectedInput=inputSelectSequential(DS)
%		bestSelectedInput=inputSelectSequential(DS, inputNum)
%		bestSelectedInput=inputSelectSequential(DS, inputNum, classifier, param)
%		bestSelectedInput=inputSelectSequential(DS, inputNum, classifier, param, plotOpt)
%		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectSequential(...)
%
%	Description:
%		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectSequential(DS, inputNum, classifier, param, plotOpt) performs input selection via sequential forward selection.
%			Input:
%				DS: design set
%				inputNum: up to inputNum inputs are selected
%				classifier: classifier for input selection
%				param: parameters for classifier
%				plotOpt: 0 for not plotting (default: 1)
%			Output:
%				bestSelectedInput: overall selected input index
%				bestRecogRate: recognition rate based on the final selected input
%				allSelectedInput: all selected input during the process 
%				allRecogRate: all recognition rate 
%				elapseTime: elapsed time
%
%	Example:
%		% === KNNC classifier
%		DS=prData('iris');
%		figure; inputSelectSequential(DS);
%		% === SVMC classifier
%		DS=prData('iris');
%		figure; inputSelectSequential(DS, inf, 'svmc');

%	Category: Input selection
%	Roger Jang, 19971227, 20041102

if nargin<1, selfdemo; return; end
[dim, dataNum]=size(DS.input);
if nargin<2, inputNum=dim; end
if nargin<3, classifier='knnc'; end
if nargin<4, param.k=1; end
if nargin<5, plotOpt=1; end

if inputNum>dim, inputNum=dim; end

if ~isfield(DS, 'inputName')
	feaNum=size(DS.input, 1);
	DS.inputName=cellstr(int2str((1:feaNum)'));
end
inputName=DS.inputName;
modelNum=inputNum*(2*dim-inputNum+1)/2;		% No. of KNN models

% ====== Construct KNN with different input variables
if plotOpt
	fprintf('\nConstruct %d KNN models, each with up to %d inputs selected from %d candidates...\n', modelNum, inputNum, dim);
end
selectedInput=[];
modelIndex=1;
t0=clock;
for i=1:inputNum
	if plotOpt,	fprintf('\nSelecting input %d:\n', i); end
	recogRate = -realmax*ones(1, dim);
	for j=1:dim,
		if isempty(selectedInput) | isempty(find(selectedInput==j))
			currentSelectedInput = [selectedInput, j];
			DS2=DS;
			DS2.input=DS.input(currentSelectedInput, :);
		%	recogRate(j)=feval(classifier, DS2, param);
			recogRate(j)=perfLoo(DS2, classifier, param);
			allRecogRate(modelIndex) = recogRate(j);
			if plotOpt
				fprintf('Model %d/%d: selected={%s} => Recog. rate = %.1f%%\n', modelIndex, modelNum, join(inputName(currentSelectedInput), ', '), recogRate(j)*100);
			end
			allSelectedInput{modelIndex} = currentSelectedInput;
			modelIndex = modelIndex+1;
		end
	end
	[a, b] = max(recogRate);
	selectedInput = [selectedInput, b];
	fprintf('Currently selected inputs: %s\n', join(inputName(selectedInput), ', '));
end

[bestRecogRate, b] = max(allRecogRate);
bestSelectedInput = allSelectedInput{b};
fprintf('\nOverall maximal recognition rate = %.1f%%.\n', bestRecogRate*100);
fprintf('Selected %d inputs (out of %d): %s\n', length(bestSelectedInput), size(DS.input,1), join(inputName(bestSelectedInput), ', '));
elapsedTime=etime(clock, t0);

if plotOpt
	inputSelectPlot(allRecogRate*100, allSelectedInput, inputName, mfilename);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
