%% cvDataGen
% Generate m-fold cross validation (CV) data for performance evaluation
%% Syntax
% * 		cvData=cvDataGen(DS)
% * 		cvData=cvDataGen(DS, opt)
% * 		cvData=cvDataGen(DS, opt, showPlot)
% * 		[cvData, dispatchMat4index, dispatchMat4output]=cvDataGen(...)
%% Description
%
% <html>
% <p>[cvData, count]=cvDataGen(DS, m, mode) generates m-fold cross-validation data for performance evaluation.
% 	<ul>
% 	<li>DS: dataset to be partitioned
% 	<li>m: number of folds
% 	<li>mode: 'index' (index only, default) or 'full' (full data)
% 	</ul>
% <p>The m-fold CV data is generated to satisfy the following two criteria:
% 	<ul>
% 	<li>Each fold has the same number (or as close as possible) of data instances.
% 	<li>Each fold has the same (or as close as possible) class distribution.
% 	</ul>
% <p>You can examine the class distribution via the matrix count, where count(i,j) is the number of instances of class i within fold j.
% <p>If the mode is "full", then cvData is a structure array of m elements, with "TS" and "VS" fields for "training set" and "validating set", respectively.
% <p>If the mode is "index", then both cvData.TS and cvData.VS contain only the indices of the original data for saving memory.
% </html>
%% Example
%%
%
DS=prData('nonlinearseparable');
opt=cvDataGen('defaultOpt');
opt.foldNum=2;
opt.cvDataType='full';
cvData=cvDataGen(DS, opt);
subplot(121); dsScatterPlot(cvData(1).TS);
subplot(122); dsScatterPlot(cvData(1).VS);
