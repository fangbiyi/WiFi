%% distLinScaling
% Distance via linear scaling
%% Syntax
% * 		dist=distLinScaling(x1, x2, plotOpt)
%% Description
% 		dist=distLinScaling(x1, x2) returns the Eucliden distance between x1 and x2 based on interpolating x2 to match the length of x1.
%% Example
%%
%
x1=rand(2, 20);
x2=rand(2, 10);
dist=distLinScaling(x1, x2, 1);
