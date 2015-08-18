%% getTriFilterPrm
% Get parameters of triangular filter bank
%% Syntax
% * 		filterBankPrm = getTriFilterPrm(frameSize, fs, filterNum)
% * 		filterBankPrm = getTriFilterPrm(frameSize, fs, filterNum, plotOpt)
%% Description
%
% <html>
% <p>filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum) returns the parameters of the triangular filter bank.
% <p>filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum, 1) also plot these triangular filter bank.
% </html>
%% Example
%%
%
frameSize=512;
fs=16000;
filterNum=20;
filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum, 1);
%% See Also
% <wave2mfcc_help.html wave2mfcc>,
% <mfccOptSet_help.html mfccOptSet>.
