%% knncLoo
% Leave-one-out recognition rate of KNNC
%% Syntax
% * 		recogRate=knncLoo(DS)
% * 		recogRate=knncLoo(DS, knncPrm)
% * 		recogRate=knncLoo(DS, knncPrm, plotOpt)
% * 		[recogRate, computed, nearestIndex]=knncLoo(...)
%% Description
%
% <html>
% <p>recogRate=knncLoo(DS) returns the recognition rate of the KNNC over the dataset DS based on the leave-one-out criterion.
% <p>recogRate=knncLoo(DS, knncPrm) uses the KNNC parameters in knncPrm for the computation.
% <p>recogRate=knncLoo(DS, knncPrm, plotOpt) plots the results if the dimension of the dataset is 2.
% <p>[recogRate, computed, nearestIndex]=knncLoo(...) also returns the computed class and the nearest index of each data instance.
% </html>
%% Example
%%
%
DS=prData('random2');
knncPrm.k=1;
plotOpt=1;
[recogRate, computed, nearestIndex] = knncLoo(DS, knncPrm, plotOpt);
fprintf('Recog. rate = %.2f%%\n', 100*recogRate);
%% See Also
% <knncEval_help.html knncEval>,
% <knncTrain_help.html knncTrain>.
