function color=getColor(index, useVec)
% getColor: Get a color from a palette
%
%	Usage:
%		color=getColor(index)
%
%	Description:
%		color=getColor(index) return a color (in a string) from a palette based on the given index.
%		color=getColor(index) return a color in the format a RGB vector.
%
%	Example:
%		for i=1:6
%			line(1:10, rand(1, 10), 'color', getColor(i), 'lineWidth', 3);
%		end
%		legend('Color 1', 'Color 2', 'Color 3', 'Color 4', 'Color 5', 'Color 6');

%	Category: Utility
%	Roger Jang, 20040910, 20071009

if nargin<1, selfdemo; return; end
if nargin<2, useVec=0; end

if ~useVec
	allColor={'b', 'r', 'g', 'm', 'c', 'y'};
	color=allColor{mod(index-1, length(allColor))+1};
else
	allColor=[0 0 1; 1 0 0; 0 1 0; 1 0 1; 0 1 1; 1 1 0];
	color=allColor(mod(index-1, length(allColor))+1, :);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
