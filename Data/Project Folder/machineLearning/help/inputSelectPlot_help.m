%% inputSelectPlot
% Plot for input selection
%% Syntax
% * 		inputSelectPlot(allRecogRate, allSelectedInput, inputName, callingFunction);
%% Description
% 		inputSelectPlot(allRecogRate, allSelectedInput, inputName, callingFunction) plots the result of input selection
%% Example
%%
%
DS=prData('iris');
[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate]=inputSelectSequential(DS);
inputSelectPlot(allRecogRate*100, allSelectedInput, DS.inputName, 'inputSelectSequential');
