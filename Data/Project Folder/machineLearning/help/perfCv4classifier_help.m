%% perfCv4classifier
% Performance evaluation for various combinations of classifiers and input normalization schemes
%% Syntax
% * 		perfData=perfCv4classifier(DS, opt)
% * 		perfData=perfCv4classifier(DS, opt, plotOpt)
% * 		[perfData, bestClassifierIndex]=perfCv4classifier(DS, opt, plotOpt)
% * 		[perfData, bestClassifierIndex, bestClassifier, bestInputFunction]=perfCv4classifier(DS, opt, plotOpt)
%% Description
% 		perfData=perfCv4classifier(DS, opt) tries out various classifiers combined with various schemes of input normalization to derive the leave-one-out accuracy.
%% Example
%%
%
DS=prData('iris');
opt=perfCv4classifier('defaultOpt');
opt.foldNum=10;
[perfData, bestId]=perfCv4classifier(DS, opt, 1);
structDispInHtml(perfData, 'Performance of various classifiers via cross validation');
% === Display the confusion matrix
confMat=confMatGet(DS.output, perfData(bestId).bestComputedClass);
opt=confMatPlot('defaultOpt');
opt.className=DS.outputName;
figure; confMatPlot(confMat, opt);
%% See Also
% <perfCv_help.html perfCv>,
% <perfLoo_help.html perfLoo>.
