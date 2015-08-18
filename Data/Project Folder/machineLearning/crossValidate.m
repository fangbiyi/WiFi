function [tRrMean, vRrMean, tRr, vRr, computedClass]=crossValidate(DS, cvPrm, plotOpt)
% crossValidate: Cross validation for classifier performance evaluation
%
%	Usage:
%		[tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt)
%
%	Description:
%		[tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm) generates a classifier's performance based on m-fold cross validation.
%			DS: dataset
%			cvPrm: The parameters for cross validation
%				cvPrm.foldNum: The number of folds for CV. If this number is larger than the number of data instances in DS, then the leave-one-out method is used for CV.
%				cvPrm.classifier: The classifier used for CV
%				cvPrm.cPrm: The parameters of the classifier cvPrm.classifier. (If this field does not exist, or if the field value is empty, it indicates the use of the default classifier parameters.)
%			tRrMean: Mean value of the training recognition rate
%			vRrMean: Mean value of the validating recognition rate
%			tRr: Training recognition rate for each fold
%			vRr: Validating recognition rate for each fold
%
%	Example:
%		% === 10-fold cross-validation of Iris dataset using GMMC
%		DS=prData('iris');
%		cvPrm.foldNum=10;
%		cvPrm.classifier='gmmc';	% GMM-based classifier
%		plotOpt=1;
%		figure; [tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt);
%		% === Leave-one-out test of Iris dataset using QC
%		DS=prData('iris');
%		cvPrm.foldNum=inf;
%		cvPrm.classifier='qc';	% Quadratic classifier
%		plotOpt=1;
%		figure; [tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt);
%
%	Category: Performance evaluation
%	Roger Jang, 20110427

if nargin<1, selfdemo; return; end
if nargin<2||isempty(cvPrm),
	cvPrm.foldNum=5;
	cvPrm.classifier='qc';
end
if nargin<3, plotOpt=0; end

dataCount=length(DS.output);
if cvPrm.foldNum>dataCount, cvPrm.foldNum=dataCount; end
if ~isfield(cvPrm, 'cPrm'), cvPrm.cPrm=[]; end

cvOpt=cvDataGen('defaultOpt');
cvOpt.foldNum=cvPrm.foldNum;
cvData=cvDataGen(DS, cvOpt);
tRr=zeros(1, cvPrm.foldNum);
vRr=zeros(1, cvPrm.foldNum);
tSize=zeros(1, cvPrm.foldNum);
vSize=zeros(1, cvPrm.foldNum);
chunk=round(cvPrm.foldNum/10);
chunk=1;
for i=1:cvPrm.foldNum
%	myTic=tic;
	if plotOpt && (i==cvPrm.foldNum || mod(i, chunk)==0)
		fprintf('Fold = %d/%d\n', i, cvPrm.foldNum);
	end
	tsIndex=cvData(i).TS.index;
	TS.input=DS.input(:, tsIndex);
	TS.output=DS.output(:, tsIndex);
	vsIndex=cvData(i).VS.index;
	VS.input=DS.input(:, vsIndex);
	VS.output=DS.output(:, vsIndex);
	[classifierPrm, ~, tRr(i)]=feval([cvPrm.classifier, 'Train'], TS, cvPrm.cPrm);
	tSize(i)=length(TS.output);
	computedClass{i}=feval([cvPrm.classifier, 'Eval'], VS, classifierPrm);
	vRr(i)=sum(computedClass{i}==VS.output)/length(computedClass{i});
	vSize(i)=length(VS.output);
%	fprintf('\tTime=%f sec\n', toc(myTic));
end
tRrMean=dot(tRr, tSize)/sum(tSize);
vRrMean=dot(vRr, vSize)/sum(vSize);

if plotOpt
	plot(1:cvPrm.foldNum, tRr, 'o-', 1:cvPrm.foldNum, vRr, 'o-');
	xlabel('Fold index'); ylabel('Recog. rate (%)');
	title(sprintf('classifier=%s, foldNum=%d, training RR=%.2f%%, validating RR=%.2f%%', cvPrm.classifier, cvPrm.foldNum, tRrMean*100, vRrMean*100));
	legend('Training RR', 'Validating RR', 'location', 'northOutside', 'orientation', 'horizontal');
	fprintf('Training RR=%.2f%%, Validating RR=%.2f%%, classifier=%s, no. of folds=%d\n', tRrMean*100, vRrMean*100, cvPrm.classifier, cvPrm.foldNum);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
