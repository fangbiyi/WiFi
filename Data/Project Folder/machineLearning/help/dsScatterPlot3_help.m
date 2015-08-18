%% dsScatterPlot3
% Scatter plot of the first 3 dimensions of the given dataset
%% Syntax
% * 		dsScatterPlot3(DS)
%% Description
%
% <html>
% <p>dsScatterPlot3(DS) give a 3D scatter plot of the dataset stored in DS.
% 	<ul>
% 	<li>DS: data to be displayed
% 		<ul>
% 		<li>DS.input: input part
% 		<li>DS.output: output part (this part could be missing for DC)
% 		<li>DS.dataName: data name (or description)
% 		<li>DS.inputName: data input name
% 		<li>DS.annotation: data annotation for each data point
% 		</ul>
% 	</ul>
% <p>You can click and drag the mouse to change the viewing angle.
% </html>
%% Example
%%
%
DS=prData('random3');
dsScatterPlot3(DS);
%% See Also
% <dsScatterPlot_help.html dsScatterPlot>,
% <dsProjPlot1_help.html dsProjPlot1>,
% <dsProjPlot2_help.html dsProjPlot2>,
% <dsProjPlot3_help.html dsProjPlot3>.
