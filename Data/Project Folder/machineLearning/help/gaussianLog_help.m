%% gaussianLog
% Multi-dimensional log Gaussian propability density function
%% Syntax
% * 		out = gaussianLog(data, gPrm, gConst)
%% Description
%
% <html>
% <p>out=gaussianLog(data, gPrm) return the log likelihood of given data over Gaussian PDF with parameter gPrm.
% 	<ul>
% 	<li>data: d x n data matrix, representing n data vector of dimension d
% 	<li>mu: d x 1 vector
% 	<li>sigma: d x d covariance matrix
% 		<ul>
% 		<li>d x 1 vector
% 		<li>1 x 1 scalar
% 		</ul>
% 	<li>out: 1 x n vector of log likelihood
% 	</ul>
% </html>
%% Example
%%
%
x = linspace(-10, 10);
gPrm.mu = 0;
gPrm.sigma = 0.1;
y1 = log(gaussian(x, gPrm));
y2 = gaussianLog(x, gPrm);
difference = abs(y1-y2);
subplot(2,1,1); plot(x, y1, x, y2); title('Curves of log(gaussian()) and gaussianLog()');
subplot(2,1,2); plot(x, difference); title('Diff. between log(gaussian()) and gaussianLog()');
%% See Also
% <gaussian_help.html gaussian>,
% <gaussianMle_help.html gaussianMle>.
