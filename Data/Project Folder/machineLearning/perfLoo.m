function [recogRate, computedClass]=perfLoo(DS, classifier, classifierOpt, showPlot)
%perfLoo: Leave-one-out accuracy of given dataset and classifier
%
%	Usage:
%		recogRate=perfLoo(DS, classifier, classifierOpt)
%		recogRate=perfLoo(DS, classifier, classifierOpt, showPlot)
%		[recogRate, computedClass]=perfLoo(...)
%
%	Description:
%		recogRate=perfLoo(DS, classifier, classifierOpt) returns the leave-one-out recognition rate of the given dataset and classifier.
%			recogRate: recognition rate
%			DS: Dataset
%				DS.input: Input data (each column is a feature vector)
%				DS.output: Output class (ranging from 1 to N)
%			classifierOpt: Training parameters for the classifier
%		recogRate=perfLoo(DS, classifier, classifierOpt, 1) also plots the dataset and misclasified instances (if the dimension is 2).
%		[recogRate, computedClass]=perfLoo(...) also returns the computed class of each data instance in DS.
%
%	Example:
%		DS=prData('random2');
%		showPlot=1;
%		recogRate=perfLoo(DS, 'qc', [], showPlot);
%
%	See also perfCv4classifier, perfCv.

%	Category: Performance evaluation
%	Roger Jang, 20130513

if nargin<1, selfdemo; return; end
if nargin<2|isempty(classifier), classifier='qc'; end
if nargin<3|isempty(classifierOpt), classifierOpt=feval([classifier, 'Train'], 'defaultOpt'); end
if nargin<4, showPlot=0; end

[dim, dataNum]=size(DS.input);
nearestIndex=zeros(1, dataNum);
computedClass=zeros(1, length(DS.output));
for i=1:dataNum
%	if rem(i, 100)==0, fprintf('%d/%d\n', i, dataNum); end
	tData=DS;
	tData.input(:,i)=[];
	tData.output(:,i)=[];
	vData.input=DS.input(:,i);
	vData.output=DS.output(:,i);
	
	classifierPrm=feval([classifier, 'Train'], tData);
	computedClass(i)=feval([classifier, 'Eval'], vData, classifierPrm);
end
hitIndex = find(DS.output==computedClass);
recogRate = length(hitIndex)/dataNum;

if showPlot & dim==2
	dsScatterPlot(DS);
	axis image; box on
	missIndex=1:dataNum;
	missIndex(hitIndex)=[];
	% display these points
	for i=1:length(missIndex),
		line(DS.input(1,missIndex(i)), DS.input(2,missIndex(i)), 'marker', 'x', 'color', 'k');
	end
	titleString = sprintf('%d leave-one-out error points denoted by "x".', length(missIndex));
	title(titleString);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
