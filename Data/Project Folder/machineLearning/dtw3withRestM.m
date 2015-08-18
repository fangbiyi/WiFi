function [minDist, dtwPath, dtwTable]=dtw3withRestM(vec1, vec2, dtwOpt, showPlot)
% dtw3m: Pure m-file implementation of DTW (dynamic time warping) with local paths of 0 and 45 degrees
%
%	Usage:
%		minDist = dtw3m(vec1, vec2)
%		minDist = dtw3m(vec1, vec2, opt)
%		minDist = dtw3m(vec1, vec2, opt, showPlot)
%		[minDist, dtwPath, dtwTable] = dtw3m(...)
%
%	Description:
%		dtw3m(vec1, vec2, beginCorner, endCorner, showPlot, distanceBound) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 0 and 45 degrees.
%			vec1: testing vector
%			vec2: reference vector
%			beginCorner: 1 for anchored beginning
%			endCorner: 1 for anchored ending
%			showPlot: 1 for plotting the DTW path
%			distanceBound: distance bound for stop the computation. (Stop the computation immediately if the accumulated DTW distance is larger than this distance bound.)
%		[minDist, dtwPath, dtwTable] = dtw3m(...) also return two extra results:
%			dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
%			dtwTable: DTW table
%		Note that this function is a pure m-file implementation which is slow but easy to customize.
%
%	Example:
%		% === This example aligns a singing pitch to a note sequence
%		pv=[60.485736 61.330408 61.917323 62.836778 63.478049 63.807818 63.478049 63.807818 63.478049 62.836778 63.154445 62.836778 63.154445 63.478049 62.524836 nan nan nan nan 65.930351 65.930351 65.930351 65.558029 65.193545 64.836577 64.836577 64.836577 65.558029 65.558029 65.930351 65.558029 65.193545 64.836577 64.486821 62.218415 61.330408 61.621378 61.917323 62.836778 63.478049 63.478049 63.154445 63.478049 63.807818 63.807818 63.154445 63.154445 63.154445 67.505286 68.349958 68.349958 68.788268 68.788268 68.788268 68.788268 68.788268 68.788268 68.788268 68.788268 68.349958 68.349958 67.505286 67.505286 67.922471 68.788268 68.788268 69.237965 68.788268 68.349958 68.349958 68.349958 68.349958 68.349958 68.349958 68.349958 68.349958 68.349958 68.349958 67.922471 67.922471 67.097918 62.218415 62.218415 61.917323 62.218415 62.836778 63.478049 63.478049 63.154445 62.836778 63.154445 62.524836 62.836778 62.524836 68.788268 66.699915 66.699915 66.310858 66.310858 66.310858 66.310858 65.930351 65.930351 65.930351 65.930351 65.930351 65.558029 65.193545 64.486821 63.154445 62.836778 62.836778 63.154445 63.478049 63.478049 63.154445 62.836778 62.836778 62.524836 62.524836 62.524836 69.699654 70.661699 71.163541 71.163541 70.661699 70.661699 70.661699 70.661699 70.661699 70.661699 70.661699 70.661699 71.163541 70.173995 69.699654 69.237965 68.788268 69.237965 69.699654 69.699654 69.237965 68.788268 69.237965 69.237965 69.237965 69.237965 69.237965 69.237965 69.237965 68.788268 67.097918 63.154445 63.154445 63.478049 64.143991 64.143991 63.807818 63.154445 64.143991 63.154445 63.478049 63.807818 63.478049 nan nan nan nan nan nan nan 73.330408 74.524836 75.154445 75.807818 75.807818 75.807818 75.807818 75.807818 76.486821 76.486821 76.486821 76.486821 75.807818 75.807818 74.524836 72.213095 71.163541 71.680365 72.213095 72.762739 72.762739 72.762739 72.762739 72.762739 72.762739];
%		note=[60 29 60 10 62 38 60 38 65 38 64 77 60 29 60 10 62 38 60 38 67 38 65 77 60 29 60 10 72 38 69 38 65 38 64 38 62 77 0 77 70 29 70 10 69 38 65 38 67 38 65 38];
%		notePitch=note(1:2:end);		% Get pitch only
%		notePitch(notePitch==0)=[];		% Get rid of rests
%		opt=dtw3withRestM('defaultOpt');
%		opt.endCorner=0;
%		[minDist, dtwPath] = dtw3withRestM(pv, notePitch, opt);
%		dtwPathPlot(pv, notePitch, dtwPath, 'square');
%
%	See also dtwPathPlot, dtwBridgePlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20060529, 20111119, 20140630

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(vec1) && strcmpi(vec1, 'defaultOpt')
	minDist.beginCorner=1;
	minDist.endCorner=1;
	minDist.frameRate=8000/256;
	return
