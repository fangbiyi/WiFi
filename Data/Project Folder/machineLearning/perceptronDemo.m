%perceptronDemo: Demo of interactive perceptron training 
%
%	Usage:
%		perceptronDemo
%
%	Description:
%		perceptronDemo gives interactive demo of perceptron training based
%		sequential learning. You can move the data point to see how the
%		training react to the change.
%
%	Example:
%		perceptronDemo
%
%	See also lincTrain, lincEval, lincOptSet.

%	Category: Linear classifier
%	Roger Jang, 19961008

iterCount=5000;
data_n = 20;
in_data = rand(data_n, 2)*2-1;
index1 = find(in_data(:,1)+in_data(:,2)>0);
index2 = (1:data_n)';
index2(index1) = [];
data = [in_data(index1, :) -ones(size(index1));...
	in_data(index2, :)  ones(size(index2))];

figure('name', 'Perceptron Demo', 'NumberTitle', 'off');
dataH = zeros(data_n, 1);
for i = 1:data_n,
	dataH(i) = line(data(i,1), data(i,2), 'linewidth', 2, ...
		'marker', 'x', 'color', 'b', 'markersize', 15);
end
for i = 1:length(index1),
	set(dataH(i), 'marker', 'o', 'color', 'g');
end
axis square; axis([-1 1 -1 1]);
set(gca, 'box', 'on');
xlabel('Click and drag on the data points to move them.');
title('Perceptron Demo');

%lineH = line([-1 1], [-1 1], 'linewidth', 2, 'erase', 'xor', 'color', 'm');
lineH = line([-1 1], [-1 1], 'linewidth', 2, 'color', 'm');

r = 0.1;
theta = linspace(0, 2*pi);
circle_x = r*cos(theta); 
circle_y = r*sin(theta); 
%circleH = line(nan, nan, 'color', 'r', 'erase', 'xor', 'linewidth', 2);
circleH = line(nan, nan, 'color', 'r', 'linewidth', 2);

AxisH = gca; FigH = gcf;
curr_info = get(AxisH, 'CurrentPoint');
current_x = curr_info(1,1);

% The following is for animation
% action when button is first pushed down
action1 = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'start_x=curr_info(1,1);', ...
	'start_y=curr_info(1,2);', ...
	'prev_x=start_x;', ...
	'prev_y=start_y;', ...
	'[dist,index]=min(sqrt(sum(((ones(data_n,1)*[start_x start_y]-data(:, 1:2)).^2)'')));'...
	'if dist > 0.1,', ...
	'index = 0;', ...
	'end'];
% actions after the mouse is pushed down
action2 = ['if index ~= 0,', ...
	'curr_info=get(AxisH, ''currentPoint'');', ...
	'curr_x=curr_info(1,1);', ...
	'curr_y=curr_info(1,2);', ...
	'data(index,1) = data(index,1)+curr_x-prev_x;', ...
	'data(index,2) = data(index,2)+curr_y-prev_y;', ...
	'prev_x = curr_x;', ...
	'prev_y = curr_y;', ...
	'set(dataH(index), ''xdata'', data(index,1));', ...
	'set(dataH(index), ''ydata'', data(index,2));', ...
	'end'];
% action when button is released
action3 = [];

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));' ...
    action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);

% Make everything interruptible
set(findobj(FigH,'Interrupt','off'), 'Interrupt','on');

stop = 0;
stopH = uicontrol('string', 'Stop', 'callback', 'stop=1;', 'inter', 'on');

% The main loop
eta = 0.02;
wx = 1; wy = -1;
theta = 0;

i=0;
while ~stop,
	picked = ceil(rand*data_n);
	set(circleH, 'xdata', circle_x+data(picked, 1), ...
		'ydata', circle_y+data(picked, 2));
	input = data(picked, 1:2);
	target = data(picked, 3);
	perceptron_out = sign([wx wy]*input'+theta);
	if target ~= perceptron_out,
		wx = wx + eta*target*data(picked, 1);
		wy = wy + eta*target*data(picked, 2);
		theta = theta + eta*target;
%		fprintf('count = %d, wx = %f, wy = %f, theta = %f\n', ...
%			i, wx, wy, theta);
	end
	set(lineH, 'ydata', [(wx-theta), -wx-theta]/wy);
	drawnow
	i=i+1;
	if i>iterCount, break; end
end
