function [recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(DS, opt, plotOpt)
% ldaPerfViaKnncLoo: LDA recognition rate via KNNC and LOO performance index
%
%	Usage:
%		recogRate=ldaPerfViaKnncLoo(DS)
%		recogRate=ldaPerfViaKnncLoo(DS, opt)
%		recogRate=ldaPerfViaKnncLoo(DS, opt, plotOpt)
%		[recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(...);
%
%	Description:
%		recogRate=ldaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using LDA (linear discriminant analysis)
%			DS: the dataset
%		recogRate=ldaPerfViaKnncLoo(DS, opt) uses LDA with the option opt:
%			opt.maxDim: Use this value as the max. dimensions after LDA projection
%			opt.mode:
%				'approximate' (default) for approximate evaluation which uses all dataset for LDA project
%				'exact' for true leave-one-out test, which takes longer
%		The default value of option can be obtained by ldaPerfViaKnncLoo('defaultOpt').
%		recogRate=ldaPerfViaKnncLoo(DS, opt, 1) plots the recognition rates w.r.t. dimensions after LDA transformation.
%
%	Example:
%		% === Using LDA over WINE dataset
%		DS=prData('wine');
%		opt=ldaPerfViaKnncLoo('defaultOpt');
%		opt.mode='approximate';
%		recogRate1=ldaPerfViaKnncLoo(DS, opt, 1);
%		% === Compare two mode of LDA performance evaluation via KNNC-LOO
%		DS=prData('wine');
%		opt=ldaPerfViaKnncLoo('defaultOpt');
%		opt.mode='approximate';
%		tic; recogRate1=ldaPerfViaKnncLoo(DS, opt); time1=toc;
%		opt.mode='exact';
%		tic; recogRate2=ldaPerfViaKnncLoo(DS, opt); time2=toc;
%		plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
%		xlabel('No. of projected features based on LDA');
%		ylabel('LOO recognition rates using KNNC (%)');
%		legend('mode=''approximate''', 'mode=''exact''', 'location', 'southwest');
%		fprintf('time1=%g sec, time2=%g sec\n', time1, time2);
%		% === Effect of input normalization of LDA over WINE dataset 
%		DS=prData('wine');
%		recogRate1=ldaPerfViaKnncLoo(DS, opt);
%		DS.input=inputNormalize(DS.input);
%		recogRate2=ldaPerfViaKnncLoo(DS);
%		plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
%		xlabel('No. of projected features based on LDA');
%		ylabel('LOO recognition rates using KNNC (%)');
%		legend('Without input normalization', 'With input normalization', 'location', 'southwest');
%
%	See also lda.

%	Category: Data dimension reduction
%	Roger Jang, 20060507, 20111021

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	recogRate.maxDim=inf;
	recogRate.mode='approximate';
	return
end
[featureNum, dataNum] = size(DS.input);
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end

if isempty(opt.maxDim), opt.maxDim=featureNum; end
if isnan(opt.maxDim), opt.maxDim=featureNum; end
maxDim=min(opt.maxDim, featureNum);

computedClass=zeros(dataNum, maxDim);	% Computed class
switch(lower(opt.mode))
	case 'approximate'
		DS2 = lda(DS);
		recogRate=zeros(1, maxDim);
		for i=1:maxDim
			DS3=DS2; DS3.input=DS2.input(1:i, :);
			[recogRate(i), computed] = knncLoo(DS3);
			hitCount=sum(DS.output==computed);
			computedClass(:,i)=computed(:);
			if plotOpt
				fprintf('\t\tLOO recog. rate of KNNC using %d dim = %d/%d = %g%%\n', i, hitCount, dataNum, 100*recogRate(i));
			end
		end
	case 'exact'
		hitMat=zeros(dataNum, maxDim);		% 1 indicates a hit
		for i=1:dataNum
			DS2=DS;
			testDS.input=DS2.input(:,i);
			testDS.output=DS2.output(:,i);
			DS2.input(:,i)=[];
			DS2.output(:,i)=[];
			[DS3, ldaVec]=lda(DS2);
			for j=1:maxDim
				DS4=DS3; DS4.input=DS4.input(1:j,:);
				testDS2=testDS;
				testDS2.input=ldaVec(:,1:j)'*testDS2.input;
				computedClass(i,j)=knncEval(testDS2, DS4);
			%	hitMat(i,j)=computedClass(i,j)==testDS2.output;
			end
			hitMat(i,:)=computedClass(i,:)==testDS2.output(:);
		end
		recogRate=mean(hitMat);
	otherwise
		error('Unknown mode!');
end
[maxRR, bestFeaNum]=max(recogRate);

if plotOpt
	plot(1:maxDim, 100*recogRate, '.-'); grid on
	line(bestFeaNum, 100*maxRR, 'color', 'r', 'marker', 'o');
	titleStr=sprintf('Max RR = %f%% when dim = %d', maxRR*100, bestFeaNum);
	title(titleStr);
	xlabel('No. of projected features based on LDA');
	ylabel('LOO recognition rates using KNNC (%)');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
