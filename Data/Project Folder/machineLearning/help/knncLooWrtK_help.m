%% knncLooWrtK
% Try various values of K in leave-one-out KNN classifier.
%% Syntax
% * 		recogRate = knncLooWrtK(DS)
% * 		recogRate = knncLooWrtK(DS, kMax)
% * 		recogRate = knncLooWrtK(DS, kMax, plotOpt)
%% Description
% 		recogRate = knncLooWrtK(DS, kMax, plotOpt) return the LOO (leave-one-out) recognition rates of KNNC w.r.t. various values of k ranging from 1 to kMax.
%% Example
%%
%
DS=prData('iris');
fprintf('Use of KNNCLOO for Iris data:\n');
kMax=20;
plotOpt=1;
knncLooWrtK(DS, kMax, plotOpt);
