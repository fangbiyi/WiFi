%% xcorr4text
% Cross correlation of two text strings
%% Syntax
% * 		out=xcorr4text(a, b)
% * 		out=xcorr4text(a, b, plotOpt)
% * 		[out, matchedStr]=xcorr4text(...)
%% Description
%
% <html>
% <p>out=xcorr4text(a, b) returns the cross correlation of strings a and b, which is a vector of length length(a)+length(b)-1.
% <p>out=xcorr4text(a, b, 1) plots the result for easy visualization.
% </html>
%% Example
%%
%
a = 'abcde';
b = 'xaxabcxabxabcdxabcdexa';
[out, matchedStr] = xcorr4text(a, b, 1);
