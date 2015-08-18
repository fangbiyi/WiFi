%% vecQuantize
% Vector quantization using LBG method of center splitting
%% Syntax
% * 		center=vecQuantize(data, codeBookSize)
% * 		center=vecQuantize(data, codeBookSize, showPlot)
% * 		[center, U]=vecQuantize(data, codeBookSize, ...)
% *        [center, U, centerHistory]=vecQuantize(data, codeBookSize, ...)
%% Description
%
% <html>
% <p>center=vecQuantize(data, codeBookSize) returns the centers (codebook) of k-means via LBG method, where
% 	<ul>
% 	<li>data: data matrix where each column is an observation
% 	<li>codeBookSize: codebook size or number of cluster centers (should be the power of 2)
% 	<li>center: codebook matrix where each column is a codeword
% 	</ul>
% <p>center=vecQuantize(data, codeBookSize, 1) display the animation and messages during training.
% <p>[center, U]=vecQuantize(data, codeBookSize, ...) returns extra info of the partition matrix U.
% </ul>
% </ul>
% <li>       [center, U, centerHistory]=vecQuantize(data, codeBookSize, ...) returns extra info of all the centers after each iteration.
% </html>
%% References
% # 		Y. Linde, A. Buzo, and R.M. Gray, "An Algorithm for Vector Quantizer Design", IEEE Transactions on Communications, vol. 28, pp. 84-94, 1980.
%% Example
%%
%
DS=dcData(2);
data=DS.input;
codeBookSize=2^5;
showPlot=1;
codebook=vecQuantize(data, codeBookSize, showPlot);
%% See Also
% <kMeansClustering_help.html kMeansClustering>,
% <vqDataPlot_help.html vqDataPlot>.
