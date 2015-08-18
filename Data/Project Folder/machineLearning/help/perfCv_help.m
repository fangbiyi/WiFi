%% perfCv
% Cross-validation accuracy of given dataset and classifier
%% Syntax
% * 		vRr=perfCv(DS, classifier, classifierOpt)
% * 		vRr=perfCv(DS, classifier, classifierOpt, showPlot)
% * 		[vRrOverall, tRrOverall, vRr, tRr, computedClass]=perfCv(...)
%% Description
%
% <html>
% <p>vRr=perfCv(DS, classifier, classifierOpt) returns the cross-validation recognition rate of the given dataset and classifier.
% 	<ul>
% 	<li>vRr: validating recognition rate
% 	<li>DS: Dataset
% 		<ul>
% 		<li>DS.input: Input data (each column is a feature vector)
% 		<li>DS.output: Output class (ranging from 1 to N)
% 		</ul>
% 	<li>classifierOpt: Training parameters for the classifier
% 	</ul>
% <p>vRr=perfCv(DS, classifier, classifierOpt, 1) also plots the dataset and misclasified instances (if the dimension is 2).
% <p>[vRrOverall, tRrOverall, vRr, tRr, computedClass]=perfCv(...) returns more info about cross-validation:
% 	<ul>
% 	<li>vRrOverall: Overall validating RR
% 	<li>tRrOverall: Overall training RR
% 	<li>vRr: Validating RR for all folds
% 	<li>tRr: Training RR for all folds
% 	<li>computedClass: The computed class of each data instance in DS
% 	</ul>
% </html>
%% Example
%%
%
DS=prData('iris');
showPlot=1;
foldNum=10;
classifier='qc';
vRr=perfCv(DS, classifier, [], foldNum, showPlot);
%% See Also
% <perfCv4classifier_help.html perfCv4classifier>,
% <perfLoo_help.html perfLoo>.
