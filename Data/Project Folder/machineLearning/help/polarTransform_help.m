%% polarTransform
% Polar transformation of an image
%% Syntax
% * 		I2=polarTransform(I, rNum, tNum, plotOpt)
%% Description
%
% <html>
% <p>I2=polarTransform(I, rNum, tNum) returns the polar transformation
% <p>of the input image I, with radial resolution of rNum and angle
% <p>resolution of tNum. The origin is the center of the image. X axis
% <p>is the row index, Y axis is the column index. And theta=0 is the
% <p>vector pointing download when the image is displayed using "image"
% <p>command (ij mode).
% </html>
%% Example
%%
%
I=reshape([4 5 2 3 6 1], 2, 3);
rNum=80;
tNum=90;
plotOpt=1;
I2=polarTransform(I, rNum, tNum, plotOpt);
%% See Also
% <distPairwise_help.html distPairwise>.
