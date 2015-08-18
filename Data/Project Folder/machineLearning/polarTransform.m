function I2=polarTransform(I, rNum, tNum, plotOpt)
% polarTransform: Polar transformation of an image
%
%	Usage:
%		I2=polarTransform(I, rNum, tNum, plotOpt)
%
%	Description:
%		I2=polarTransform(I, rNum, tNum) returns the polar transformation
%		of the input image I, with radial resolution of rNum and angle
%		resolution of tNum. The origin is the center of the image. X axis
%		is the row index, Y axis is the column index. And theta=0 is the
%		vector pointing download when the image is displayed using "image"
%		command (ij mode).
%
%	Example:
%		I=reshape([4 5 2 3 6 1], 2, 3);
%		rNum=80;
%		tNum=90;
%		plotOpt=1;
%		I2=polarTransform(I, rNum, tNum, plotOpt);
%
%	See also distPairwise.

%	Category: Coordinate transform
%	Roger Jang, 20110219.

if nargin<1, selfdemo; return; end
if nargin<2, rNum=80; end
if nargin<3, tNum=90; end
if nargin<4, plotOpt=0; end

[m, n]=size(I);
center=([m,n]+1)/2;
[xx, yy]=meshgrid(1:m, 1:n);
maxR=norm([m,n]-center);
r=linspace(0, maxR, rNum);
t=linspace(0, 2*pi, tNum+1); t(end)=[];		% 0 and 2*pi are the same.
[rr, tt]=meshgrid(r, t);
xx2=rr.*cos(tt);
yy2=rr.*sin(tt);
I2=interp2(xx-center(1), yy-center(2), I', xx2, yy2)';

if plotOpt
	subplot(1,2,1); imagesc(I), axis image; colorbar;
	xlabel('y'); ylabel('x');
	subplot(1,2,2); imagesc(I2); axis image; colorbar;
	xlabel('theta'); ylabel('r');
end

% ====== Selfdemo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
