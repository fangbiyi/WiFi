%% lincOptSet
% Set the training options for linear classifiers
%% Syntax
% * 		lincOpt=lincOptSet
% * 		lincOpt=lincOptSet('param1',value1,'param2',value2,...)
%% Description
%
% <html>
% <p>lincOpt=lincOptSet return the default options of a linear perceptron.
% <p>lincOpt=lincOptSet('param1',value1,'param2',value2,...) creates a option structure where the named parameters have the specified values. Any unspecified parameters are given the default values:
% 	<ul>
% 	<li>lincOpt.learningRate=0.01;% Learning rate for the training
% 	<li>lincOpt.maxIter=1000;% Max iteration count
% 	<li>lincOpt.method='batchLearning';% 'batchLearning', 'sequentialLearning', 'minRegressionError'
% 	<li>lincOpt.useMreOnce='no';% Use MRE (minimim regression error) only once
% 	<li>lincOpt.printInterval=200;% Interval for printing messages
% 	<li>lincOpt.animation='no';% Animation
% 	</ul>
% </html>
%% Example
%%
%
lincOpt=lincOptSet('animation', 'yes')
%% See Also
% <lincTrain_help.html lincTrain>,
% <lincEval_help.html lincEval>,
% <lincOptSet_help.html lincOptSet>.
