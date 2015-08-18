%% dsScatterPlot
% Scatter plot of the first 2 dimensions of the given dataset
%% Syntax
% * 		dsScatterPlot(DS)
% * 		dsScatterPlot(DS, opt)
%% Description
%
% <html>
% <p>dsScatterPlot(DS) give a 2D scatter plot of the dataset stored in DS.
% 	<ul>
% 	<li>DS: data to be displayed
% 		<ul>
% 		<li>DS.input: input part
% 		<li>DS.output: output part (this part could be missing for DC)
% 		<li>DS.dataName: data name (or description)
% 		<li>DS.inputName: data input name
% 		<li>DS.annotation: annotation for each data point
% 		</ul>
% 	</ul>
% <p>dsScatterPlot(DS, opt) use the info in opt to show annotation or legend.
% 	<ul>
% 	<li>opt.showAnnotation: 1 to show the annotation of a data instance (when the cursor is near the data instance)
% 	<li>opt.showLegend: 1 to show the legend is shown.
% 	</ul>
% </html>
%% Example
%%
%
dataNum=100;
DS.input=2*rand(2, dataNum)-1;
DS.output=1+(DS.input(1,:)+DS.input(2,:)>0);
DS.dataName='Test Data (Click the data point to show its index)';
for i=1:length(DS.output)
	DS.annotation{i}=sprintf('Data point %d\n(%f, %f)', i, DS.input(1,i), DS.input(2,i));
end
dsScatterPlot(DS);
%% See Also
% <dsScatterPlot3_help.html dsScatterPlot3>,
% <dsProjPlot1_help.html dsProjPlot1>,
% <dsProjPlot2_help.html dsProjPlot2>,
% <dsProjPlot3_help.html dsProjPlot3>.
