%% qcPlot
% Plot the results of QC (quadratic classifier)
%% Syntax
% * 		qcPlot(DS, qcPrm)
% * 		qcPlot(DS, qcPrm, mode)
% * 		surfObj=qcPlot(DS, qcPrm, ...)
%% Description
%
% <html>
% <p>qcPlot(DS, qcPrm) plot the results of QC (quadratic classifier)
% 	<ul>
% 	<li>DS: data set used for training
% 	<li>qcPrm: parameters of QC obtain from qcTrain
% 	</ul>
% <p>qcPlot(DS, qcPrm, mode) uses an additional string variable to specify the type of plot
% 	<ul>
% 	<li>mode='2dPdf' for 2D PDF plot
% 	<li>mode='2dPosterior' for 2D posterior probability plot
% 	<li>mode='decBoundary' for plot of the decision boundary
% 	</ul>
% <p>surfObj=qcPlot(DS, qcPrm, ...) return the surface object for plotting instead of plotting directly.
% </html>
%% Example
%%
% This example uses features 3 and 4 of IRIS dataset for classification:
DS=prData('iris');				% Load iris dataset
DS.input=DS.input(3:4, :);			% Use only features 3 and 4
qcPrm=qcTrain(DS);				% Do QC training
%%
% Plot 2D PDF:
figure; qcPlot(DS, qcPrm, '2dPdf');
%%
% Plot 2D posterior probability:
figure; qcPlot(DS, qcPrm, '2dPosterior');
%%
% Plot decision boundary:
figure; qcPlot(DS, qcPrm, 'decBoundary');
%% See Also
% <qcTrain_help.html qcTrain>,
% <qcEval_help.html qcEval>.
