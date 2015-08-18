function recogRate=pcaPerfViaKnncLoo(DS, maxDim, plotOpt)
% pcaPerfViaKnncLoo: PCA analysis using KNNC and LOO
%
%	Usage:
%		recogRate=pcaPerfViaKnncLoo(DS)
%		recogRate=pcaPerfViaKnncLoo(DS, [], plotOpt)
%		recogRate=pcaPerfViaKnncLoo(DS, maxDim, plotOpt)
%
%	Description:
%		recogRate=pcaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using PCA (principal component analysis)
%
%	Example:
%		% === PCA over WINE dataset
%		DS=prData('wine');
%		recogRate1=pcaPerfViaKnncLoo(DS, [], 1);
%		% === Effect of input normalization of PCA over WINE dataset 
%		DS=prData('wine');
%		recogRate1=pcaPerfViaKnncLoo(DS);
%		DS.input=inputNormalize(DS.input);
%		recogRate2=pcaPerfViaKnncLoo(DS);
%		plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
%		xlabel('No. of projected features based on PCA');
%		ylabel('LOO recognition rates using KNNC (%)');
%		legend('Without input normalization', 'With input normalization', 'location', 'southwest');

%	Category: Data dimension reduction
%	Roger Jang, 20060507

if nargin<1, selfdemo; return; end
[featureNum, dataNum] = size(DS.input);
if nargin<2, maxDim=featureNum; end
if nargin<3, plotOpt=0; end

if isempty(maxDim), maxDim=featureNum; end
if isnan(maxDim), maxDim=featureNum; end
maxDim=min(maxDim, featureNum);

DS2 = pca(DS);
recogRate=[];
for i = 1:maxDim
	DS3=DS2; DS3.input=DS2.input(1:i, :);
	[recogRate(i), computed]=knncLoo(DS3);
	hitCount=sum(computed==DS3.output);
	if plotOpt
		fprintf('\t\tLOO recog. rate of KNNC using %d dim = %d/%d = %g%%\n', i, hitCount, dataNum, 100*recogRate(i));
	end
end

if plotOpt
	plot(1:maxDim, 100*recogRate, '.-'); grid on
	xlabel('No. of projected features based on PCA');
	ylabel('LOO recognition rates using KNNC (%)');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
