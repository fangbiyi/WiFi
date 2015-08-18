function dtwBridgePlot(vec1, vec2, dtwPath, viewType) 
% dtwBridgePlot: Bridge Plot of point-to-point mapping of DTW
%
%	Usage:
%		dtwBridgePlot(vec1, vec2, dtwPath)
%		dtwBridgePlot(vec1, vec2, dtwPath, viewType)
%
%	Description:
%		dtwBridgePlot(vec1, vec2, dtwPath) plots the point-to-point mapping of DTW between vec1 and vec2.
%		dtwBridgePlot(vec1, vec2, dtwPath, viewType) uses the specified view type to do plotting:
%			viewType='2d' for 2D view of the bridge plot (This is the default.)
%			viewType='3d' for 3D view of the bridge plot
%
%	Example:
%		% === 2D view of the bridge plot
%		vec1=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78];
%		vec2=[69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78];
%		dtwOpt=dtwOptSet;
%		dtwOpt.type=1;
%		[minDist1, dtwPath1, dtwTable1] = dtw(vec1, vec2, dtwOpt);
%		dtwOpt.type=2;
%		[minDist2, dtwPath2, dtwTable2] = dtw(vec1, vec2, dtwOpt);
%		subplot(2,1,1); dtwBridgePlot(vec1, vec2, dtwPath1, '2d'); title('Alignment by type-1 DTW');
%		subplot(2,1,2); dtwBridgePlot(vec1, vec2, dtwPath2, '2d'); title('Alignment by type-2 DTW');
%		% === 3D view of the bridge plot
%		figure;
%		subplot(2,1,1); dtwBridgePlot(vec1, vec2, dtwPath1, '3d'); title('Alignment by type-1 DTW'); view(-10, 70);
%		subplot(2,1,2); dtwBridgePlot(vec1, vec2, dtwPath2, '3d'); title('Alignment by type-2 DTW'); view(-10, 70);
%
%	See also dtwBridgePlot, dtw1, dtw2, dtw3.

%	Category: Dynamic time warping
%	Roger Jang, 20030521, 20070522

if nargin<1; selfdemo; return; end
if nargin<4, viewType='2d'; end

if size(vec1,1)>1 | size(vec2,1)>1,	% Inputs are MFCC matrices for ASR
	vec1=zeros(1, size(vec1,2));
	vec2=zeros(1, size(vec2,2));
end

switch(lower(viewType))
	case '2d'
		initShift=dtwPath(2,1)-dtwPath(1,1);		% 若非從頭比對，畫vec1時，需平移的點數
		plot((1:length(vec1))+initShift, vec1, '.-');
		gap=(max(vec1)-min(vec1)+max(vec2)-min(vec2))/4;	% 上下波形的差距
		newVec2=vec2-min(vec2)+max(vec1)+gap;
		line(1:length(newVec2), newVec2, 'marker', '.', 'color', 'k');
		legend('vec1', 'vec2');

		for i=1:size(dtwPath, 2)
			from=[dtwPath(1,i)+initShift, vec1(dtwPath(1,i))];
			to  =[dtwPath(2,i), newVec2(dtwPath(2,i))];
			line([from(1), to(1)], [from(2), to(2)], 'color', 'r');
		end
		axisLimit=axis;
		line(axisLimit(1:2), min(vec1)*[1 1], 'color', 'k', 'linestyle', ':');
		line(axisLimit(1:2), max(vec1)*[1 1], 'color', 'k', 'linestyle', ':');
		line(axisLimit(1:2), min(newVec2)*[1 1], 'color', 'k', 'linestyle', ':');
		line(axisLimit(1:2), max(newVec2)*[1 1], 'color', 'k', 'linestyle', ':');
		axis tight
	case '3d'
		initShift=dtwPath(2,1)-dtwPath(1,1);		% 若非從頭比對，畫vec1時，需平移的點數
		plot3((1:length(vec1))+initShift, 0*vec1, vec1, '.-');
		gap=(max(vec1)-min(vec1)+max(vec2)-min(vec2))/4;	% 上下波形的差距
		line(1:length(vec2), 0*vec2+gap, vec2, 'marker', '.', 'color', 'k');
		legend('vec1', 'vec2');

		for i=1:size(dtwPath, 2)
			from=[dtwPath(1,i)+initShift, vec1(dtwPath(1,i))];
			to  =[dtwPath(2,i), vec2(dtwPath(2,i))];
			line([from(1), to(1)], [0, gap], [from(2), to(2)], 'color', 'r');
		end
		axis tight
		box on
		rotate3d on
	otherwise
		error('Unknown viewType=%s', viewType);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
