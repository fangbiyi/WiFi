function DS2=dsEdit(DS, iterCount, plotOpt)
%dsEdit: Data editing
%
%	Usage:
%		DS2=dsEdit(DS)
%		DS2=dsEdit(DS, iterCount)
%		DS2=dsEdit(DS, iterCount, plotOpt)
%
%	Description:
%		DS2=dsEdit(DS) returns the reduced dataset using data editing.
%		DS2=dsEdit(DS, iterCount) uses the given iteration count for data editing
%		DS2=dsEdit(DS, iterCount, plotOpt) plots the results of data editing (if the dimensions of the dataset is 2)
%
%	Example:
%		DS=prData('peaks');
%		iterCount=inf;
%		plotOpt=1;
%		DS2=dsEdit(DS, iterCount, plotOpt);
%
%	See also dsCondense.

%	Category: Data count reduction
%	Roger Jang, 20110205

if nargin<1, selfdemo; return; end
if nargin<2, iterCount=inf; end
if nargin<3, plotOpt=0; end

if isinf(iterCount), iterCount=uint32(inf); end

DS2=DS;
for i=1:iterCount
	[recogRate, computed, nearestIndex]=knncLoo(DS2);
	if recogRate==1, break; end
	deletedIndex=DS2.output~=computed;
	DS2.input(:, deletedIndex)=[];
	DS2.output(:, deletedIndex)=[];
end

if plotOpt
	subplot(1,2,1); dsScatterPlot(DS); axisLimit=axis;
	subplot(1,2,2); dsScatterPlot(DS2); axis(axisLimit);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
