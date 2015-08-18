%% ldaPerfViaKnncLoo
% LDA recognition rate via KNNC and LOO performance index
%% Syntax
% * 		recogRate=ldaPerfViaKnncLoo(DS)
% * 		recogRate=ldaPerfViaKnncLoo(DS, opt)
% * 		recogRate=ldaPerfViaKnncLoo(DS, opt, plotOpt)
% * 		[recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(...);
%% Description
%
% <html>
% <p>recogRate=ldaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using LDA (linear discriminant analysis)
% 	<ul>
% 	<li>DS: the dataset
% 	</ul>
% <p>recogRate=ldaPerfViaKnncLoo(DS, opt) uses LDA with the option opt:
% 	<ul>
% 	<li>opt.maxDim: Use this value as the max. dimensions after LDA projection
% 	<li>opt.mode:
% 		<ul>
% 		<li>'approximate' (default) for approximate evaluation which uses all dataset for LDA project
% 		<li>'exact' for true leave-one-out test, which takes longer
% 		</ul>
% 	</ul>
% <p>The default value of option can be obtained by ldaPerfViaKnncLoo('defaultOpt').
% <p>recogRate=ldaPerfViaKnncLoo(DS, opt, 1) plots the recognition rates w.r.t. dimensions after LDA transformation.
% </html>
%% Example
%%
% Using LDA over WINE dataset
DS=prData('wine');
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='approximate';
recogRate1=ldaPerfViaKnncLoo(DS, opt, 1);
%%
% Compare two mode of LDA performance evaluation via KNNC-LOO
DS=prData('wine');
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='approximate';
tic; recogRate1=ldaPerfViaKnncLoo(DS, opt); time1=toc;
opt.mode='exact';
tic; recogRate2=ldaPerfViaKnncLoo(DS, opt); time2=toc;
plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
xlabel('No. of projected features based on LDA');
ylabel('LOO recognition rates using KNNC (%)');
legend('mode=''approximate''', 'mode=''exact''', 'location', 'southwest');
fprintf('time1=%g sec, time2=%g sec\n', time1, time2);
%%
% Effect of input normalization of LDA over WINE dataset
DS=prData('wine');
recogRate1=ldaPerfViaKnncLoo(DS, opt);
DS.input=inputNormalize(DS.input);
recogRate2=ldaPerfViaKnncLoo(DS);
plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
xlabel('No. of projected features based on LDA');
ylabel('LOO recognition rates using KNNC (%)');
legend('Without input normalization', 'With input normalization', 'location', 'southwest');
%% See Also
% <lda_help.html lda>.
