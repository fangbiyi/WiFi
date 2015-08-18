%% knncPlot
% Plot the results of KNNC (k-nearest-neighbor classifier) after training
%% Syntax
% * 		knncPlot(DS, knncPrm, mode)
%% Description
%
% <html>
% <p>knncPlot(DS, knncPrm)
% 	<ul>
% 	<li>DS: data set used for training (This is only used to obtain the range of the plot.)
% 	<li>knncPrm: parameters of KNNC obtain from knncTrain
% 	<li>mode: a string that specifies mode of plot
% 		<ul>
% 		<li>'2dPosterior': for plot of the posterior-like function
% 		<li>'decBoundary': for plot of the decision boundary
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
% This example uses the Taiji dataset for classification:
[trainSet, testSet]=prData('3classes');
knncPrm=knncTrain(trainSet);
knncPrm.k=1;
%%
% Plot 2D posterior-like function:
figure; knncPlot(trainSet, knncPrm, '2dPosterior');
%%
% Plot decision boundary:
figure; knncPlot(trainSet, knncPrm, 'decBoundary');
%% See Also
% <knncTrain_help.html knncTrain>,
% <knncEval_help.html knncEval>.
