%condDm: Demo of the condensing technique for data count reduction
%
% Category: Data count reduction
% Roger Jang, 9703xx, 990613, 20110212

usePause = 1;
% Collect 2500 data points
[xx, yy, zz] = peaks(50);
x = xx(:); y = yy(:); z = zz(:);
axisLimit = [min(x) max(x) min(y) max(y)];
threshold = 0.5;
dataNum = length(x);

% Plot these 2500 data points and the contour
%index2 = 1:dataNum;
%index1 = find(z > threshold);
%index2(index1) = [];
%h = plot(x(index1), y(index1), 'y.', x(index2), y(index2), 'c.');
%set(h, 'markersize', 10);
%hold on
%[c, contourH] = contour(xx, yy, zz, [threshold threshold]);
%set(contourH, 'linewidth', 2, 'color', 'g');
%hold off
%axis(axisLimit);
%axis square;

% Randomly selected 500 data points
dataNum = 500;
tmp = randperm(length(x));
index = tmp(1:dataNum);
x = x(index); y = y(index); z = z(index);

index2 = 1:dataNum;
index1 = find(z > threshold)';
index2(index1) = [];
figure;
% Plot a single contour as the decision boundary
[c, contourH] = contour(xx, yy, zz, [threshold threshold], 'm-');
set(contourH, 'linewidth', 2, 'erase', 'xor');
axis(axisLimit); axis square;
pointH = zeros(dataNum,1);
textH = zeros(dataNum,1);
for i=1:dataNum,
	pointH(i) = line(x(i), y(i), 'color', 'g', 'erase', 'xor', 'linestyle', '.', 'markersize', 10);
	textH(i) = text(x(i), y(i), num2str(i), 'fontsize', 8, 'erase', 'xor', 'visible', 'off');
end
% Set the color of class-2 points
for i = index2,
	set(pointH(i), 'color', 'b');
end

% Circles to display picked points and it's nearest neighbor
r1 = 0.2;
r2 = 0.2;
theta = linspace(0, 2*pi);
circle_x = cos(theta); 
circle_y = sin(theta); 
circle1H = line(nan, nan, 'color', 'r', 'erase', 'xor');
circle2H = line(nan, nan, 'color', 'k', 'erase', 'xor');
title('Red circle: picked, black circle: nearest');

% All data points
output = z>threshold;
data = [x y output];
% Calcualte distance matrix of all data points
distMat = distPairwise([x'; y']);
% Add a big number to the diagonal elements of the distance matrix
distMat = distMat + diag(realmax*ones(dataNum,1));
currentData = 1:dataNum;
% Condense the data set
for i = 1:2*dataNum,
	% randomly picked a data point
	index=floor(rand*length(currentData))+1;
	picked = currentData(index);
	% find the nearest data point to the picked
	[junk, nearest] = min(distMat(picked, :));
	% delete a point if the picked and the nearest are in the same class
	if output(picked) == output(nearest),
		ind = find(output~=output(picked));
		dist1 = min(distMat(picked, ind));
		dist2 = min(distMat(nearest, ind));
		if dist1 > dist2,
			toDelete = picked;
		else
			toDelete = nearest;
		end
	%	fprintf('deleting point %d ...\n', toDelete);
		set(circle1H, 'xdata', r1*circle_x+x(picked), ...
			'ydata', r1*circle_y+y(picked));
		set(circle2H, 'xdata', r2*circle_x+x(nearest), ...
			'ydata', r2*circle_y+y(nearest));
		if usePause, fprintf('Hit any key to go on...\n'); pause; end
		distMat(toDelete, :) = realmax*ones(1, dataNum);
		distMat(:, toDelete) = realmax*ones(dataNum, 1);
		delete(pointH(toDelete));
		delete(textH(toDelete));
		currentData(find(currentData==toDelete)) = [];
		set(circle1H, 'xdata', nan, 'ydata', nan);
		set(circle2H, 'xdata', nan, 'ydata', nan);
		drawnow
	end
end
