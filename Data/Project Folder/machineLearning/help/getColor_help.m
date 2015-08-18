%% getColor
% Get a color from a palette
%% Syntax
% * 		color=getColor(index)
%% Description
%
% <html>
% <p>color=getColor(index) return a color (in a string) from a palette based on the given index.
% <p>color=getColor(index) return a color in the format a RGB vector.
% </html>
%% Example
%%
%
for i=1:6
	line(1:10, rand(1, 10), 'color', getColor(i), 'lineWidth', 3);
end
legend('Color 1', 'Color 2', 'Color 3', 'Color 4', 'Color 5', 'Color 6');
