%% strCentroid
% Return the centroid of a set of strings
%% Syntax
% * 		outStr=strCentroid(cellStr, opt)
%% Description
% 		strCentroid(cellStr) returns the string that has the shortest overall distance to all the other strings based on edit distance. The returned string must be one of the strings in cellStr.
%% Example
%%
%
cellStr={'abcd', 'abde', 'abc', 'asdf', 'abd', 'abcd', 'abd'};
opt=strCentroid('defaultOpt');
outStr=strCentroid(cellStr, opt);
fprintf('The centroid of %s is %s.\n', cell2str(cellStr), outStr);
%% See Also
% <editDistance_help.html editDistance>,
% <lcs_help.html lcs>.
