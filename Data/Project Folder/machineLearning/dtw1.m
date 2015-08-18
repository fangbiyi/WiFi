function [minDist, dtwPath, dtwTable]=dtw1(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound)
% dtw1: DTW (dynamic time warping) with local paths of 27, 45, and 63 degrees
%
%	Usage:
%		minDist = dtw1(vec1, vec2)
%		minDist = dtw1(vec1, vec2, beginCorner, endCorner)
%		minDist = dtw1(vec1, vec2, beginCorner, endCorner, plotOpt)
%		minDist = dtw1(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound)
%		[minDist, dtwPath, dtwTable] = dtw1(...)
%
%	Description:
%		dtw1(vec1, vec2, beginCorner, endCorner, plotOpt, distanceBound) returns the DTW distance between vec1 and vec2, assuming a local path constrains of 27, 45, and 63 degrees.
%			vec1: testing vector
%			vec2: reference vector
%			beginCorner: 1 for anchored beginning
%			endCorner: 1 for anchored ending
%			plotOpt: 1 for plotting the DTW path
%			distanceBound: distance bound for stop the computation. (Stop the computation immediately if the accumulated DTW distance is larger than this distance bound.)
%		[minDist, dtwPath, dtwTable] = dtw1(...) also return two extra results:
%			dtwPath: optimal path of DTW (Its size is 2xk, where k is the path length.)
%			dtwTable: DTW table
%		Note that this function is called by dtw.
%
%	Example:
%		vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
%		vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
%		[minDist, dtwPath, dtwTable] = dtw1(vec1, vec2);
%		dtwPathPlot(vec1, vec2, dtwPath);
%
%	See also dtwPathPlot, dtwBridgePlot, dtw1m, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20030404, 20060614

if nargin<1, selfdemo; return; end
if nargin<3, beginCorner=1; end
if nargin<4, endCorner=1; end
if nargin<5, plotOpt=0; end
if nargin<6, distanceBound=inf; end

% If input is vector, make it row vector
if size(vec1,1)==1 | size(vec1,2)==1, vec1 = vec1(:)'; end
if size(vec2,1)==1 | size(vec2,2)==1, vec2 = vec2(:)'; end

mexCommand='dtw1mex';
mCommand='dtw1m';
if nargout<2
	try
		minDist=feval(mexCommand, vec1, vec2, beginCorner, endCorner, distanceBound);
	catch exception
		fprintf('%s is disabled due to the error message "%s".\n%s is activated instead.\n', mexCommand, exception.message, mCommand);
		minDist=feval(mCommand, vec1, vec2, beginCorner, endCorner, distanceBound);
	end
else
	try
		[minDist, dtwPath, dtwTable]=feval(mexCommand, vec1, vec2, beginCorner, endCorner, distanceBound);
	catch exception
		fprintf('%s is disabled due to the error message "%s".\n%s is activated instead.\n', mexCommand, exception.message, mCommand);
		[minDist, dtwPath, dtwTable]=feval(mCommand, vec1, vec2, beginCorner, endCorner, distanceBound);
	end
end

% Plotting if necessary
if plotOpt==1, dtwPathPlot(vec1, vec2, dtwPath); end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
