%% gmmWrite
% Write the parameters of a GMM to a file
%% Syntax
% * 		gmmWrite(gmmPrm, gmmFile)
% * 		gmmWrite(gmmPrm, gmmFile, useInt)
% * 		gmmWrite(gmmPrm, gmmFile, useInt, weightSf)
%% Description
%
% <html>
% <p>gmmWrite(gmmPrm, gmmFile) writes the given GMM parameters in gmmPrm to a GMM parameter file.
% <p>gmmWrite(gmmPrm, gmmFile, useInt) convert the parameters into integers before saving.
% <p>gmmWrite(gmmPrm, gmmFile, useInt, weightSf) uses scaling factor of weights (This should be the same as those used in goLog.m, goLogSum.m for generating C tables.)
% </html>
%% Example
%%
%
DS=dcData(2);
trainingData=DS.input;
gmmOpt=gmmTrain('defaultOpt');
gmmOpt.config.gaussianNum=8;
gmmOpt.config.covType=1;
[gmmPrm, logLike]=gmmTrain(trainingData, gmmOpt);
gmm.gmmPrm=gmmPrm;
gmm.name='Test example';
gmmFile=[tempname, '.gmm'];
gmmWrite(gmm, gmmFile);
edit(gmmFile)
