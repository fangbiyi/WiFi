function [minDist, edPath, edTable] = editDistance(a, b, costVec, plotOpt)
%editDistance: Edit distance (ED) via dynamic programming
%
%	Usage:
%		minDist = editDistance(str1, str2)
%		minDist = editDistance(str1, str2, costVec)
%		minDist = editDistance(str1, str2, costVec, plotOpt)
%		[minDist, edPath, edTable] = editDistance(str1, str2, ...)
%
%	Description:
%		minDist = editDistance(str1, str2) returns the edit distance between strings str1 and str2, assuming the costs for insertion, deletion, and substitution are 1, 1, and 2, respectively.
%		minDist = editDistance(a, b, costVec) specifies the cost via costVec=[substitution, insertion, deletion].
%			If costVec is a scalar, then it is taken as the substitution cost and the other costs are assumed to be 1.
%		minDist = editDistance(a, b, costVec, plotOpt) display the optimum path on the DP table.
%		[minDist, edPath, edTable] = editDistance(a, b, ...) also returns the optimum path of dynamic programming in edPath, and the resulting table in edTable.
%
%	Example:
%		str1='execution';
%		str2='intention';
%		costVec=[2, 1, 1];
%		plotOpt=1;
%		[minDist, edPath, edTable] = editDistance(str1, str2, costVec, plotOpt);
%
%	See also lcs, dpPathPlot4strMatch.

%	Category: String match
%	Roger Jang, 20081008

if nargin<1, selfdemo; return; end
if nargin<3|isempty(costVec), costVec=[2, 1, 1]; end
if nargin<4, plotOpt=0; end

if isscalar(costVec), costVec=[costVec, 1, 1]; end

a=a(:)'; m=length(a);
b=b(:)'; n=length(b);
sCost=costVec(1);	% Substitution cose
iCost=costVec(2);	% Insertion cost
dCost=costVec(3);	% Deletion cost
edTable=zeros(m, n);
prevx=zeros(m, n);
prevy=zeros(m, n);
cost=zeros(3,1);
% Compute the first element
edTable(1,1)=(a(1)~=b(1))*sCost;
prevx(1,1)=0;		% not plotted
prevy(1,1)=0;		% not plotted
% Compute the first row & column
for i=2:m
	localCost=(a(i)~=b(1))*sCost;
	[edTable(i,1), index]=min([edTable(i-1,1)+1, localCost+i-1]);
	if index==1
		prevx(i,1)=i-1;
		prevy(i,1)=1;
	else
		prevx(i,1)=i-1;
		prevy(i,1)=0;
	end
end
for j=2:n
	localCost=(a(1)~=b(j))*sCost;
	[edTable(1,j), index]=min([edTable(1,j-1)+1, localCost+j-1]);
	if index==1
		prevx(1,j) = 1;
		prevy(1,j) = j-1;
	else
		prevx(1,j) = 0;
		prevy(1,j) = j-1;
	end
end
% Compute all the other elements
for i=2:m,
	for j=2:n,
		localCost=(a(i)~=b(j))*sCost;
		cost(1)=edTable(i-1, j-1)+localCost;
		cost(2)=edTable(i-1, j)+1;
		cost(3)=edTable(i, j-1)+1;
		[edTable(i,j), index]=min(cost);
		switch index
			case 1
				prevx(i,j)=i-1;
				prevy(i,j)=j-1;
			case 2
				prevx(i,j)=i-1;
				prevy(i,j)=j;
			case 3
				prevx(i,j)=i;
				prevy(i,j)=j-1;
		end
	end
end

% ====== Return length of ED string
minDist = edTable(m, n);

% ====== Return the optimal path of the dynamical programming
if nargout>1 | plotOpt
	now = [m, n];
	prev = [prevx(now(1), now(2)), prevy(now(1), now(2))];
	edPath = now;
	while all(prev>0)
		now = prev;
		prev = [prevx(now(1), now(2)), prevy(now(1), now(2))];
		edPath = [edPath; now];
	end 
	edPath = flipud(edPath);
end

% ====== Plot
if plotOpt
	dpPathPlot4strMatch(a, b, edPath, edTable, prevx, prevy);
	title(sprintf('Min. edit distance = %d', edTable(end, end)));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
