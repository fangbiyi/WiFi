%% classFuzzify
% Initialize fuzzy membership grades for a dataset
%% Syntax
% * 		fuzzyClass = classFuzzify(DS, k)
%% Description
%
% <html>
% <p>fuzzyClass = classFuzzify(DS, k) returns the fuzzy membership grades of each sample data point:
% 	<ul>
% 	<li>DS: dataset
% 	<li>k: the no. of nearest neighbors used for computing the membership grades.
% 	</ul>
% </html>
%% References
% # 		J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy K-Nearest Neighbor Algorithm", IEEE Transactions on Systems, Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585, 1985.
%% Example
%%
%
DS=prData('3classes');
dsScatterPlot(DS);
line([0 1], [0 1], 'linestyle', ':');		% Plot boundary
line([0.5 1], [0.5 0], 'linestyle', ':');	% Plot boundary
k=5;
fuzzyClass = classFuzzify(DS, k);
index=find(sum(fuzzyClass.^0.5)~=1);
line(DS.input(1,index), DS.input(2,index), 'linestyle', 'none', 'marker', 'o', 'color', 'k');
title('Circled data points have fuzzy membership grades.');
%% See Also
% <knncFuzzy_help.html knncFuzzy>.
