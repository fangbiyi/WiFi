%% classifierEval
% Evaluation of a given classifier
%% Syntax
% * 		computedClass=classifierEval(classifier, DS, cPrm)
% * 		computedClass=classifierEval(classifier, DS, cPrm, plotOpt)
% * 		[computedClass, logLike]=classifierEval(...)
% * 		[computedClass, logLike, recogRate]=classifierEval(...)
%% Description
%
% <html>
% <p>computedClass=classifierEval(classifier, DS, cPrm) returns the computed class of the dataset DS on a given classifier.
% 	<ul>
% 	<li>classifier: a string specifying a classifier
% 		<ul>
% 		<li>classifier='qc' for quadratic classifier
% 		<li>classifier='nbc' for naive Bayes classifier
% 		<li>classifier='gmmc' for GMM classifier
% 		<li>classifier='knnc' for k-nearest-neighbor classifier
% 		<li>classifier='linc' for linear classifier
% 		<li>classifier='src' for sparse-representation classifier
% 		</ul>
% 	<li>DS: data set for training
% 	<li>cPrm: parameters for the classifier, where cPrm.class(i) is the parameters for class i.
% 	<li>computedClass: a vector of computed classes for data instances in DS
% 	</ul>
% <p>computedClass=classifierEval(classifier, DS, cPrm, plotOpt) also plots the decision boundary if the dimension is 2.
% <p>[computedClass, logLike, recogRate]=classifierEval(...) returnsmore info, including the log likelihood of each data instance, and the recognition rate (if the DS has the info of desired classes).
% </html>
%% Example
%%
%
DS=prData('3classes');
plotOpt=1;
classifier='qc';
[cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS);
DS.hitIndex=hitIndex;		% Attach hitIndex to DS for plotting
classifierPlot(classifier, DS, cPrm, 'decBoundary');
