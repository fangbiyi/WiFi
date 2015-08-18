%% planeFitViaTls
% 
%% Syntax
% * 		coef=planeFitViaTls(data, showPlot)
%% Description
% 		coef=planeFitViaTls(data) returns the hyperplane coef'*[x_1, x_2, ..., x_d, 1]=0 which achieves total least-squares via PCA (principal component analysis).
%% Example
%%
% Line fitting
x=[1.44  2.27  4.12  3.04  5.13  7.01  7.01 10.15  8.30  9.88];
y=[8.20 11.12 14.31 17.78 17.07 21.95 25.11 30.19 30.95 36.05];
data=[x; y];
coef=planeFitViaTls(data, 1);
%%
% Plane fitting
x=10*rand(1,100)-5;
y=10*rand(1,100)-5;
z=x+2*y+3+randn(size(x));
data=[x; y; z];
figure; coef=planeFitViaTls(data, 1);
%% See Also
% <PCA_help.html PCA>.
