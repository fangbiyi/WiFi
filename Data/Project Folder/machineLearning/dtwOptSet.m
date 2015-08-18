function dtwOpt=dtwOptSet
% dtwOptSet: Set the parameters for DTW
%
%	Usage:
%		dtwOpt=dtwOptSet
%
%	Description:
%		dtwOpt=dtwOptSet returns the parameters for DTW.
%
%	Example:
%		dtwOpt=dtwOptSet
%
%	See also dtw.

%	Category: Dynamic time warping
%	Roger Jang, 20110515

dtwOpt.type=1;			% 1, 2, 3
dtwOpt.beginCorner=1;
dtwOpt.endCorner=1;
dtwOpt.plot=0;
dtwOpt.distanceBound=inf;
