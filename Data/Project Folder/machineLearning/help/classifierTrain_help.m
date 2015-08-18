%% classifierTrain
% Training a given classifier
%% Syntax
% * 		cPrm=classifierTrain(classifier, DS, trainPrm)
% * 		cPrm=classifierTrain(classifier, DS, trainPrm, showPlot)
% * 		[cPrm, logLike]=classifierTrain(...)
% * 		[cPrm, logLike, recogRate]=classifierTrain(...)
% * 		[cPrm, logLike, recogRate, hitIndex]=classifierTrain(...)
%% Description
%
% <html>
% <p>cPrm=classifierTrain(classifier, DS, trainPrm) returns the training results of a given classifier.
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
% 	<li>trainPrm: parameters for training
% 		<ul>
% 		<li>trainPrm.prior: a vector of class prior probability (Data count based prior is assume if an empty matrix is given.)
% 		</ul>
% 	<li>cPrm: cPrm.class(i) is the parameters for class i, etc.
% 	</ul>
% <p>cPrm=classifierTrain(classifier, DS, trainPrm, showPlot) also plot the results if showPlot is 1.
% <p>[cPrm, logLike, recogRate, hitIndex]=classifierTrain(...) returns additional output arguments:
% 	<ul>
% 	<li>logLike: log likelihood of each data point
% 	<li>recogRate: recognition rate (if the desired output is given via DS)
% 	<li>hitIndex: vector of indices of correctly classified data points in DS.
% 	</ul>
% </html>
%% Example
%%
%
DS=prData('3classes');
classifier='knnc';
[cPrm, logLike, recogRate, hitIndex]=classifierTrain(classifier, DS);
DS.hitIndex=hitIndex;		% Attach hitIndex to DS for plotting
classifierPlot(classifier, DS, cPrm, 'decBoundary');
%% See Also
% <classifierEval_help.html classifierEval>,
% <classifierPlot_help.html classifierPlot>.
