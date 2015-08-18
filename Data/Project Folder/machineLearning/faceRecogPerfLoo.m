function [looRecogRate, computedClass, correct, time]=faceRecogPerfLoo(DS, opt)
% LOO performance of face recognition using PCA+LDA
%
%	Usage:
%		[recogRate, computedClass, correct, time]=faceRecogPerfLoo(faceData, opt)
%
%	Description:
%		[looRecogRate, computedClass, correct, time]=faceRecogPerfLoo(DS, opt) returns the results of face recognition using PCA + LDA.
%
%	Example:
%		load([mltRoot, '/dataSet/faceData.mat']);
%		DS=faceData2ds(faceData);
%		opt=faceRecogPerfLoo('defaultOpt');
%		[looRecogRate, computedClass, correct, time]=faceRecogPerfLoo(DS, opt);
%		fprintf('Overall recog. rate = %.2f%%\n', looRecogRate*100);
%		fprintf('Total time = %.2f sec\n', sum(time));
%
%	Category: Face recognition
%	Roger Jang, 20110209

if nargin<1, selfdemo; return; end
if ischar(DS) & strcmp(lower(DS), lower('defaultOpt'))
	looRecogRate.pcaDim=60;		% Only use this dimension after PCA
	looRecogRate.ldaDim=12;		% Only use this dimension after LDA
	looRecogRate.method='pca';	% 'pca' or 'pca+lda'
	return
end
if nargin<2
	looRecogRate=feval(mfilename, 'defaultOpt');
end

faceNum=size(DS.input, 2);
computedClass=zeros(1, faceNum);
correct=zeros(1, faceNum);
time=zeros(1, faceNum);
for i=1:faceNum
%	fprintf('\t%d/%d ==> ', i, faceNum);
	tic
	% ====== Process the training data
	if strcmp(opt.method, 'pca') | strcmp(opt.method, 'pca+lda')
		% === Create a big matrix of all faces
		B=DS.input;
		testFace=B(:,i);
		B(:,i)=[];
		meanFace=mean(B, 2);
		B=B-meanFace*ones(1, faceNum-1);
		% === PCA
		[B2, pcaEigVec, pcaEigValue]=pca(B, opt.pcaDim);
		% === Create DS
		DS2=DS;
		DS2.input=B2;
		DS2.output(i)=[];
	end
	if strcmp(opt.method, 'pca+lda')
		% === LDA
		[DS3, ldaEigVec]=lda(DS2, opt.ldaDim);
	end
	% ====== Process the test data
	if strcmp(opt.method, 'pca')
		DS3=DS2;
		TS.input=pcaEigVec'*(testFace-meanFace);
		TS.input=TS.input(1:opt.pcaDim);
	elseif strcmp(opt.method, 'pca+lda')
		temp=pcaEigVec'*(testFace-meanFace);
		TS.input=ldaEigVec'*temp;
		TS.input=TS.input(1:opt.ldaDim);
	end
	TS.output=DS.output(i);
	% ====== Do recognition
	computedClass(i)=knncEval(TS, DS3);
	correct(i)=computedClass(i)==TS.output;
	time(i)=toc;
%	fprintf('%d (%.2f sec)\n', correct(i), time(i));
end
looRecogRate=sum(correct)/length(correct);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
