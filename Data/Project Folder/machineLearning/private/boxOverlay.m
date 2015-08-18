function [boxH, textH]=boxOverlay(bb, color, width, textString, textPos)
% boxOverlay: Overlay a bounding box
%	Usage:
%		boxOverlay(bb, color, width, textString, textPos)
%
%	Description:
%		boxOverlay(bb, color, width, textString, textPos)
%			bb: Bounding box ([x, y, w, h], as return by stats(i),BoundingBox, where x is the distance to the leftmost boundary and y is the distance to the upper boundary)
%			color: Color
%			width: Width of the line for drawing the bounding box
%			textString: String for display along the bounding box
%			textPos: text position, either 'up' or 'down'
%
%	Example:
%		% === Example 1
%		BW=[1 1 1 0 0 0 0 0;1 0 1 0 1 1 0 0;1 1 1 0 1 1 0 0;0 0 0 0 0 0 1 0;1 1 1 0 0 0 1 0;1 0 1 0 0 0 1 0;1 0 1 0 0 1 1 0;1 1 0 0 0 0 0 0];
%		objLabel=bwlabel(BW, 4);
%		stats=regionprops(objLabel);
%		figure;
%		subplot(121); imshow(BW);
%		subplot(122); imagesc(objLabel); axis image; colorbar
%		for i=1:length(stats)
%			boxOverlay(stats(i).BoundingBox, getColor(i), 1, int2str(i), 'bottom');
%		end
%		% === Example 2
%		BW=imread('text.png');
%		objLabel=bwlabel(BW);
%		stats=regionprops(objLabel);
%		figure; imagesc(objLabel); axis image; colorbar
%		for i=1:length(stats)
%			boxOverlay(stats(i).BoundingBox, getColor(i), 1, int2str(i), 'left');
%		end

if nargin<1, selfdemo; return; end
if nargin<2, color='r'; end
if nargin<3, width=2; end
if nargin<4, textString=''; end
if nargin<5, textPos='top'; end

x=[bb(1), bb(1)+bb(3), bb(1)+bb(3), bb(1), bb(1)];
y=[bb(2), bb(2), bb(2)+bb(4), bb(2)+bb(4), bb(2)];
boxH=line(x, y);
set(boxH, 'color', color, 'linewidth', width);
if strcmp(textPos, 'top')
	textH=text(bb(1)+bb(3)/2, bb(2), textString, 'color', color, 'vertical', 'bottom', 'horizontal', 'center');
elseif strcmp(textPos, 'bottom')
	textH=text(bb(1)+bb(3)/2, bb(2)+bb(4), textString, 'color', color, 'vertical', 'top', 'horizontal', 'center');
elseif strcmp(textPos, 'left')
	textH=text(bb(1), bb(2)+bb(4)/2, textString, 'color', color, 'vertical', 'middle', 'horizontal', 'right');
elseif strcmp(textPos, 'right')
	textH=text(bb(1)+bb(3), bb(2)+bb(4)/2, textString, 'color', color, 'vertical', 'middle', 'horizontal', 'left');
else
	error(sprintf('Unknown options for textPos "%s". Only "top", "bottom", "left" and "right" are allowed.', textPos));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
