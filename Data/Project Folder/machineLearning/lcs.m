function [lcsLength, lcsPath, lcsStr, lcsTable] = lcs(a, b, showPlot)
%lcs: Longest (maximum) common subsequence
%
%	Usage:
%		lcsLength = lcs(a, b)
%		lcsLength = lcs(a, b, showPlot)
%		[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(...)
%
%	Description:
%		lcsLength = lcs(a, b) returns the LCS (longest common subsequence) between two strings a and b.
%			a: input string 1
%			b: input string 2
%		lcsLength = lcs(a, b, 1) plots the path of LCS.
%		[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(a, b) returns extra info:
%			lcsPath: optimal path of dynamical programming through the LCS table
%			lcsStr: LCS string
%			lcsTable: LCS table for applying dynamic programming
%
%	Example:
%		str1='elimination';
%		str2='religious';
%		showPlot=1;
%		[lcsLength, lcsPath, lcsStr, lcsTable] = lcs(str1, str2, showPlot);
%
%	See also editDistance, dpPathPlot4strMatch.

%	Category: String match
%	Roger Jang, 19981226, 19990409, 20060528, 20081009

if nargin<1, selfdemo; return; end
if nargin<3, showPlot=0; end

a=a(:)'; m=length(a);
b=b(:)'; n=length(b);
lcsTable=zeros(m, n);
prevx=zeros(m, n);
prevy=zeros(m, n);
% Compute the first element
lcsTable(1,1)=a(1)==b(1);
prevx(1,1)=0;		% not plotted
prevy(1,1)=0;		% not plotted
% Compute the first row & column
for i=2:m
	if a(i)==b(1)
		lcsTable(i,1)=1;
		prevx(i,1)=i-1;
		prevy(i,1)=0;
	else
		lcsTable(i,1)=lcsTable(i-1,1);
		prevx(i,1)=i-1;
		prevy(i,1)=1;
	end
end
for j=2:n
	if a(1)==b(j)
		lcsTable(1,j)=1;
		prevx(1,j) = 0;
		prevy(1,j) = j-1;
	else
		lcsTable(1,j)=lcsTable(1,j-1);
		prevx(1,j) = 1;
		prevy(1,j) = j-1;
	end
	
end
% Compute all the other elements
for i=2:m,
	for j=2:n,
		if a(i)==b(j)
			lcsTable(i,j)=lcsTable(i-1,j-1)+1;
			prevx(i,j)=i-1;
			prevy(i,j)=j-1;
		else
			[lcsTable(i,j), index]=max([lcsTable(i-1, j), lcsTable(i, j-1)]);
			switch index
				case 1
					prevx(i,j)=i-1;
					prevy(i,j)=j;
				case 2
					prevx(i,j)=i;
					prevy(i,j)=j-1;
			end
		end
	end
end

% ====== Return length of ED string
lcsLength = lcsTable(m, n);

% ====== Return the optimal path of the dynamical programming
if nargout>1 || showPlot
	now = [m, n];
	prev = [prevx(now(1), now(2)), prevy(now(1), now(2))];
	lcsPath = now;
	while all(prev>0)
		now = prev;
		prev = [prevx(now(1), now(2)), prevy(now(1), now(2))];
		lcsPath = [lcsPath; now];
	end 
	lcsPath = flipud(lcsPath);
end

% ====== Return the LCS string
if nargout>2 || showPlot		% return LCS string
	temp = lcsTable((lcsPath(:,2)-1)*m+lcsPath(:,1));	% LCS count along the path
	temp = [0; temp];
	index = logical(diff(temp));
	lcsStr = a(lcsPath(index,1));
end

% ====== Plot
if showPlot
	dpPathPlot4strMatch(a, b, lcsPath, lcsTable, prevx, prevy);
	title(sprintf('LCS = %s', lcsStr));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
