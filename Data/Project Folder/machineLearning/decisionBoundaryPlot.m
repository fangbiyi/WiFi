function [patchH, pointH]=decisionBoundaryPlot(surfObj, DS, mode)
% decisionBoundaryPlot: Plot of the decision boundary of a classifier
%
%	Usage:
%		patchH=decisionBoundaryPlot(surfObj, DS)
%
%	Description:
%		patchH=decisionBoundaryPlot(surfObj, DS) plots the decision boundary of a classifier.
%
%	Example:
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);			% Only take dimensions 3 and 4 for 2d visualization
%		[qcPrm, logProb, recogRate]=qcTrain(DS);
%		surfObj=qcPlot(DS, qcPrm);			% Compute the Gaussian pdf for each class
%		decisionBoundaryPlot(surfObj);			% Plot the decision boundary

%	Category: Classification analysis
%	Roger Jang, 20041201

if nargin<1, selfdemo; return; end
if nargin<2, DS=[]; end
if nargin<3, mode='max'; end

class=surfObj.class;
classNum=length(class);
xx=surfObj.xx;
yy=surfObj.yy;
data = [xx(:), yy(:)]';

matlabVersion=version;
matlabVersion=eval(matlabVersion(1));

hold on
for i=1:classNum
	tempClass=class;
	tempClass(i)=[];
	
	switch(mode)
		case 'max'
			maxSurf=max(cat(3, tempClass.surface), [], 3);
			tt=class(i).surface-maxSurf;
		case 'min'
			minSurf=min(cat(3, tempClass.surface), [], 3);
			tt=minSurf-class(i).surface;
		otherwise
			error('Unknown mode!');
	end
% 	if matlabVersion==6
		[c, h]=contourf(xx, yy, tt, 0*[1 1]);
% 	else
% 		[c, h]=contourf('v6', xx, yy, tt, 0*[1 1]);
% 	end
	p=get(h, 'child');	% p is a vector when there are more than one disjoint patches for decision boundary plot for a given class
	for j=1:length(p)
		class(i).contourx=get(p(j), 'xdata');
		class(i).contoury=get(p(j), 'ydata');
		patchH(i)=patch('xdata', class(i).contourx, 'ydata', class(i).contoury, 'faceColor', getColorLight(i));
	end
end
hold off
axis image;

pointH=[];
if ~isempty(DS)		% Overlay the data points
	pointH=dsScatterPlot(DS, struct('showLegend', 1, 'showAnnotation', 0));	% Do not show legend now
	[dim, dataNum]=size(DS.input);
	axis image; box on
	if isfield(DS, 'hitIndex')
		missIndex=1:dataNum;
		missIndex(DS.hitIndex)=[];
		% display these points
		for i=1:length(missIndex),
			line(DS.input(1,missIndex(i)), DS.input(2,missIndex(i)), 'marker', 'x', 'color', 'k');
		end
		titleString=sprintf('RR = %.2f%%', length(DS.hitIndex)/dataNum*100);
		title(strPurify(titleString));
	end
end
% ====== How to show legend now using the right line objects?

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
