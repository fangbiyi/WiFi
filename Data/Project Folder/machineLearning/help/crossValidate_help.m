%% crossValidate
% Cross validation for classifier performance evaluation
%% Syntax
% * 		[tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt)
%% Description
%
% <html>
% <p>[tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm) generates a classifier's performance based on m-fold cross validation.
% 	<ul>
% 	<li>DS: dataset
% 	<li>cvPrm: The parameters for cross validation
% 		<ul>
% 		<li>cvPrm.foldNum: The number of folds for CV. If this number is larger than the number of data instances in DS, then the leave-one-out method is used for CV.
% 		<li>cvPrm.classifier: The classifier used for CV
% 		<li>cvPrm.cPrm: The parameters of the classifier cvPrm.classifier. (If this field does not exist, or if the field value is empty, it indicates the use of the default classifier parameters.)
% 		</ul>
% 	<li>tRrMean: Mean value of the training recognition rate
% 	<li>vRrMean: Mean value of the validating recognition rate
% 	<li>tRr: Training recognition rate for each fold
% 	<li>vRr: Validating recognition rate for each fold
% 	</ul>
% </html>
%% Example
%%
% 10-fold cross-validation of Iris dataset using GMMC
DS=prData('iris');
cvPrm.foldNum=10;
cvPrm.classifier='gmmc';	% GMM-based classifier
plotOpt=1;
figure; [tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt);
%%
% Leave-one-out test of Iris dataset using QC
DS=prData('iris');
cvPrm.foldNum=inf;
cvPrm.classifier='qc';	% Quadratic classifier
plotOpt=1;
figure; [tRrMean, vRrMean, tRr, vRr]=crossValidate(DS, cvPrm, plotOpt);
