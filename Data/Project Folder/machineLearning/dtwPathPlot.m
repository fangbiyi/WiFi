function dtwPathPlot(vec1, vec2, allDtwPath, dtwTableShape, distance) 
% dtwPathPlot: Plot the resultant path of DTW of two vectors
%
%	Usage:
%		dtwPathPlot(vec1, vec2, dtwPath)
%
%	Description:
%		dtwPathPlot(vec1, vec2, dtwPath) plots the DTW path dtwPath between two vectors vec1 and vec2.
%		Note that dtwPath must be obtained in advance, by any one of the DTW commands in the toolbox.
%		In fact, to plot multiple paths, dtwPath could be a cell array containing several DTW paths obtained from different versions of DTW.
%		dtwPathPlot(vec1, vec2, dtwPath, 'square') displays the DTW table as a square region for easy viewing.
%
%	Example:
%		% This example compares the optimum paths of type-1 and type-2 DTW.
%		vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
%		vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
%		dtwOpt=dtwOptSet;
%		dtwOpt.type=1;
%		[minDist1, dtwPath1, dtwTable1]=dtw(vec1, vec2, dtwOpt);
%		dtwOpt.type=2;
%		[minDist2, dtwPath2, dtwTable2]=dtw(vec1, vec2, dtwOpt);
%		dtwPathPlot(vec1, vec2, {dtwPath1, dtwPath2});
%
%	See also dtwPathPlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20020428, 20070522, 20110516

%myStack=dbstack;
%parentFunction=myStack(2).file

if nargin<1; selfdemo; return; end
if nargin<4; dtwTableShape='auto'; end

if isnumeric(allDtwPath), temp=allDtwPath; clear allDtwPath; allDtwPath{1}=temp; end

if size(vec1,1)>1 & size(vec1,2)>1 & size(vec2,1)>1 & size(vec2,2)>1	% Inputs are matrices
	dtwPathPlotInternal(vec1, vec2, allDtwPath);
	if nargin>=5, title(sprintf('DTW distance = %s', mat2str(distance))); end	% Overwrite the title
	return
end

vec1=vec1(:); size1=length(vec1);
vec2=vec2(:); size2=length(vec2);
tableSize1=max(allDtwPath{1}(1,:));
tableSize2=max(allDtwPath{1}(2,:));
pos = get(gcf, 'pos');
width = pos(3);
height = pos(4);
% Assume width > height
% Assume the aspect ratio of the signal axis is b:1
b = 4;
k = height/(b+2.5);

% ====== Plot vec1 on x-axis
vec1Axis = subplot(2,2,4);
vec1H=plot(1:size1, vec1, 1:size1, vec1, 'r.');
axis tight
ylabel('vec1');
set(vec1Axis, 'unit', 'pixels');
set(vec1Axis, 'position', [width-(b+0.5)*k, height-(b+2)*k, b*k, k]); 
% ====== Plot vec2 on y-axis
vec2Axis = subplot(2,2,1);
%plot(min(vec2)+max(vec2)-vec2, 1:size2, min(vec2)+max(vec2)-vec2, 1:size2, 'r.');
vec2H=plot(vec2, 1:size2, vec2, 1:size2, 'r.');
axis tight;
xlabel('vec2');
set(vec2Axis, 'unit', 'pixels');
set(vec2Axis, 'position', [width-(b+2)*k, height-(b+0.5)*k, k, b*k]);
set(gca, 'xDir', 'reverse');
% ====== Adjust the range of vec1 and vec2
if tableSize1>size1 | tableSize2>size2	% DTW for duration alignment
	set(vec1Axis, 'xlim', [1, tableSize1]);
	set(gcf, 'CurrentAxes', vec1Axis); grid on
	set(vec1H, 'xdata', [1:size1]+0.5);
	set(vec2Axis, 'ylim', [1, tableSize2]);
	set(gcf, 'CurrentAxes', vec2Axis); grid on
	set(vec2H, 'ydata', [1:size2]+0.5);
