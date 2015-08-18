%% polyFitPiecewise
% Piecewise polynomial fit (with 2 polynomials)
%% Syntax
% * 		[coef1, coef2, minError]=polyFitPiecewise(x, y, order, plotOpt)
%% Description
%
% <html>
% <p>[minError, minIndex, coef1, coef2]=polyFitPiecewise(x, y, order, plotOpt) returns the results of piecewise polynomial fitting
% <p>with two polynomials.
% </html>
%% Example
%%
%
x=sort(rand(100, 1));
x1=x(1:40); x2=x(41:end);
y1=1+2*x1+rand(40,1)/5; y2=3-3*x2+rand(60,1)/5;
y=[y1; y2];
order=1;
[minError, minIndex, coef1, coef2]=polyFitPiecewise(x, y, order, 1);
%% See Also
% <polyfit_help.html polyfit>.
