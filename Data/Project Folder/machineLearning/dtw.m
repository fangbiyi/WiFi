function [minDist, dtwPath, dtwTable] = dtw(vec1, vec2, dtwOpt, showPlot)
% dtw1: DTW (dynamic time warping)
%
%	Usage:
%		minDist = dtw(vec1, vec2)
%		[minDist, dtwPath] = dtw(vec1, vec2)
%		[minDist, dtwPath, dtwTable] = dtw(vec1, vec2)
%		[...] = dtw(vec1, vec2, dtwOpt)
%		[...] = dtw(vec1, vec2, dtwOpt, showPlot)
%
%	Description:
%		dtw(vec1, vec2) returns the DTW distance between two vectors vec1 and vec2.
%		dtw(vec1, vec2, dtwOpt) perform DTW by using the given parameters in dtwOpt, with the fields
%			dtwOpt.type: type of DTW
%				dtwOpt.type=1 for type-1 DTW of local path constraints of 27-45-65.
%				dtwOpt.type=2 for type-2 DTW of local path constraints of 0-45-90.
%				dtwOpt.type=3 for type-3 DTW of local path constraints of 0-45.
%			dtwOpt.beginCorner: 1 for anchored beginning
%			dtwOpt.endCorner: 1 for anchored ending
%		dtw(vec1, vec2, dtwOpt, showPlot) plots the DTW path
%		[minDist, dtwPath, dtwTable] = dtw(...) returns additions information:
%			minDist: minimun distance of DTW
%			dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
%			dtwTable: DTW table
%		Depending on the value of dtwOpt.type, this function calls dtw1, dtw2, or dtw3.
%
%	Example:
%		vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
%		vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
%		[minDist, dtwPath, dtwTable]=dtw(vec1, vec2);
%		dtwPathPlot(vec1, vec2, dtwPath);
%
%	See also dtwPathPlot, dtwBridgePlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20110515

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(vec1) && strcmpi(vec1, 'defaultOpt')
	minDist.type=1;
	minDist.beginCorner=1;
	minDist.endCorner=1;
	minDist.distanceBound=inf;
	return
end
if nargin<3|isempty(dtwOpt), dtwOpt=feval(mfilename, 'defaultOpt'); end
if nargin<4, showPlot=0; end

type=dtwOpt.type;
beginCorner=dtwOpt.beginCorner;
endCorner=dtwOpt.endCorner;
distanceBound=dtwOpt.distanceBound;

% If input is vector, make it row vector
if size(vec1,1)==1 | size(vec1,2)==1, vec1 = vec1(:)'; end
if size(vec2,1)==1 | size(vec2,2)==1, vec2 = vec2(:)'; end

mexFile=sprintf('dtw%dmex', type);
mFile=sprintf('dtw%dm', type);
command=mexFile;
if exist(command)~=3
	command=mFile;
end

if nargout<1
	minDist=feval(command, vec1, vec2, beginCorner, endCorner, distanceBound);
else
	if ~isfield(dtwOpt, 'mWeight')
		[minDist, dtwPath, dtwTable]=feval(command, vec1, vec2, beginCorner, endCorner, distanceBound);
	else
		[minDist, dtwPath, dtwTable]=dtw1weightedMex(vec1, vec2, beginCorner, endCorner, ...
			dtwOpt.mWeight, dtwOpt.aWeight, distanceBound);
	end
end

% Plotting if necessary
if showPlot==1, dtwPathPlot(vec1, vec2, dtwPath); end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