end
if nargin<3|isempty(dtwOpt), dtwOpt=feval(mfilename, 'defaultOpt'); end
if nargin<4, showPlot=0; end

frameRate=dtwOpt.frameRate;
beginCorner=dtwOpt.beginCorner;
endCorner=dtwOpt.endCorner;
pointDuration=1/frameRate;

% If input is vector, make it row vector
if size(vec1,1)==1 | size(vec1,2)==1, vec1 = vec1(:)'; end
if size(vec2,1)==1 | size(vec2,2)==1, vec2 = vec2(:)'; end

size1=size(vec1, 2);
size2=size(vec2, 2);

% ====== Construct DTW table
dtwTable=inf*ones(size1, size2);
noteDuration=zeros(size1, size2);
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
noteDuration(1,1)=1/frameRate;
% ====== Construct the first row of the DTW table (xy view)
for i=2:size1
	if isnan(vec1(:,i))
		dtwTable(i,1)=dtwTable(i-1,1);
	else
		dtwTable(i,1)=dtwTable(i-1,1)+vecDist(vec1(:,i), vec2(:,1));
	end
	noteDuration(i,1)=noteDuration(i-1,1)+pointDuration;
	if nargout>1
		prevPos(i,1).i=i-1;
		prevPos(i,1).j=1;
	end
end
% ====== Construct the first column of the DTW table (xy view)
if beginCorner==0
	for j=2:size2
		dtwTable(1,j)=vecDist(vec1(:,1), vec2(:,j));
		noteDuration(1,j)=pointDuration;
	end
end

% ====== Construct all the other rows of DTW table
for i=2:size1
	for j=2:size2
		if isnan(vec1(:,i))	% ====== Take 0-degree path
			dtwTable(i,j)=dtwTable(i-1,j);
			noteDuration(i,j)=noteDuration(i-1,j)+pointDuration;
			if nargout>1
				prevPos(i,j).i=i-1;
				prevPos(i,j).j=j;
			end
		elseif isnan(vec1(:,i-1))	% ====== Take 45-degree path
			dtwTable(i,j)=dtwTable(i-1,j-1);
			noteDuration(i,j)=pointDuration;
			if nargout>1
				prevPos(i,j).i=i-1;
				prevPos(i,j).j=j-1;
			end
		elseif dtwTable(i-1,j)<dtwTable(i-1,j-1)	% ====== Take 0-degree path
			dtwTable(i,j)=dtwTable(i-1,j)+vecDist(vec1(:,i), vec2(:,j));
			noteDuration(i,j)=noteDuration(i-1,j)+pointDuration;
			if nargout>1
				prevPos(i,j).i=i-1;
				prevPos(i,j).j=j;
			end
		else					% ====== Take 45-degree path
			dtwTable(i,j)=dtwTable(i-1,j-1)+vecDist(vec1(:,i), vec2(:,j));
			noteDuration(i,j)=pointDuration;
			if nargout>1
				prevPos(i,j).i=i-1;
				prevPos(i,j).j=j-1;
			end
		end
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
if showPlot==1, dtwPathPlot(vec1, vec2, dtwPath); end

% ========== Sub function ===========
function distance=vecDist(x, y)
%distance=norm(x-y);	% This makes a tiny difference from C version
%distance=sqrt(sum((x-y).^2));
distance=sum(abs(x-y));

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);