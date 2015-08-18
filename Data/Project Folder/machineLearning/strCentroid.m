function [outStr, distVec, distMat]=strCentroid(cellStr, opt, showPlot)
%strCentroid: Return the centroid of a set of strings
%
%	Usage:
%		outStr=strCentroid(cellStr, opt)
%
%	Description:
%		strCentroid(cellStr) returns the string that has the shortest overall distance to all the other strings based on edit distance. The returned string must be one of the strings in cellStr.
%
%	Example:
%		cellStr={'abcd', 'abde', 'abc', 'asdf', 'abd', 'abcd', 'abd'};
%		opt=strCentroid('defaultOpt');
%		outStr=strCentroid(cellStr, opt);
%		fprintf('The centroid of %s is %s.\n', cell2str(cellStr), outStr);
%
%	See also editDistance, lcs.

%	Category: String processing
%	Roger Jang, 20140624

if nargin<1, selfdemo; return; end
if ischar(cellStr) && strcmpi(cellStr, 'defaultOpt')	% Set the default options
	outStr.distanceFcn=@editDistance;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

strNum=length(cellStr);
distMat=zeros(strNum, strNum);

for i=1:strNum
	for j=i+1:strNum
		distMat(i,j)=feval(opt.distanceFcn, cellStr{i}, cellStr{j});
	end
end
distMat=distMat+distMat';
distVec=sum(distMat);
[minDist, index]=min(distVec);
outStr=cellStr{index};

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);