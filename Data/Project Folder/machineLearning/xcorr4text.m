function [out, matchedStr] = xcorr4text(a, b, plotOpt)
%xcorr4text: Cross correlation of two text strings
%
%	Usage:
%		out=xcorr4text(a, b)
%		out=xcorr4text(a, b, plotOpt)
%		[out, matchedStr]=xcorr4text(...)
%
%	Description:
%		out=xcorr4text(a, b) returns the cross correlation of strings a and b, which is a vector of length length(a)+length(b)-1.
%		out=xcorr4text(a, b, 1) plots the result for easy visualization.
%
%	Example:
%		a = 'abcde';
%		b = 'xaxabcxabxabcdxabcdexa';
%		[out, matchedStr] = xcorr4text(a, b, 1);

%	Category: String match
%	Roger Jang, 19981227, 20080915

if nargin<1, selfdemo; return, end

a = a(:).';
b = b(:).';
m = length(a);
n = length(b);
A = a(ones(1,n), :).';
B = b(ones(1,m), :);
matched = A==B;
C = [zeros(m,m-1) matched zeros(m,m-1)];
out = zeros(1, n+m-1);
for i = 1:n+m-1,
	out(i) = sum(C((1:m)+((i:i+m-1)-1)*m));
end

if nargout==2
	for i = 1:n+m-1,
		tmp = C((1:m)+((i:i+m-1)-1)*m);
		index = find(tmp==1);
		matchedStr{i} = a(index);
	end
end

if plotOpt
	stem(out);
	set(gca, 'xtick', 1:n+m-1);
	set(gca, 'xticklabel', [b'; 32*ones(m-1,1)]);
	index = find(out);
	for i = 1:length(index),
		text(index(i), out(index(i)), ...
			['matched: ' matchedStr{index(i)} '\rightarrow'], ...
			'horizontal', 'right');
	end
	title_str = sprintf('String A: ''%s'', string B: ''%s''', a, b);
	title(title_str);
	axis([-inf inf -inf max(out)+1]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
