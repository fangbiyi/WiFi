function [cvData, dispatchMat4index, dispatchMat4output]=cvDataGen(DS, opt, showPlot)
% cvDataGen: Generate m-fold cross validation (CV) data for performance evaluation
%
%	Usage:
%		cvData=cvDataGen(DS)
%		cvData=cvDataGen(DS, opt)
%		cvData=cvDataGen(DS, opt, showPlot)
%		[cvData, dispatchMat4index, dispatchMat4output]=cvDataGen(...)
%
%	Description:
%		[cvData, count]=cvDataGen(DS, m, mode) generates m-fold cross-validation data for performance evaluation.
%			DS: dataset to be partitioned
%			m: number of folds
%			mode: 'index' (index only, default) or 'full' (full data) 
%		The m-fold CV data is generated to satisfy the following two criteria:
%			Each fold has the same number (or as close as possible) of data instances.
%			Each fold has the same (or as close as possible) class distribution.
%		You can examine the class distribution via the matrix count, where count(i,j) is the number of instances of class i within fold j.
%		If the mode is "full", then cvData is a structure array of m elements, with "TS" and "VS" fields for "training set" and "validating set", respectively.
%		If the mode is "index", then both cvData.TS and cvData.VS contain only the indices of the original data for saving memory.
%
%	Example:
%		DS=prData('nonlinearseparable');
%		opt=cvDataGen('defaultOpt');
%		opt.foldNum=2;
%		opt.cvDataType='full';
%		cvData=cvDataGen(DS, opt);
%		subplot(121); dsScatterPlot(cvData(1).TS);
%		subplot(122); dsScatterPlot(cvData(1).VS);

%	Category: Performance evaluation
%	Roger Jang, 20070410, 20110425

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	cvData.foldNum=10;
	cvData.cvDataType='index';
	cvData.randomized=0;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

[dim, dataCount]=size(DS.input);
if isinf(opt.foldNum), opt.foldNum=dataCount; end

if opt.randomized
	index=randperm(count);
	DS.input=DS.input(:, index);
	DS.output=DS.output(:, index);
end

[sortedOutput, index]=sort(DS.output);

width=ceil(dataCount/opt.foldNum);
dispatchMat4index=zeros(opt.foldNum, width);
dispatchMat4index(1:dataCount)=index;
dispatchMat4output=dispatchMat4index;
dispatchMat4output(1:dataCount)=sortedOutput;

for i=1:opt.foldNum
	vIndex=dispatchMat4index(i,:); vIndex(vIndex==0)=[];
	tIndex=dispatchMat4index; tIndex(i,:)=[]; tIndex=tIndex(:)'; tIndex(tIndex==0)=[];
	if strcmp(opt.cvDataType, 'index')
		cvData(i).TS.index=tIndex;
		cvData(i).VS.index=vIndex;
		continue;
	end
	cvData(i).TS.input=DS.input(:, tIndex);
	cvData(i).TS.output=DS.output(:, tIndex);
	cvData(i).TS.inputName=DS.inputName;
	cvData(i).TS.outputName=DS.outputName;
	cvData(i).VS.input=DS.input(:, vIndex);
	cvData(i).VS.output=DS.output(:, vIndex);
	cvData(i).VS.inputName=DS.inputName;
	cvData(i).VS.outputName=DS.outputName;
end

if showPlot & dim==2
	for i=1:opt.foldNum
		subplot(2, opt.foldNum, i);
		dsScatterPlot(cvData(i).TS);
		subplot(2, opt.foldNum, i+opt.foldNum);
		dsScatterPlot(cvData(i).VS);
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
