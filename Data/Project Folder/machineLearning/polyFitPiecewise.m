function [minError, minIndex, coef1, coef2]=polyFitPiecewise(x, y, order, plotOpt)
% polyFitPiecewise: Piecewise polynomial fit (with 2 polynomials)
%
%	Usage:
%		[coef1, coef2, minError]=polyFitPiecewise(x, y, order, plotOpt)
%
%	Description:
%		[minError, minIndex, coef1, coef2]=polyFitPiecewise(x, y, order, plotOpt) returns the results of piecewise polynomial fitting
%		with two polynomials.
%
%	Example:
%		x=sort(rand(100, 1));
%		x1=x(1:40); x2=x(41:end);
%		y1=1+2*x1+rand(40,1)/5; y2=3-3*x2+rand(60,1)/5;
%		y=[y1; y2];
%		order=1;
%		[minError, minIndex, coef1, coef2]=polyFitPiecewise(x, y, order, 1);
%
%	See also polyfit.

%	Category: Interpolation and regression
%	Roger Jang, 20091117

if nargin<1, selfdemo; return; end
if nargin<3, order=1; end
if nargin<4, plotOpt=0; end

n=length(x);
error=inf*ones(n, 1);
start=order+1;
stop=n-order-1;
for i=start:stop
	x1=x(1:i); y1=y(1:i);
	coef1=polyfit(x1, y1, order);
	error1=sum(abs(polyval(coef1, x1)-y1));
	x2=x(i+1:end); y2=y(i+1:end);
	coef2=polyfit(x2, y2, order);
	error2=sum(abs(polyval(coef2, x2)-y2));
	error(i)=error1+error2;
end

[minError, minIndex]=min(error);
x1=x(1:minIndex); y1=y(1:minIndex); coef1=polyfit(x1, y1, order);
x2=x(minIndex+1:end); y2=y(minIndex+1:end); coef2=polyfit(x2, y2, order);

if plotOpt
	plot(x1, y1, '.', x2, y2, '.');
	x1hat=linspace(min(x1), max(x1)); y1hat=polyval(coef1, x1hat);
	x2hat=linspace(min(x2), max(x2)); y2hat=polyval(coef2, x2hat);
	line(x1hat, y1hat, 'color', 'r', 'linewidth', 2);
	line(x2hat, y2hat, 'color', 'm', 'linewidth', 2);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
