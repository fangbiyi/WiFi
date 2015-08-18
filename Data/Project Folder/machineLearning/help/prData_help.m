%% prData
% Various test datasets for pattern recognition
%% Syntax
% * 		DS=prData(dataName)
% * 		[DS, TS]=prData(dataName)
%% Description
%
% <html>
% <p>DS=prData(dataName) generate different dataset for classification.
% 	<ul>
% 	<li>dataName: 'iris', 'wine', 'abalone', 'taiji', 'random2', 'random6'
% 	</ul>
% </html>
%% Example
%%
%
subplot(2,3,1);
DS=prData('random2'); dsScatterPlot(DS);
subplot(2,3,2);
DS=prData('taiji'); dsScatterPlot(DS);
subplot(2,3,3);
DS=prData('linSeparable'); dsScatterPlot(DS);
subplot(2,3,4);
DS=prData('peaks'); dsScatterPlot(DS);
subplot(2,3,5);
DS=prData('3classes'); dsScatterPlot(DS);
subplot(2,3,6);
DS=prData('nonlinearSeparable'); dsScatterPlot(DS);
%% See Also
% <dcData_help.html dcData>.
