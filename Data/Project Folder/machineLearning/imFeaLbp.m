function [patchHist, lbpIm, trimmedLbpIm] = imFeaLbp(im, opt, showPlot)
% lbp: Local binary pattern for images
%
%	Usage:
%		patchHist = imFeaLbp(im)
%		patchHist = imFeaLbp(im, opt)
%		patchHist = imFeaLbp(im, opt, showPlot)
%		[patchHist, lbpIm] = imFeaLbp(...)
%
%	Description:
%		patchHist = imFeaLbp(im, opt, showPlot) returns the aggregated patch histogram of LBP (local binary patterns)
%			im: Given image
%			opt: Options for LBP computation
%				opt.patchSideCount: The whole image is divided into patchSideCount(1)-by-patchSideCount(2) sub images
%				opt.weight: Weight for creating the LBP
%			showPlot: 1 for plotting the results
%		[patchHist, lbpIm] = imFeaLbp(...) returns the LBP image as well.
%
%	Example:
%		im=imread('catPangPang.png');
%		opt=imFeaLbp('defaultOpt');
%		opt.patchSideCount=[5 3];
%		[patchHist, lbpIm]=imFeaLbp(im, opt, 1);

%	Category: Image feature extraction
%	Roger Jang, 20120628

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')	% Set the default options
	patchHist.patchSideCount=[4, 3];
	patchHist.weight=2.^[0, 7, 6, 1, -inf, 5, 2, 3, 4];
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

patchSideCount=opt.patchSideCount;
if isscalar(patchSideCount), patchSideCount=patchSideCount*[1 1]; end

[h, w, dim]=size(im);
if dim>=3, im=rgb2gray(im); end

% === zero padding
I2=zeros(h+2, w+2);
I2(2:h+1,2:w+1)=im;
blk=im2col(I2, [3 3], 'sliding');		% 3*3block to one col
for i=1:size((blk),2)
	blk(:, i)=blk(:, i)-blk(5, i);		% 5: the center index of a 3x3 square
end
colSum=opt.weight*double(blk>0);
lbpIm=double(reshape(colSum, h, w));	% Image of LBP

% === Collect each block with patchSideCount size to histogram
subH=floor(h/patchSideCount(1));		% Height of the sub-window
subW=floor(w/patchSideCount(2));		% Width of the sub-window
% === Trim the image to avoid the default zero-padding for 'distinct';
trimmedLbpIm=lbpIm(1:subH*patchSideCount(1), 1:subW*patchSideCount(2));
lbpPatch=im2col(trimmedLbpIm, [subH, subW], 'distinct');
patchHist=zeros(256, patchSideCount(1)*patchSideCount(2));   % 256: count of histogram pins
for i=1:size(lbpPatch,2)
	patchHist(:,i)=hist(lbpPatch(:,i), 256);
end
patchHist=patchHist(:);

if showPlot
	subplot(1,2,1); imshow(im);
	subplot(1,2,2); imshow(lbpIm, []);
	for i=1:patchSideCount(1)
		for j=1:patchSideCount(2)
			bb{i,j}=[(j-1)*subW+0.5, (i-1)*subH+0.5, subW, subH];
			boxOverlay(bb{i,j}, getColor((j-1)*patchSideCount(1)+i), 2);
		end
	end
	figure;
	for i=1:patchSideCount(1)
		for j=1:patchSideCount(2)
			k=(i-1)*patchSideCount(2)+j;
			subplot(patchSideCount(1), patchSideCount(2), k);
			hist(lbpPatch(:, k), 256); axis tight
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);