function [fn, fp]=detPlot(data1, data2, scaleMode)
% detPlot: DET (Detection Error Tradeoff) plot for classification analysis of a single feature.
%
%	Usage:
%		detPlot(data1, data2)
%		detPlot(data1, data2, scaleMode)
%
%	Description:
%		|detPlot(data1, data2)| plots the DET (Detection Error Tradeoff) curve for classification analysis of
%		a single feature. The default axis scale is linear.
%		If log-scale is desired, use |detPlot(data1, data2, 'log')| instead.
%
%	Example:
%		data1=randn(1,300)-1;
%		data2=randn(1,300)+1;
%		subplot(1,2,1);
%		detPlot(data1, data2);
%		subplot(1,2,2);
%		detPlot(data1, data2, 'log');
%
%	See also detGet.
%
%	Reference:
%		A. Martin, G. Doddington, T. Kamm, M. Ordowski, and M. Przybocki, "The DET curve in assessment of detection task performance," in Proceedings of Eurospeech, Rhodes, Greece, 1997, pp. 1895-1898.

%	Category: Classification analysis
%	Roger Jang, 20061025, 20100728

if nargin<1, selfdemo; return; end
if nargin<3, scaleMode='linear'; end

[th, fp, fn, gPrm1, gPrm2, a, b, ths, fps, fns]=detGet(data1, data2);

plot(fps*100, fns*100, '.-');
set(gca, 'xscale', scaleMode, 'yscale', scaleMode);
xlabel('False-positive rate (%)');
ylabel('False-negative rate (%)');
title(sprintf('DET curve (%s mode)', scaleMode)); 

[junk, id(1)]=min(abs(fns-fps));
[junk, id(2)]=min(abs(5*fns-fps));
[junk, id(3)]=min(abs(fns-5*fps));
for i=1:length(id);
	index=id(i);	
	th=ths(index);
	line(fps(index)*100, fns(index)*100, 'color', 'r', 'marker', 'o');
	text(fps(index)*100, fns(index)*100, sprintf('  \\theta=%.2f (fp=%.2f%%, fn=%.2f%%)', th, 100*fps(index), 100*fns(index)));
end
axis square, grid on

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
