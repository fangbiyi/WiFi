function out = buffer2(y, frameSize, overlap)
% BUFFER2 Frame blocking
%	This is almost the same as "buffer" except that there is no leading zeros

%	Roger Jang, 20010908

if nargin<3, overlap=0; end
if nargin<2, frameSize=256; end

y = y(:);
step = frameSize-overlap;
frameCount = floor((length(y)-overlap)/step);

out = zeros(frameSize, frameCount);
for i=1:frameCount,
	startIndex = (i-1)*step+1;
	out(:, i) = y(startIndex:(startIndex+frameSize-1));
end