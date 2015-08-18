%% lcs
% Longest (maximum) common subsequence
%% Syntax
% * 		lcsLength = lcs(a, b)
% * 		lcsLength = lcs(a, b, showPlot)
% * 		[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(...)
%% Description
%
% <html>
% <p>lcsLength = lcs(a, b) returns the LCS (longest common subsequence) between two strings a and b.
% 	<ul>
% 	<li>a: input string 1
% 	<li>b: input string 2
% 	</ul>
% <p>lcsLength = lcs(a, b, 1) plots the path of LCS.
% <p>[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(a, b) returns extra info:
% 	<ul>
% 	<li>lcsPath: optimal path of dynamical programming through the LCS table
% 	<li>lcsStr: LCS string
% 	<li>lcsTable: LCS table for applying dynamic programming
% 	</ul>
% </html>
%% Example
%%
%
str1='elimination';
str2='religious';
showPlot=1;
[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(str1, str2, showPlot);
%% See Also
% <editDistance_help.html editDistance>,
% <dpPathPlot4strMatch_help.html dpPathPlot4strMatch>.
