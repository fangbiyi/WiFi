function [vRrOverall, tRrOverall, vRr, tRr, computedClass]=perfCv(DS, classifier, classifierOpt, foldNum, showPlot)
%perfCv: Cross-validation accuracy of given dataset and classifier
%
%	Usage:
%		vRr=perfCv(DS, classifier, classifierOpt)
%		vRr=perfCv(DS, classifier, classifierOpt, showPlot)
%		[vRrOverall, tRrOverall, vRr, tRr, computedClass]=perfCv(...)
%
%	Description:
%		vRr=perfCv(DS, classifier, classifierOpt) returns the cross-validation recognition rate of the given dataset and classifier.
%			vRr: validating recognition rate
%			DS: Dataset
%				DS.input: Input data (each column is a feature vector)
%				DS.output: Output class (ranging from 1 to N)
%			classifierOpt: Training parameters for the classifier
%		vRr=perfCv(DS, classifier, classifierOpt, 1) also plots the dataset and misclasified instances (if the dimension is 2).
%		[vRrOverall, tRrOverall, vRr, tRr, computedClass]=perfCv(...) returns more info about cross-validation:
%			vRrOverall: Overall validating RR
%			tRrOverall: Overall training RR
%			vRr: Validating RR for all folds
%			tRr: Training RR for all folds
%			computedClass: The computed class of each data instance in DS
%
%	Example:
%		DS=prData('iris');
%		showPlot=1;
%		foldNum=10;
%		classifier='qc';
%		vRr=perfCv(DS, classifier, [], foldNum, showPlot);
%
%	See also perfCv4classifier, perfLoo.

%	Category: Performance evaluation
%	Roger Jang, 20130513

if nargin<1, selfdemo; return; end
if nargin<2|isempty(classifier), classifier='qc'; end
if nargin<3|isempty(classifierOpt), classifierOpt=feval([classifier, 'Train'], 'defaultOpt'); end
if nargin<4, foldNum=10; end
if nargin<5, showPlot=0; end

[dim, dataNum]=size(DS.input);
nearestIndex=zeros(1, dataNum);
computedClass=zeros(1, length(DS.output));
cvOpt=cvDataGen('defaultOpt');
cvOpt.foldNum=foldNum;
cvData=cvDataGen(DS, cvOpt);

for i=1:length(cvData)
%	fprintf('%d/%d\n', i, length(cvData));
	tData.input= DS.input(:,  cvData(i).TS.index);
	tData.output=DS.output(:, cvData(i).TS.index);
	vData.input= DS.input(:,  cvData(i).VS.index);
	vData.output=DS.output(:, cvData(i).VS.index);
	[classifierPrm, logProb1, tRr(i)]=feval([classifier, 'Train'], tData, classifierOpt);
	tSize(i)=length(tData.output);
	[cClass, logProb2, vRr(i)]=feval([classifier, 'Eval'], vData, classifierPrm);
	vSize(i)=length(vData.output);
	computedClass(cvData(i).VS.index)=cClass;
end
hitIndex = find(DS.output==computedClass);
recogRate = length(hitIndex)/dataNum;
tRrOverall=dot(tRr, tSize)/sum(tSize);
vRrOverall=dot(vRr, vSize)/sum(vSize);

if showPlot
	plot(1:length(tRr), tRr, '.-', 1:length(vRr), vRr, '.-');
	xlabel('Fold indices'); ylabel('Recog. rate (%)');
	legend('Training RR', 'Validating RR', 'location', 'northOutside', 'orientation', 'horizontal');
%	fprintf('Training RR=%.2f%%, Validating RR=%.2f%%\n', tRrOverall*100, vRrOverall*100);
end

if showPlot & dim==2
	figure; dsScatterPlot(DS);
	axis image; box on
	missIndex=1:dataNum;
	missIndex(hitIndex)=[];
	% display these points
	for i=1:length(missIndex),
		line(DS.input(1,missIndex(i)), DS.input(2,missIndex(i)), 'marker', 'x', 'color', 'k');
	end
	titleString = sprintf('%d CV error points denoted by "x".', length(missIndex));
	title(titleString);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
