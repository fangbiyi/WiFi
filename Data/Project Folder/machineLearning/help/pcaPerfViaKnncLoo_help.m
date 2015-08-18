%% pcaPerfViaKnncLoo
% PCA analysis using KNNC and LOO
%% Syntax
% * 		recogRate=pcaPerfViaKnncLoo(DS)
% * 		recogRate=pcaPerfViaKnncLoo(DS, [], plotOpt)
% * 		recogRate=pcaPerfViaKnncLoo(DS, maxDim, plotOpt)
%% Description
% 		recogRate=pcaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using PCA (principal component analysis)
%% Example
%%
% PCA over WINE dataset
DS=prData('wine');
recogRate1=pcaPerfViaKnncLoo(DS, [], 1);
%%
% Effect of input normalization of PCA over WINE dataset
DS=prData('wine');
recogRate1=pcaPerfViaKnncLoo(DS);
DS.input=inputNormalize(DS.input);
recogRate2=pcaPerfViaKnncLoo(DS);
plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
xlabel('No. of projected features based on PCA');
ylabel('LOO recognition rates using KNNC (%)');
legend('Without input normalization', 'With input normalization', 'location', 'southwest');
