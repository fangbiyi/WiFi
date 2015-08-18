function [th, fp, fn, gPrm1, gPrm2, a, b, ths, fps, fns]=detGet(data1, data2, method, prior, plotOpt);
%detGet: DET (Detection Error Tradeoff) data generation
%
%	Usage:
%		[th, fp, fn, gPrm1, gPrm2, a, b]=detGet(data1, data2, method, prior, plotOpt);
%
%	Description:
%		[th, fp, fn, gPrm1, gPrm2, a, b]=detGet(data1, data2, method, prior, plotOpt) returns the parameters for DET plot.
%			data1: vector for data of negative set
%			data2: vector for data of positive set
%			method: method for computing threshold that minimizes FP+FN
%				method=1: FP = (count of FP cases)/(count of all data); FN is defined similarly.
%				method=2: FP = (count of FP cases)/(total negative case count); FN is defined similarly.
%			th: threhold (using Baysian rule where priors are multiplied)
%			fp: false positive error rate (using Baysian rule where priors are multiplied)
%			fn: false negative error rate (using Baysian rule where priors are multiplied)
%			gPrm1: mu and sigma of class 1
%			gPrm2: mu and sigma of class 2
%			a, b: the fitting parameters of y=1/(1+exp(-a*(x-b))) for class-2 conditional probability (priors are multiplied)
%
%	Example:
%		data1=randn(1,100)/2+1;
%		data2=randn(1,100)+3;
%		method=2;
%		prior=[length(data1), length(data2)];
%		[th, fp, fn]=detGet(data1, data2, method, prior, 1);
%
%	See also detPlot.
%
%	Reference:
%		A. Martin, G. Doddington, T. Kamm, M. Ordowski, and M. Przybocki, "The DET curve in assessment of detection task performance,", in Proceedings of Eurospeech, Rhodes, Greece, 1997, pp. 1895¡V1898.

%	Category: Classification analysis
%	Roger Jang, 20050717, 20090721

if nargin<1, selfdemo; return; end
if nargin<3, method=1; end
if nargin<4, prior=[length(data1), length(data2)]; end
if nargin<5, plotOpt=0; end

if isempty(method), method=1; end
if isempty(prior), prior=[length(data1), length(data2)]; end

n1=prior(1); n2=prior(2);
allData=[data1(:); data2(:)]';
range=max(allData)-min(allData);
dataNum=length(allData);
if dataNum>1001
	ths=linspace(min(allData)-range/100, max(allData)+range/100, 1001);
else
	sorted=sort(allData);
	ths=([sorted(1)-range/100, sorted]+[sorted, sorted(end)+range/100])/2;
end

% ===== Compute th1, which minimize total numbers of FP & FN
fps=0*ths;
fns=0*ths;
for i=1:length(ths);
	th=ths(i);
	switch(method)
		case 1
			fps(i)=sum(data1>=th)/dataNum;
			fns(i)=sum(data2< th)/dataNum;
		case 2
			fps(i)=sum(data1>=th)/length(data1);
			fns(i)=sum(data2< th)/length(data2);
		otherwise
			error('Unknown method!');
	end
end
[minValue, minIndex]=min(fps+fns);
index=find((fps+fns)==minValue);	 % Check if there is more than one minValue
if length(index)>1	% If there is more than one minValue (usually a plateau of perfect separation), taking weighted average
	start=ths(index(1));
	stop=ths(index(end));
	w1=sum(abs(start-data1));
	w2=sum(abs(data2-stop));
	minIndex=round((w1*index(end)+w2*index(1))/(w1+w2));
end
fp=fps(minIndex);
fn=fns(minIndex);
th=ths(minIndex);
% ===== Compute th2, which minimize [(FP count)/(total negative case count) + (FN count)/(total positive case count)]

% Compute PDF
gPrm1=gaussianMle(data1);
gPrm2=gaussianMle(data2);
x=linspace(min([data1, data2]), max([data1, data2]), 101);
g1=gaussian(x, gPrm1);
g2=gaussian(x, gPrm2);
% Compute a & b for scoring function s = 1/(1+exp(-a*(x-b))
b=th;
A=x(:)-b;
y=n2*g2./(n1*g1+n2*g2);
y(y==0)=eps;
y(y==1)=1-eps;
B=log(y./(1-y));
a=A(:)\B(:);

if plotOpt
	total=fns+fps;
	[minValue, minIndex]=min(total);
	th=ths(minIndex);
	
	subplot(2,2,1);
	plot(data1, zeros(size(data1)), 'ob', data2, ones(size(data2)), 'squarer');
	set(gca, 'xlim', [min(ths), max(ths)]);
	axisLimit=axis; line(th*[1 1], axisLimit(3:4), 'color', 'm');
	title(sprintf('n_1(negative data count)=%d, n_2(positive data count)=%d, \\mu_1=%.2f, \\mu_2=%.2f', n1, n2, mean(data1), mean(data2)));
	ylabel('Class');
	legend('data1 (negative data)', 'data2 (positive data)', sprintf('\\theta=%f\n', th), 'location', 'NorthEast'); grid on

	subplot(2,2,2);
	plot(x, n1*g1, 'o-b', x, n2*g2, 'square-r');
	set(gca, 'xlim', [min(ths), max(ths)]);
	absDiff1=abs(n1*g1-n2*g2);
	line(x, absDiff1, 'color', 'k');
	axisLimit=axis; line(th*[1 1], axisLimit(3:4), 'color', 'm');
	title('n_1g_1 and n_2g_2');
	ylabel('Count*PDF')
	legend('n_1g_1', 'n_2g_2', 'abs(n_1g_1-n_2g_2)', sprintf('\\theta=%f\n', th), 'location', 'NorthEast'); grid on

	subplot(2,2,3);
	plot(x, n1*g1./(n1*g1+n2*g2), 'o-b', x, n2*g2./(n1*g1+n2*g2), 'square-r');
	set(gca, 'xlim', [min(ths), max(ths)]);
	absDiff2=abs(n1*g1./(n1*g1+n2*g2)-n2*g2./(n1*g1+n2*g2));
	line(x, absDiff2, 'color', 'k');
	axisLimit=axis; line(th*[1 1], axisLimit(3:4), 'color', 'm');
	line(x, 1./(1+exp(-a*(x-b))), 'color', 'g', 'linewidth', 2);		% Plot the score curve
	title('n_1g_1/(n_1g_1+n_2g_2) and n_2g_2/(n_1g_1+n_2g_2)');
	ylabel('Normalized PDF')
	legend('n_1g_1/(n_1g_1+n_2g_2)', 'n_2g_2/(n_1g_1+n_2g_2)', 'abs diff', sprintf('\\theta=%f\n', th), 'location', 'NorthEast'); grid on
	
	subplot(2,2,4);
	plot(ths, [fns', fps', total'], '.-')
	set(gca, 'xlim', [min(ths), max(ths)]);
	axisLimit=axis; line(th*[1 1], axisLimit(3:4), 'color', 'm');
	title('FN & FP curves');
	xlabel(sprintf('\\theta=%f, min fn+fp=%g%% (fn=%g%%, fp=%g%%)\n', ths(minIndex), minValue*100, fns(minIndex)*100, fps(minIndex)*100));
	legend('FN', 'FP', 'FN+FP', sprintf('\\theta=%f\n', th), 'location', 'NorthEast');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
