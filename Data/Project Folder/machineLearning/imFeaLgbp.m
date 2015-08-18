function [patchHist, LGBP_im] = imFeaLgbp(im, opt, showPlot)
% imFeaLgbp: Local Gabor binary pattern for images
%
%	Usage:
%		patchHist = imFealgbp(im)
%		patchHist = imFeaLgbp(im, opt)
%		patchHist = imFeaLgbp(im, opt, showPlot)
%		[patchHist, lbpIm] = imFeaLgbp(...)
%
%	Description:
%		patchHist = imFeaLbp(im, opt, showPlot) returns the aggregated patch histogram of LGBP (local Gabor binary patterns)
%			im: Given image
%			opt: Options for LGBP computation
%				patchHist.orientation = 8;		%%  Gabor Orientation
%				patchHist.scale = 5;			%%  Gabor Scale
%				patchHist.mask = [32 32];		%%  Gabor Mask
%				patchHist.blockSize = 8;		%%  LBP Blocksize
%			showPlot: 1 for plotting the results
%		[patchHist, lbpIm] = imFeaLgbp(...) returns the LBP image as well.
%
%	Example:
%		im=imread('catPangPang.png');
%		opt=imFeaLgbp('defaultOpt');
%		[patchHist, lbpIm]=imFeaLgbp(im, opt, 1);

%	Category: Image feature extraction
%	Roger Jang, 20120628

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')	% Set the default options
	patchHist.orientation = 8;		%%  Gabor Orientation
	patchHist.scale = 5;			%%  Gabor Scale
	patchHist.mask = [32 32];		%%  Gabor Mask
	patchHist.blockSize = 8;		%%  LBP Blocksize
	return
end
if nargin<2||isempty(opt), patchHist=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

%% RGB to Gray Scale
[h, w, dimension] = size(im);
if (dimension >= 3)
    im = rgb2gray(im);
end

if (~isa(im, 'double')) 
    im = double(histeq(im)); 
end
%% run Gabor function
gabor_output = gabor2(im, opt.orientation, opt.scale, opt.mask);
patchHist = [];

%% Transform  Gabor feature to LBP ¡÷ LGBP
for u = 1:opt.orientation
	for v = 1:opt.scale
		[tmp, LGBP_im{u,v}] = LBP2(gabor_output{u,v}, opt.blockSize);
		patchHist = [patchHist tmp'];
	end
end

%% ( dimension * 1 ) for one image as one column
patchHist = patchHist';  %% dimension * 1 for one image as one column

if showPlot	% Show LGBP image
	for i = 1:opt.orientation
		for j = 1:opt.scale                        
			subplot(opt.orientation, opt.scale,(i-1)*opt.scale+j);     
			imshow(LGBP_im{i,j},[]);
		end
	end
	ax=axes('Units','Normal','Position',[.075 .075 .85 .85],'Visible','off');
	set(get(ax,'Title'),'Visible','on')
	title('LGBP Images', 'FontSize', 16);        
end
	
% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
