%% dsClassSize
% Data count for each class for a data set
%% Syntax
% * 		classSize=dsClassSize(DS)
% * 		[classSize, classLabel]=dsClassSize(DS)
% * 		[...]=dsClassSize(DS, plotOpt)
%% Description
%
% <html>
% <p>classSize=dsClassSize(DS) returns the size of each class.
% <p>[classSize, classLabel]=dsClassSize(DS) returns the class labels as well.
% <p>[...]=dsClassSize(DS, plotOpt) plot the class sizes as a bar chart.
% </html>
%% Example
%%
%
DS=prData('abalone');
[classSize, classLabel]=dsClassSize(DS, 1);
