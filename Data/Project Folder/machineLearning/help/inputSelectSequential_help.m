%% inputSelectSequential
% Input selection via sequential forward selection
%% Syntax
% * 		bestSelectedInput=inputSelectSequential(DS)
% * 		bestSelectedInput=inputSelectSequential(DS, inputNum)
% * 		bestSelectedInput=inputSelectSequential(DS, inputNum, classifier, param)
% * 		bestSelectedInput=inputSelectSequential(DS, inputNum, classifier, param, plotOpt)
% * 		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectSequential(...)
%% Description
%
% <html>
% <p>[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectSequential(DS, inputNum, classifier, param, plotOpt) performs input selection via sequential forward selection.
% 	<ul>
% 	<li>Input:
% 		<ul>
% 		<li>DS: design set
% 		<li>inputNum: up to inputNum inputs are selected
% 		<li>classifier: classifier for input selection
% 		<li>param: parameters for classifier
% 		<li>plotOpt: 0 for not plotting (default: 1)
% 		</ul>
% 	<li>Output:
% 		<ul>
% 		<li>bestSelectedInput: overall selected input index
% 		<li>bestRecogRate: recognition rate based on the final selected input
% 		<li>allSelectedInput: all selected input during the process
% 		<li>allRecogRate: all recognition rate
% 		<li>elapseTime: elapsed time
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
% KNNC classifier
DS=prData('iris');
figure; inputSelectSequential(DS);
%%
% SVMC classifier
DS=prData('iris');
figure; inputSelectSequential(DS, inf, 'svmc');