end

% ====== Plot the DTW path
pathAxis = subplot(2,2,2);
box on;
set(pathAxis, 'unit', 'pixels');
position = [width-(b+0.5)*k, height-(b+0.5)*k, b*k, b*k]; 
set(pathAxis, 'position', position); 
dtwPathPlotInternal(vec1, vec2, allDtwPath);
if nargin>=5, title(sprintf('DTW distance = %s', mat2str(distance))); end	% Overwrite the title

if size2>size1,
	% Adjust the axis of vec1
	dtwPlotWidth = position(3)*size1/size2;
	oldPos = get(vec1Axis, 'pos');
	position = oldPos;
	position(1) = oldPos(1)+(oldPos(3)-dtwPlotWidth)/2;
	position(3) = dtwPlotWidth;
	set(vec1Axis, 'pos', position);
else
	% Adjust the axis of vec2
	dtwPlotHeight = position(3)*size2/size1;
	oldPos = get(vec2Axis, 'pos');
	position = oldPos;
	position(2) = oldPos(2)+(oldPos(4)-dtwPlotHeight)/2;
	position(4) = dtwPlotHeight;
	set(vec2Axis, 'pos', position);
end

set(findobj(gcf, 'unit', 'pixel'), 'unit', 'normalize');

if strcmp(lower(dtwTableShape), 'square')
	axis square	% Make DTW table square
	h=get(gcf, 'child');
	h1Pos=get(h(1), 'position');	% h(1) is the dtw table
	h2Pos=get(h(2), 'position');	% h(2) is the axis at the left of y-axis
	set(h(2), 'position', [h2Pos(1), h1Pos(2), h2Pos(3), h1Pos(4)])
end

% ====== Plot DTW path
function dtwPathPlotInternal(vec1, vec2, allDtwPath)
size1=length(vec1); size2=length(vec2);
% === Plot the yellow grid line
tableSize1=max(allDtwPath{1}(1,:));
tableSize2=max(allDtwPath{1}(2,:));
temp1=max(size1, tableSize1);	% To take care of the difference between common DTW and DTW for duration alignment
temp2=max(size2, tableSize2);	% To take care of the difference between common DTW and DTW for duration alignment
for i=1:temp1, line([i, i], [1, temp2], 'color', 'y'); end
for i=1:temp2, line([1, temp1], [i, i], 'color', 'y'); end
% === Plot paths obtained by various DTW
pathNum=length(allDtwPath);
dtwDist=zeros(1, pathNum);
for pathIndex=1:pathNum
	dtwPath=allDtwPath{pathIndex};
	for i = 1:size(dtwPath,2)-1,
		line(dtwPath(1, i:i+1), dtwPath(2, i:i+1), 'color', getColor(pathIndex), 'marker', '.');
	end
	if ~isempty(dtwPath)	% L-1 norm
		if tableSize1>size1 | tableSize2>size2	% DTW for duration alignment
			dtwPath=allDtwPath{pathIndex};
			diffTotal=0;
			for k=1:size(dtwPath,2)-1
				xTotalDuration=0;
				for q=dtwPath(1,k):dtwPath(1,k+1)-1;
					xTotalDuration=xTotalDuration+vec1(q);
				end
				yTotalDuration=0;
				for q=dtwPath(2,k):dtwPath(2,k+1)-1;
					yTotalDuration=yTotalDuration+vec2(q);
				end
				diffTotal=diffTotal+abs(xTotalDuration-yTotalDuration);
			end
			dtwDist(pathIndex)=diffTotal;
		else
			temp1=vec1(dtwPath(1,:));
			temp2=vec2(dtwPath(2,:));
			dtwDist(pathIndex) = sum(abs(temp1(:)-temp2(:)));
		end
	else
		dtwDist(pathIndex) = inf;
	end
end
title(sprintf('DTW total distance = %s', mat2str(dtwDist, 6)));
xlabel(inputname(1));
ylabel(inputname(2));
axis equal
axis tight

% ====== self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
