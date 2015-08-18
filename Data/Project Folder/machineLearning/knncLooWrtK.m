function recogRate=knncLooWrtK(DS, kMax, plotOpt)
% knncLooWrtK: Try various values of K in leave-one-out KNN classifier.
%
%	Usage:
%		recogRate = knncLooWrtK(DS)
%		recogRate = knncLooWrtK(DS, kMax)
%		recogRate = knncLooWrtK(DS, kMax, plotOpt)
%
%	Description:
%		recogRate = knncLooWrtK(DS, kMax, plotOpt) return the LOO (leave-one-out) recognition rates of KNNC w.r.t. various values of k ranging from 1 to kMax.
%
%	Example:
%		DS=prData('iris');
%		fprintf('Use of KNNCLOO for Iris data:\n');
%		kMax=20;
%		plotOpt=1;
%		knncLooWrtK(DS, kMax, plotOpt);

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19971227, 20080924

if nargin<1, selfdemo; return; end
if nargin<2, kMax=15; end
if nargin<3, plotOpt=0; end

for k=1:kMax
	knncPrm.k=k;
	recogRate(k)=knncLoo(DS, knncPrm);
	fprintf('\t%d-NNR ===> %.2f%%.\n', k, recogRate(k)*100);
end

if plotOpt
	plot(1:kMax, recogRate*100, 'b-o'); grid on;
	title('Recognition rates of the KNN classifier');
	xlabel('K'); ylabel('Recognition rates (%)');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
