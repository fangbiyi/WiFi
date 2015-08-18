function dist=distLinScaling(x1, x2, plotOpt)
%distLinScaling: Distance via linear scaling
%
%	Usage:
%		dist=distLinScaling(x1, x2, plotOpt)
%
%	Description:
%		dist=distLinScaling(x1, x2) returns the Eucliden distance between x1 and x2 based on interpolating x2 to match the length of x1.
%
%	Example:
%		x1=rand(2, 20);
%		x2=rand(2, 10);
%		dist=distLinScaling(x1, x2, 1);

%	Category: Distance and similarity
%	Roger Jang, 20110114

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

[m1, n1]=size(x1);
[m2, n2]=size(x2);

if m1~=m2
	error('Size mismatch!');
end

% ====== Interpolation based on x1
xi=linspace(1, n2, n1);
interpolatedX2=interp1(1:n2, x2', xi)';
diff=x1-interpolatedX2;
dist=sqrt(sum(sum(diff.^2))/(m1*n1));

if plotOpt
	subplot(2,1,1); plot(1:n1, x1', '.-'); set(gca, 'xlim', [-inf inf]);
	title('x1');
	subplot(2,1,2); plot(1:n2, x2', '.-', xi, interpolatedX2', '.-'); set(gca, 'xlim', [-inf inf]);
	title('x2 and interpolated x2');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
