%% perfLoo4audio
% Leave-one-file-out CV (for audio)
%% Syntax
% * 		ds2=perfLoo4audio(ds, opt, showPlot)
%% Description
% 		strCentroid(cellStr) returns the string that has the shortest overall distance to all the other strings based on edit distance. The returned string must be one of the strings in cellStr.
%% Example
%%
%
cellStr={'abcd', 'abde', 'abc', 'asdf', 'abd', 'abcd', 'abd'};
opt=strCentroid('defaultOpt');
output=strCentroid(cellStr, opt);
fprintf('The centroid of %s is %s.\n', cell2str(cellStr), output);
%% See Also
% <editDistance_help.html editDistance>,
% <lcs_help.html lcs>.
