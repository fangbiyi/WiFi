function dsFeaVecPlot(DS)
%dsFeaVecPlot: Plot of feature vectors in each class
%
%	Usage:
%		dsFeaVecPlot(DS)
%
%	Description:
%		dsFeaVecPlot(DS) plot featuers vs. data index.
%
%	Example:
%		DS=prData('iris');
%		dsFeaVecPlot(DS);
%
%	See also dsFeaVsIndexPlot.

%	Category: Dataset visualization
%	Roger Jang, 20140718

if nargin<1, selfdemo; return, end

[feaDim, dataNum]=size(DS.input);
inputMin=min(min(DS.input));
inputMax=max(max(DS.input));
distinctClass = elementCount(DS.output);
classNum = length(distinctClass);
plotNum = classNum;
side = ceil(sqrt(plotNum));
side1=side; side2=side;
if plotNum==2, side1=2; side2=1; end
k = 1;
for i = 1:side1
	for j = 1:side2
		if k <= plotNum,
			subplot(side1, side2, k);
			index=find(DS.output==distinctClass(k));
			plot(1:feaDim, DS.input(:, index), 'marker', '.', 'lineStyle', '-', 'color', getColorLight(k));		% Plot fecture vectors of each class
			line(1:feaDim, mean(DS.input(:, index), 2), 'marker', '.', 'lineStyle', '-', 'color', 'k', 'linewidth', 2);		% Plot the mean feature vector
			box on; axis([1, feaDim, inputMin, inputMax]);
		%	axis([-inf inf -inf inf]);
			axisLimitSame;
			xlabel('Feature index');
			ylabel('Feature strength');
			title(sprintf('%d feature vectors for "%s"', length(index), DS.outputName{k}));
			k = k+1;
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
