%% knncWrtK
% Try various values of K in KNN classifier
%% Syntax
% * 		recogRate = knncWrtK(testSet, trainSet, kMax, plotOpt)
%% Description
%
% <html>
% <p>recogRate = knncWrtK(testSet, trainSet, kMax, plotOpt) return the
% <p>recognition rates of KNNC w.r.t. various values of k ranging from
% <p>1 to kMax.
% </html>
%% Example
%%
%
[trainSet, testSet]=prData('iris');
designNum=size(trainSet.input, 2);
testNum  =size(testSet.input, 2);
fprintf('Use of KNNC for Iris data:\n');
fprintf('\tSize of design set (odd-indexed data)= %d\n', designNum);
fprintf('\tSize of test set (even-indexed data) = %d\n', testNum);
kMax=15;
plotOpt=1;
knncWrtK(testSet, trainSet, kMax, plotOpt);
