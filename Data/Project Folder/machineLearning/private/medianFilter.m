function out = medianFilter(in, order, plotOpt)
%medianFilter: Median filter for a given filter
%
%	Usage:
%		outputVec = medianFilter(inputVec, order)
%
%	Example:
%		n=20;
%		vec=round(10*rand(1, n));
%		subplot(2,1,1); out1=medianFilter(vec, 3, 1);
%		subplot(2,1,2); out2=medianFilter(vec, 5, 1);

%	Roger Jang, 20040424, 20130418

if nargin<1, selfdemo; return; end
if nargin<2, order=3; end
if nargin<3, plotOpt=0; end

if mod(order,2)~=1, error('Given order (%d) in %s.m must be an odd number!', order, mfilename); end

[m, n]=size(in);
out=in;
side=fix(order/2);
if (m==1)|(n==1)	% input is a vector
	for i=(side+1):length(in)-side
		out(i)=median(in((i-side):(i+side)));
	end
	% ====== Take care of boundaries
	for i=1:side, out(i)=out(side+1); end
	for i=length(in)-side+1:length(in), out(i)=out(length(out)-side); end
else			% input is a matrix
	for i=1:n
		out(:,i)=medianFilter(out(:,i), order);
	end
end

if plotOpt
	plot(1:length(in), in, '-o', 1:length(out), out, '-o');
	legend('Original', ['Order=', num2str(order)]); 
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
