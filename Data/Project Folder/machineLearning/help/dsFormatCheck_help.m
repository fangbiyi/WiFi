%% dsFormatCheck
% Check the format of the given dataset
%% Syntax
% * 		status=dsFormatCheck(DS)
% * 		[status, message]=dsFormatCheck(DS)
%% Description
%
% <html>
% <p>dsFormatCheck(DS) checks the format of the given dataset DS. It returns 1 if there is any errors in the format.
% <p>[status, message]=dsFormatCheck(DS) also returns the error message if any.
% </html>
%% Example
%%
%
ds=prData('iris');
ds.output(1)=0;
[status, message]=dsFormatCheck(ds);
if status, fprintf('%s\n', message{1}); end
%% See Also
% <dsScatterPlot_help.html dsScatterPlot>,
% <dsScatterPlot3_help.html dsScatterPlot3>,
% <dsProjPlot1_help.html dsProjPlot1>,
% <dsProjPlot2_help.html dsProjPlot2>,
% <dsProjPlot3_help.html dsProjPlot3>.
