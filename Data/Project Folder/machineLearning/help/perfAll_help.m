%% perfAll
% Performance evaluation for various combinations of classifiers and input normalization schemes
%% Syntax
% * 		perfData=perfAll(DS, opt)
% * 		perfData=perfAll(DS, opt, plotOpt)
% * 		[perfData, bestClassifierIndex]=perfAll(DS, opt, plotOpt)
% * 		[perfData, bestClassifierIndex, bestClassifier, bestInputFunction]=perfAll(DS, opt, plotOpt)
%% Description
% 		perfData=perfAll(DS, opt) tries out various classifiers combined with various schemes of input normalization to derive the leave-one-out accuracy.
%% Example
%%
%
DS=prData('iris');
opt=perfAll('defaultOpt');
opt.nFold=10;
[perfData, bestId]=perfAll(DS, opt, 1);
structDispInHtml(perfData, 'Performance of various classifiers via cross validation');
% === Display the confusion matrix
confMat=confMatGet(DS.output, perfData(bestId).bestComputedClass);
opt=confMatPlot('defaultOpt');
opt.className=DS.outputName;
figure; confMatPlot(confMat, opt);
%% See Also
% <perfLoo_help.html perfLoo>.
