function [minDist, dtwPath, dtwTable]=dtw2m(vec1, vec2, beginCorner, endCorner, plotOpt)
% dtw2m: Pure m-file implementation of DTW (dynamic time warping) with local paths of 0, 45, and 90 degrees
%
%	Usage:
%		minDist = dtw2m(vec1, vec2)
%		minDist = dtw2m(vec1, vec2, beginCorner, endCorner)
%		minDist = dtw2m(vec1, vec2, beginCorner, endCorner, plotOpt)
%		minDist = dtw2m(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound)
%		[minDist, dtwPath, dtwTable] = dtw2m(...)
%
%	Description:
%		dtw2m(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 0, 45, and 90 degrees.
%			vec1: testing vector
%			vec2: reference vector
%			beginCorner: 1 for anchored beginning
%			endCorner: 1 for anchored ending
%			plotOpt: 1 for plotting the DTW path
%			distanceBound: distance bound for stop the computation. (Stop the computation immediately if the accumulated DTW distance is larger than this distance bound.)
%		[minDist, dtwPath, dtwTable] = dtw2m(...) also return two extra results:
%			dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
%			dtwTable: DTW table
%		Note that this function is a pure m-file implementation which is slow but easy to customize.
%
%	Example:
%		vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
%		vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
%		[minDist, dtwPath, dtwTable] = dtw2m(vec1, vec2);
%		dtwPathPlot(vec1, vec2, dtwPath);
%
%	See also dtwPathPlot, dtwBridgePlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20030404, 20111119

if nargin<1, selfdemo; return; end
if nargin<3, beginCorner=1; end
if nargin<4, endCorner=1; end
if nargin<5, plotOpt = 0; end

% If input is vector, make it row vector
if size(vec1,1)==1 | size(vec1,2)==1, vec1 = vec1(:)'; end
if size(vec2,1)==1 | size(vec2,2)==1, vec2 = vec2(:)'; end

size1=size(vec1, 2);
size2=size(vec2, 2);

% ====== Construct DTW table
dtwTable=inf*ones(size1,size2);
% ====== Construct prevPos table for back tracking the optimum path
if nargout>1
	for i=1:size1
		for j=1:size2
			prevPos(i,j).i=-1;
			prevPos(i,j).j=-1;
		end
	end
end
% ====== Construct the first element of the DTW table
dtwTable(1,1)=vecDist(vec1(:,1), vec2(:,1));
% ====== Construct the first column of the DTW table (xy view)
if beginCorner~=1
	for j=2:size2-ceil((size1-1)/2)
		dtwTable(1,j)=vecDist(vec1(:,1), vec2(:,j));
	end
end
% ====== Construct the first row of the DTW table (xy view)
%for i=2:size1
%	dtwTable(i, 1)=dtwTable(i-1,1)+vecDist(vec1(:,i), vec2(:,1));
%	if nargout>1, prevPos(i,1).i=i-1; prevPos(i,1).j=1; end
%end
% ====== Construct all the other rows of DTW table
for i=2:size1
	lowerBound1=ceil((i-1)/2)+1;			% Bound from the start point
	lowerBound2=size2-2*(size1-i);			% Bound from the end point
	lowerBound=lowerBound1;
	if endCorner==1
		lowerBound=max(lowerBound1, lowerBound2);
	end
	upperBound1=2*(i-1)+1;				% Bound from the start point
	upperBound2=size2-ceil((size1-i)/2);		% Bound from the end point
	upperBound=upperBound2;
	if beginCorner==1
		upperBound=min(upperBound1, upperBound2);
	end
%	fprintf('i=%d, [%d, %d]\n', i, lowerBound, upperBound);
	for j=lowerBound:upperBound
		% ====== Check 45-degree predecessor
		dtwTable(i,j)=dtwTable(i-1,j-1);
		if nargout>1, prevPos(i,j).i=i-1; prevPos(i,j).j=j-1; end
		% ====== Check 0-degree predecessor
		if dtwTable(i,j)>dtwTable(i-1,j)
			dtwTable(i,j)=dtwTable(i-1,j);
			if nargout>1, prevPos(i,j).i=i-1; prevPos(i,j).j=j; end
		end
		% ====== Check 90-degree predecessor
		if dtwTable(i,j)>dtwTable(i,j-1)
			dtwTable(i,j)=dtwTable(i,j-1);
			if nargout>1, prevPos(i,j).i=i; prevPos(i,j).j=j-1; end
		end
		dtwTable(i,j)=dtwTable(i,j)+vecDist(vec1(:,i), vec2(:,j));
	end
end

% ====== Find the last point and the min. dist
besti=size1;
if endCorner==1
	minDist=dtwTable(end, end);
	bestj=size2;
else
	[minDist, bestj]=min(dtwTable(end,:));
end

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

% ========== Sub function ===========
function distance=vecDist(x, y)
%distance=norm(x-y);	% This makes a tiny difference from C version
distance=sqrt(sum((x-y).^2));

function selfdemo
% Generate data for DTW
data_n = 51;
t = linspace(0,1,data_n);
y = sin(50*t);
new_t = smf(t, [0,1]);
new_y = interp1(new_t, y, t, 'cubic');	% Resampling
% ====== Delete some points
deleted_n = 5;
y(1:deleted_n)=[];
y(end-deleted_n+1:end)=[];
plotOpt = 1;
[minDist, dtwPath] = feval(mfilename, y, new_y, 1, 1, plotOpt);