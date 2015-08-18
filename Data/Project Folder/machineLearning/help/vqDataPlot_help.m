%% vqDataPlot
% Plot the data and the result of vector quantization
%% Syntax
% * 		vqDataPlot(data, center)
%% Description
%
% <html>
% <p>vqDataPlot(data, center) plots the scatter data during vector quantization.
% <p>This function is primarily used in kMeansClustering.m and vecQuantize.m.
% </html>
%% Example
%%
%
DS=dcData(2);
data=DS.input;
center=data(:, [10 3 9 2]);
vqDataPlot(data, center);
%% See Also
% <kMeansClustering_help.html kMeansClustering>,
% <vecQuantize_help.html vecQuantize>.
