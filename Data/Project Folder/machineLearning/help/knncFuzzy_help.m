%% knncFuzzy
% Fuzzy k-nearest neighbor classifier
%% Syntax
% * 		testOut = knncFuzzy(testSet, trainSet, prm)
%% Description
% 		testOut = knncFuzzy(testSet, trainSet, prm) returns the result of fuzzy KNN classifier, using the given training set trainSet and test set testSet.
%% References
% # 		[1] J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy
% # 			K-Nearest Neighbor Algorithm", IEEE Transactions on Systems,
% # 			Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585, 1985.
%% Example
%%
%
[trainSet, testSet]=prData('3classes');
dsScatterPlot(trainSet);		% Plot the training set
line([0 1], [0 1], 'linestyle', ':');		% Plot boundary
line([0.5 1], [0.5 0], 'linestyle', ':');	% Plot boundary
prm.k=5;
prm.m=2;
[fuzzyOutput, crispOutput]=knncFuzzy(testSet, trainSet, prm);
dsScatterPlot(testSet);		% Overlay the test set
for i=1:3
	index=find(crispOutput==i);
	line(testSet.input(1, index), testSet.input(2, index), 'marker', 'o', 'color', getColor(i), 'linestyle', 'none');
end
title('Training set (dots) and test set (circles with color indicting the test results)');
fprintf('Recog. rate = %.2f%%\n', 100*sum(crispOutput==testSet.output)/length(testSet.output));
%% See Also
% <classFuzzify_help.html classFuzzify>.
