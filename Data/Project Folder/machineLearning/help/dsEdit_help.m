%% dsEdit
% Data editing
%% Syntax
% * 		DS2=dsEdit(DS)
% * 		DS2=dsEdit(DS, iterCount)
% * 		DS2=dsEdit(DS, iterCount, plotOpt)
%% Description
%
% <html>
% <p>DS2=dsEdit(DS) returns the reduced dataset using data editing.
% <p>DS2=dsEdit(DS, iterCount) uses the given iteration count for data editing
% <p>DS2=dsEdit(DS, iterCount, plotOpt) plots the results of data editing (if the dimensions of the dataset is 2)
% </html>
%% Example
%%
%
DS=prData('peaks');
iterCount=inf;
plotOpt=1;
DS2=dsEdit(DS, iterCount, plotOpt);
%% See Also
% <dsCondense_help.html dsCondense>.
