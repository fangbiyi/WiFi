function [bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime] = inputSelectExhaustive(DS, inputNum, classifier, param, plotOpt)
% inputSelectExhaustive: Input selection via exhaustive search
%	Usage:
%		bestSelectedInput=inputSelectExhaustive(DS)
%		bestSelectedInput=inputSelectExhaustive(DS, inputNum)
%		bestSelectedInput=inputSelectExhaustive(DS, inputNum, classifier, param)
%		bestSelectedInput=inputSelectExhaustive(DS, inputNum, classifier, param, plotOpt)
%		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectExhaustive(...)
%
%	Description:
%		[bestSelectedInput, allSelectedInput, allRecogRate, elapsedTime]=inputSelectExhaustive(DS, inputNum, classifier, param, plotOpt) performs input selection via exhaustive search.
%			Input:
%				DS: dataset
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
%		figure; inputSelectExhaustive(DS);
%		% === SVMC classifier
%		DS=prData('iris');
%		figure; inputSelectExhaustive(DS, inf, 'svmc');

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

t0=clock;
% Construct all input indices for possible models
allSelectedInput={};
for i=1:inputNum
	x=combine(1:dim, i);
	thisInputIndex=mat2cell(x, ones(1,size(x,1)), size(x,2));
	allSelectedInput={allSelectedInput{:}, thisInputIndex{:}};
end

modelNum=length(allSelectedInput);
if plotOpt, fprintf('\nConstruct %d KNN models, each with up to %d inputs selected from %d candidates...\n', modelNum, inputNum, dim); end
for i=1:modelNum
	DS2=DS;
	DS2.input=DS.input(allSelectedInput{i}, :);
%	allRecogRate(i) = feval(classifier, DS2, param);
	allRecogRate(i)=perfLoo(DS2, classifier, param);
    	if plotOpt
    		fprintf('modelIndex %d/%d: selected={%s} => Recog. rate = %f%%\n', i, modelNum, join(inputName(allSelectedInput{i}), ', '), allRecogRate(i)*100);
    	end
end

[bestRecogRate, b] = max(allRecogRate);
bestSelectedInput = allSelectedInput{b};
fprintf('\nOverall max recognition rate = %.1f%%.\n', bestRecogRate*100);
fprintf('Selected %d inputs (out of %d): %s\n', length(bestSelectedInput), size(DS.input,1), join(inputName(bestSelectedInput), ', '));
elapsedTime=etime(clock, t0);

if plotOpt
	inputSelectPlot(allRecogRate*100, allSelectedInput, inputName, mfilename);
end

% ====== Subfunction
function out = combine(obj, n)
%	out = combine(obj, n) returns combinations of obj with n distinct
%	elements.
%	For instance: combine([1 2 3 4 5], 2) or combine('abcde', 3).

%	Roger Jang, Sept-21-1996

if n>length(obj)
	out=[];
	return;
end
if n==1
	out = obj(:);
	return;
end
if n==length(obj)
	out = obj(:)';
	return;
end

out = [];
for i = 1:length(obj)-1,
	first = obj(i);
	tail = obj(i+1:end);
	tail_combinat = combine(tail, n-1);
	loop_out = [first*ones(size(tail_combinat,1), 1), tail_combinat]; 
	out = [out; loop_out];
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);