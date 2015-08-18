function lincOpt=lincOptSet(varargin)
%lincOptSet: Set the training options for linear classifiers
%
%	Usage:
%		lincOpt=lincOptSet
%		lincOpt=lincOptSet('param1',value1,'param2',value2,...)
%
%	Description:
%		lincOpt=lincOptSet return the default options of a linear perceptron.
%		lincOpt=lincOptSet('param1',value1,'param2',value2,...) creates a option structure where the named parameters have the specified values. Any unspecified parameters are given the default values:
%			lincOpt.learningRate=0.01;			% Learning rate for the training
%			lincOpt.maxIter=1000;				% Max iteration count
%			lincOpt.method='batchLearning';		% 'batchLearning', 'sequentialLearning', 'minRegressionError'
%			lincOpt.useMreOnce='no';			% Use MRE (minimim regression error) only once
%			lincOpt.printInterval=200;			% Interval for printing messages
%			lincOpt.animation='no';				% Animation
%
%	Example:
%		lincOpt=lincOptSet('animation', 'yes')
%
%	See also lincTrain, lincEval, lincOptSet.

%	Category: Linear classifier
%	Roger Jang, 20110102

% ====== Set default values
lincOpt.learningRate=0.01;
lincOpt.maxIter=1000;
lincOpt.method='batchLearning';		% 'batchLearning', 'sequentialLearning', 'minRegressionError'
lincOpt.useMreOnce='no';
lincOpt.printInterval=200;
lincOpt.animation='no';

arginNum=length(varargin);
%fprintf('arginNum=%d\n', arginNum);
%for i=1:arginNum
%	fprintf('varargin{%d}=%s\n', i, varargin{i});
%end

k=1;
while (k<arginNum)
	field=lower(varargin{k});
	value=lower(varargin{k+1});
%	fprintf('k=%d, field=%s, value=%s\n', k, field, value);
	switch(field)
		case lower('learningRate')
			lincOpt.learningRate=value;
		case lower('maxIter')
			lincOpt.maxIter=value;
		case lower('method')
			lincOpt.method=value;
		case lower('useMreOnce')
			lincOpt.useMreOnce=value;
		case lower('printInterval')
			lincOpt.printInterval=value;
		case lower('animation')
			lincOpt.animation=value;
		otherwise
			error(sprintf('Unknown option: %s', field));
	end
	k=k+2;
end
