%% imFeaLbp
% Local binary pattern for images
%% Syntax
% * 		patchHist = imFeaLbp(im)
% * 		patchHist = imFeaLbp(im, opt)
% * 		patchHist = imFeaLbp(im, opt, showPlot)
% * 		[patchHist, lbpIm] = imFeaLbp(...)
%% Description
%
% <html>
% <p>patchHist = imFeaLbp(im, opt, showPlot) returns the aggregated patch histogram of LBP (local binary patterns)
% 	<ul>
% 	<li>im: Given image
% 	<li>opt: Options for LBP computation
% 		<ul>
% 		<li>opt.patchSideCount: The whole image is divided into patchSideCount(1)-by-patchSideCount(2) sub images
% 		<li>opt.weight: Weight for creating the LBP
% 		</ul>
% 	<li>showPlot: 1 for plotting the results
% 	</ul>
% <p>[patchHist, lbpIm] = imFeaLbp(...) returns the LBP image as well.
% </html>
%% Example
%%
%
im=imread('catPangPang.png');
opt=imFeaLbp('defaultOpt');
opt.patchSideCount=[5 3];
[patchHist, lbpIm]=imFeaLbp(im, opt, 1);
