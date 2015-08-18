%% confMatPlot
% Display the confusion matrix
%% Syntax
% * 		confMatPlot(confMat)
% * 		confMatPlot(confMat, opt)
%% Description
%
% <html>
% <p>confMatPlot(confMat) plots the confusion matrix of classification result.
% <p>confMatPlot(confMat, opt) labels the class names along the confusion matrix.
% 	<ul>
% 	<li>opt: Options for this function
% 		<ul>
% 		<li>opt.mode: different mode of plotting
% 			<ul>
% 			<li>'dataCount': displays data counts
% 			<li>'percentage': displays percentages
% 			<li>'both': displays both data counts and percentages
% 			</ul>
% 		<li>opt.className: Class names for plotting
% 		<li>opt.matPlotOpt: Options that are passed to "matPlot".
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
desired=[1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5];
computed=[1 5 5 1 1 1 1 1 5 5 1 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 2 5 5 5 5 5 5 5 5 3 5 5 5];
confMat = confMatGet(desired, computed);
opt=confMatPlot('defaultOpt');
opt.className={'Canada', 'China', 'Japan', 'Taiwan', 'US'};
% === Example 1: Data count plot
opt.mode='dataCount';
figure; confMatPlot(confMat, opt);
% === Example 2: Percentage plot
opt.mode='percentage';
opt.format='8.2f';
figure; confMatPlot(confMat, opt);
% === Example 3: Plot of both data count and percentage
opt.mode='both';
figure; confMatPlot(confMat, opt);
%% See Also
% <confMatGet_help.html confMatGet>.
