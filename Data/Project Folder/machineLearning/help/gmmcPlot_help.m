%% gmmcPlot
% Plot the results of GMMC (Gaussian-mixture-model classifier)
%% Syntax
% * 		gmmcPlot(DS, gmmcPrm)
% * 		gmmcPlot(DS, gmmcPrm, mode)
% * 		surfObj=gmmcPlot(DS, qcPrm, ...)
%% Description
%
% <html>
% <p>gmmcPlot(DS, gmmcPrm, mode) plots the results of a GMMC.
% 	<ul>
% 	<li>DS: dataSet for training the GMMC
% 	<li>gmmcPrm: GMMC parameters
% 	</ul>
% <p>gmmcPlot(DS, gmmcPrm, mode) uses an additional string variable to specify the type of plot
% 	<ul>
% 	<li>'2dPdf' for 2D PDF plot
% 	<li>'2dPosterior' for 2D posterior probability plot
% 	<li>'decBoundary' for decision boundary plot
% 	</ul>
% <p>surfObj=gmmcPlot(DS, gmmcPrm, ...) return the surface object for plotting instead of plotting directly.
% </html>
%% Example
%%
% This example uses the Taiji dataset for classification:
DS=prData('random2');
gmmcPrm=gmmcTrain(DS);
%%
% Plot 2D PDF:
figure; gmmcPlot(DS, gmmcPrm, '2dPdf');
%%
% Plot 2D posterior probability:
figure; gmmcPlot(DS, gmmcPrm, '2dPosterior');
%%
% Plot decision boundary:
figure; gmmcPlot(DS, gmmcPrm, 'decBoundary');
%% See Also
% <gmmcTrain_help.html gmmcTrain>,
% <gmmcEval_help.html gmmcEval>.
