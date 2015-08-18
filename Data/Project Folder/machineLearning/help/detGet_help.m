%% detGet
% DET (Detection Error Tradeoff) data generation
%% Syntax
% * 		[th, fp, fn, gPrm1, gPrm2, a, b]=detGet(data1, data2, method, prior, plotOpt);
%% Description
%
% <html>
% <p>[th, fp, fn, gPrm1, gPrm2, a, b]=detGet(data1, data2, method, prior, plotOpt) returns the parameters for DET plot.
% 	<ul>
% 	<li>data1: vector for data of negative set
% 	<li>data2: vector for data of positive set
% 	<li>method: method for computing threshold that minimizes FP+FN
% 		<ul>
% 		<li>method=1: FP = (count of FP cases)/(count of all data); FN is defined similarly.
% 		<li>method=2: FP = (count of FP cases)/(total negative case count); FN is defined similarly.
% 		</ul>
% 	<li>th: threhold (using Baysian rule where priors are multiplied)
% 	<li>fp: false positive error rate (using Baysian rule where priors are multiplied)
% 	<li>fn: false negative error rate (using Baysian rule where priors are multiplied)
% 	<li>gPrm1: mu and sigma of class 1
% 	<li>gPrm2: mu and sigma of class 2
% 	<li>a, b: the fitting parameters of y=1/(1+exp(-a*(x-b))) for class-2 conditional probability (priors are multiplied)
% 	</ul>
% </html>
%% References
% # 		A. Martin, G. Doddington, T. Kamm, M. Ordowski, and M. Przybocki, "The DET curve in assessment of detection task performance,", in Proceedings of Eurospeech, Rhodes, Greece, 1997, pp. 1895¡V1898.
%% Example
%%
%
data1=randn(1,100)/2+1;
data2=randn(1,100)+3;
method=2;
prior=[length(data1), length(data2)];
[th, fp, fn]=detGet(data1, data2, method, prior, 1);
%% See Also
% <detPlot_help.html detPlot>.
