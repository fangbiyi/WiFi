%% lda
% Linear discriminant analysis
%% Syntax
% * 		DS2 = lda(DS)
% * 		DS2 = lda(DS, discrimVecNum)
% * 		[DS2, discrimVec, eigValues] = lda(...)
%% Description
%
% <html>
% <p>DS2 = lda(DS, discrimVecNum) returns the results of LDA (linear discriminant analysis) on DS
% 	<ul>
% 	<li>DS: input dataset (Try "DS=prData('iris')" to get an example of DS.)
% 	<li>discrimVecNum: No. of discriminant vectors
% 	<li>DS2: output data set, with new feature vectors
% 	</ul>
% <p>[DS2, discrimVec, eigValues] = lda(DS, discrimVecNum) returns extra info:
% 	<ul>
% 	<li>discrimVec: discriminant vectors identified by LDA
% 	<li>eigValues: eigen values corresponding to the discriminant vectors
% 	</ul>
% </html>
%% References
% # 		[1] J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
%% Example
%%
% Scatter plots of the LDA projection
DS=prData('wine');
DS2=lda(DS);
DS12=DS2; DS12.input=DS12.input(1:2, :);
subplot(1,2,1); dsScatterPlot(DS12); xlabel('Input 1'); ylabel('Input 2');
title('Wine dataset projected on the first 2 LDA vectors');
DS34=DS2; DS34.input=DS34.input(end-1:end, :);
subplot(1,2,2); dsScatterPlot(DS34); xlabel('Input 3'); ylabel('Input 4');
title('Wine dataset projected on the last 2 LDA vectors');
%%
% Leave-one-out accuracy of the projected dataset using KNNC
fprintf('LOO accuracy of KNNC over the original wine dataset = %g%%\n', 100*perfLoo(DS, 'knnc'));
fprintf('LOO accuracy of KNNC over the wine dataset projected onto the first two LDA vectors = %g%%\n', 100*perfLoo(DS12, 'knnc'));
fprintf('LOO accuracy of KNNC over the wine dataset projected onto the last two LDA vectors = %g%%\n', 100*perfLoo(DS34, 'knnc'));
%% See Also
% <ldaPerfViaKnncLoo_help.html ldaPerfViaKnncLoo>.
