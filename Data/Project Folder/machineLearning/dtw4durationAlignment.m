function [minDist, dtwPath, dtwTable] = dtw4durationAlignment(vec1, vec2, plotOpt)
% dtw1m: Pure m-file implementation of DTW (dynamic time warping) for duration alignment
%
%	Usage:
%		minDist = dtw4durationAlignment(vec1, vec2)
%		minDist = dtw4durationAlignment(vec1, vec2, plotOpt)
%		[minDist, dtwPath, dtwTable] = dtw4durationAlignment(...)
%
%	Description:
%		dtw1m(vec1, vec2, plotOpt) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 27, 45, and 63 degrees.
%			vec1: testing vector
%			vec2: reference vector
%			plotOpt: 1 for plotting the DTW path
%		[minDist, dtwPath, dtwTable] = dtw1m(...) also return two extra results:
%			dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
%			dtwTable: DTW table
%		Note that this function is a pure m-file implementation which is slow but easy to customize.
%
%	Example:
%		vec1=[2 3 1 2 4 1 3 2 3];
%		vec2=[1 1 4 1 2 2 4 5];
%		[minDist, dtwPath, dtwTable] = dtw4durationAlignment(vec1, vec2);
%		dtwPathPlot(vec1, vec2, dtwPath);
%
%	See also dtwPathPlot, dtwBridgePlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20120705

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt = 0; end

% If input is vector, make it row vector
if size(vec1,1)==1 | size(vec1,2)==1, vec1 = vec1(:)'; end
if size(vec2,1)==1 | size(vec2,2)==1, vec2 = vec2(:)'; end

size1=size(vec1, 2);
size2=size(vec2, 2);

% ====== Construct DTW table
dtwTable=inf*ones(size1+1, size2+1);
% ====== Construct prevPos table for back tracking the optimum path
if nargout>1
	for i=1:size1+1
		for j=1:size2+1
			prevPos(i,j).i=-1;
			prevPos(i,j).j=-1;
		end
	end
end
% ====== Construct boundary of DTW table
for i=2:size1+1, dtwTable(i,1)=inf; end
for j=2:size2+1, dtwTable(1,j)=inf; end
dtwTable(1,1)=0;

% ====== Construct all the other rows of DTW table (xy view)
for i=2:size1+1
	for j=2:size2+1
		% ====== Check 45-degree predecessor
		dtwTable(i,j)=dtwTable(i-1,j-1)+abs(vec1(i-1)-vec2(j-1));
		if nargout>1, prevPos(i,j).i=i-1; prevPos(i,j).j=j-1; end
		% ====== Check 27-degree predecessor
		if i>2
			tmp=dtwTable(i-2,j-1)+abs(vec1(i-2)+vec1(i-1)-vec2(j-1));
			if dtwTable(i,j)>tmp
				dtwTable(i,j)=tmp;
				if nargout>1, prevPos(i,j).i=i-2; prevPos(i,j).j=j-1; end
			end
		end	
		% ====== Check 63-degree predecessor
		if j>2
			tmp=dtwTable(i-1,j-2)+abs(vec2(j-2)+vec2(j-1)-vec1(i-1));
			if dtwTable(i,j)>tmp
				dtwTable(i,j)=tmp;
				if nargout>1, prevPos(i,j).i=i-1; prevPos(i,j).j=j-2; end
			end
		end
	end
end

% ====== Find the last point and the min. dist
besti=size1+1;
minDist=dtwTable(end, end);
bestj=size2+1;

if nargout>1	% Return the optimum path
	% ====== Back track to find all the other points
	dtwPath=[besti; bestj];		% The last point in the optimum path
	nextPoint=[prevPos(dtwPath(1,1), dtwPath(2,1)).i; prevPos(dtwPath(1,1), dtwPath(2,1)).j];
	while nextPoint(1)>0 & nextPoint(2)>0
		dtwPath=[nextPoint, dtwPath];
		nextPoint=[prevPos(dtwPath(1,1), dtwPath(2,1)).i; prevPos(dtwPath(1,1), dtwPath(2,1)).j];
	end
end

% ====== Plotting if necessary
if plotOpt==1, dtwPathPlot(vec1, vec2, dtwPath); end

% ====== Self demo
% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);