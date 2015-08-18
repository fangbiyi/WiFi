function [uniq_row, count] = rowCount(A)
% rowCount: Unique row counts for a given matrix.
%	[uniq_row, count] = rowCount(A)
%	A: input matrix where each row is viewed as an "element"
%	uniq_row: sorted listing of unique row in A
%	count: counts for each returned unique row
%
%	If A is a cell array of strings, then the output uniq_row is also a
%	cell array of strings.
%
%	Roger Jang, 19981125, 20071205

if nargin<1, selfdemo; return, end
if isempty(A), uniq_row=[]; count=[]; return; end

cellstr_input = 0;
if iscellstr(A),
	A = char(A);
	cellstr_input = 1;
end
term = sortrows(A);
tmp1 = term;
tmp1(end+1, :) = tmp1(end, :) + 1;
tmp2 = tmp1(1:end-1, :) - tmp1(2:end, :);
index = find(sum(abs(tmp2), 2) ~= 0);
uniq_row = term(index, :);
count = diff([0; index]);

% Rearrange according to decending order of counts
%[count, index] = sort(count);
%count = flipud(count);
%index = flipud(index);
%uniq_row = uniq_row(index, :);

% Return cell array of string if given cell array of string
if cellstr_input,
	uniq_row = cellstr(uniq_row);
end

% ========== Subfunction ==========
function selfdemo
A = [	'一台';...
	'八爪'; ...
	'三光'; ...
	'人性'; ...
	'八爪'; ...
	'三光'; ...
	'八爪'];
fprintf('Original string matrix:\n');
disp(A);
fprintf('After sorting and finding counts of unique rows:\n');
[uniq_row, count] = feval(mfilename, A);
for i = 1:length(count),
	fprintf('%s ==> %g\n', uniq_row(i, :), count(i));
end
fprintf('Original cell array of strings:\n');
A = {'abc';'acd';'ad';'a';'bc';'ad';'acd';'acd'}; 
disp(A);
[uniq_row, count] = feval(mfilename, A);
fprintf('After sorting and finding counts of unique rows:\n');
for i = 1:length(count),
	fprintf('%s ==> %g\n', uniq_row{i}, count(i));
end
