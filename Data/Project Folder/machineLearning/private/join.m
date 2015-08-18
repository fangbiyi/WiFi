function str = join(cellStr, delimiter)
% join: Join a cell string based on a given delimiter
%	Usage: str = join(cellStr, delimiter)
%
%	See also SPLIT.

%	Roger Jang, 20040408

if nargin==0; selfdemo; return; end
if nargin<2, delimiter=' '; end

if length(cellStr)==0
	str='';
	return
end

if length(cellStr)==1
	str=cellStr{1};
	return
end

str=cellStr{1};
for i=2:length(cellStr)
	str=[str, delimiter, cellStr{i}];
end

% ====== Self demo
function selfdemo
cellStr={'This', 'is', 'a', 'cell', 'string'};
fprintf('cellStr = \n');
disp(cellStr);
str=feval(mfilename, cellStr, '-');
fprintf('After running "str=join(cellStr, ''-'')":\n');
fprintf('str = \n');
disp(str);