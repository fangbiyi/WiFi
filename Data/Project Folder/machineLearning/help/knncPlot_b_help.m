%% knncPlot_b
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
% 		<li>'distance': for plot of the distance function
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
% Plot 2D distance function:
figure; knncPlot(trainSet, knncPrm, 'distance');
%%
% Plot decision boundary:
figure; knncPlot(trainSet, knncPrm, 'decBoundary');
%% See Also
% <knncTrain_help.html knncTrain>,
% <knncEval_help.html knncEval>.
