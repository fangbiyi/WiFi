%% perfLoo
% Leave-one-out accuracy of given dataset and classifier
%% Syntax
% * 		recogRate=perfLoo(DS, classifier, classifierOpt)
% * 		recogRate=perfLoo(DS, classifier, classifierOpt, showPlot)
% * 		[recogRate, computedClass]=perfLoo(...)
%% Description
%
% <html>
% <p>recogRate=perfLoo(DS, classifier, classifierOpt) returns the leave-one-out recognition rate of the given dataset and classifier.
% 	<ul>
% 	<li>recogRate: recognition rate
% 	<li>DS: Dataset
% 		<ul>
% 		<li>DS.input: Input data (each column is a feature vector)
% 		<li>DS.output: Output class (ranging from 1 to N)
% 		</ul>
% 	<li>classifierOpt: Training parameters for the classifier
% 	</ul>
% <p>recogRate=perfLoo(DS, classifier, classifierOpt, 1) also plots the dataset and misclasified instances (if the dimension is 2).
% <p>[recogRate, computedClass]=perfLoo(...) also returns the computed class of each data instance in DS.
% </html>
%% Example
%%
%
DS=prData('random2');
showPlot=1;
recogRate=perfLoo(DS, 'qc', [], showPlot);
%% See Also
% <perfCv4classifier_help.html perfCv4classifier>,
% <perfCv_help.html perfCv>.
