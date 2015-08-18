function arrowH = arrowPlot(beginPoint, endPoint, color)
% arrowPlot: Plot an arrow on an existing plot
%	Usage: arrowH = arrowPlot(beingPoint, endPoint)
%		arrowH: Returned handle to the plotted arrow
%		beginPoint: Start point of the arrow (must be a complex number) 
%		endPoint: End point of the arrow (must be a complex number) 
%		color: Color of the arrow (optional, should be 3-element vector)
%
%	For instance:
%
%	arrowPlot(1+j, 2+3j, [1 0 0]); axis image

%	Roger Jang, 20001130

if nargin==0, selfdemo; return; end

arrowX = [-1 0 -0.1 -0.12 -0.02 -0.12 -0.1 0];
arrowY = [0 0 0.1 0.1 0 -0.1 -0.1 0];
basicArrow = 1+arrowX + j*arrowY;
newArrow = (endPoint-beginPoint)*basicArrow + beginPoint;

arrowH = line(real(newArrow), imag(newArrow), 'color', 'k', 'clip', 'off');
if nargin==3,
	set(arrowH, 'color', color);
end

function selfdemo
for i=1:10,
	beginPoint = rand+j*rand;
	endPoint = rand+j*rand;
	color = [rand, rand, rand];
	arrowPlot(beginPoint, endPoint, color);
	box on;
	axis image;
end
