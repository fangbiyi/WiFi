function [sortedElement, count] = elementCount(in, orderBy)
%elementCount: Count elements in a vector.
%	Usage:
%		[sortedElement, count] = elementCount(in, orderBy)
%
%	Description:
%		sortedElement = elementCount(in) returns the sorted elements.
%		[sortedElement, count] = elementCount(in) also returns the element count for each sorted element.
%		[uniqElement, sortedCount]=elementCount(in, 'count') returns the element counts in decreasing order.
%
%	Example:
%		in = [5 1 5 5 7 9 9];
%		fprintf('in = %s\n', mat2str(in));
%		fprintf('"[sortedElement, count] = elementCount(in)" produces the following output:\n');
%		[sortedElement, count] = elementCount(in);
%		fprintf('sortedElement = %s\n', mat2str(sortedElement));
%		fprintf('count = %s\n\n', mat2str(count));
%		in = {'xy', 'cd', 'ef', 'xy', 'cd', 'xy'};
%		fprintf('in = %s\n', cell2str(in));
%		fprintf('"[sortedElement, count] = elementCount(in)" produces the following output:\n');
%		[sortedElement, count] = elementCount(in);
%		fprintf('sortedElement = %s\n', cell2str(sortedElement));
%		fprintf('count = %s\n\n', mat2str(count));
%		in = {'xy', 'cd', 'ef', 'xy', 'cd', 'xy'};
%		fprintf('in = %s\n', cell2str(in));
%		fprintf('"[element, sortedCount] = elementCount(in, ''count'')" produces the following output:\n');
%		[element, sortedCount] = elementCount(in, 'count');
%		fprintf('element = %s\n', cell2str(element));
%		fprintf('sortedCount = %s\n\n', mat2str(sortedCount));

%	Roger Jang, 19970327, 20071009, 20120615

if nargin<1, selfdemo; return, end
if nargin<2, orderBy='element'; end

if isnumeric(in)	% Numerical vector
	[m,n] = size(in);
	in1 = sort(in);
	in1(end+1)=in1(end)+1;
	index = find(diff(in1) ~= 0);
	sortedElement = in1(index);
	if n==1
		count = diff([0; index]);
	else
		count = diff([0, index]);
	end
end

if iscell(in)		% Cell string
	[m,n] = size(in);
	in1 = sort(in);
	in1{end+1}=[in1{end}, 'z'];
	index = find(strcmp(in1(1:end-1), in1(2:end))==0);
	sortedElement = in1(index);
	if n==1
		count = diff([0; index]);
	else
		count = diff([0, index]);
	end
end

if strcmp(orderBy, 'count')
	[count, sortIndex]=sort(count, 'descend');
	sortedElement=sortedElement(sortIndex);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
