%% confMatGet
% Get confusion matrix from recognition results
%% Syntax
% * 		confMat = confMatGet(desiredOutput, computedOutput)
%% Description
%
% <html>
% <p>confMatGet(desiredOutput, computedOutput) returns the confusion matrix of a given classifier based on
% <p>its desired output (ground truth) and computed output.
% </html>
%% Example
%%
%
desired=[1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5];
computed=[1 5 5 1 1 1 1 1 5 5 1 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 2 5 5 5 5 5 5 5 5 3 5 5 5];
confMat = confMatGet(desired, computed);
confMatPlot(confMat);
%% See Also
% <confMatPlot_help.html confMatPlot>.
