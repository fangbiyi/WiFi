%% inputSelectExhaustive
% Input selection via exhaustive search
%% Syntax
% * 		bestSelectedInput=inputSelectExhaustive(DS)
% * 		bestSelectedInput=inputSelectExhaustive(DS, inputNum)
% * 		bestSelectedInput=inputSelectExhaustive(DS, inputNum, classifier, param)
% * 		bestSelectedInput=inputSelectExhaustive(DS, inputNum, classifier, param, plotOpt)
% * 		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate, elapsedTime]=inputSelectExhaustive(...)
%% Description
%
% <html>
% <p>[bestSelectedInput, allSelectedInput, allRecogRate, elapsedTime]=inputSelectExhaustive(DS, inputNum, classifier, param, plotOpt) performs input selection via exhaustive search.
% 	<ul>
% 	<li>Input:
% 		<ul>
% 		<li>DS: dataset
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
figure; inputSelectExhaustive(DS);
%%
% SVMC classifier
DS=prData('iris');
figure; inputSelectExhaustive(DS, inf, 'svmc');
