%% distLpNorm
% Lp norm of a vector
%% Syntax
% * 		out=distLpNorm(vec, p)
%% Description
%
% <html>
% <p>out=distLpNorm(x, p) returns the Lp norm of a given vector x.
% 	<ul>
% 	<li>x: a column vector or a matrix
% 	<li>p: a parameter between 0 and infinity
% 	</ul>
% <p>If x is a matrix, then Lp norm is applied to each column vector.
% </html>
%% Example
%%
%
vec=[3; 4];
fprintf('distLpNorm([3; 4], 1) = %f\n', distLpNorm(vec, 1));
fprintf('distLpNorm([3; 4], 2) = %f\n', distLpNorm(vec, 2));
fprintf('distLpNorm([3; 4], inf) = %f\n', distLpNorm(vec, inf));
