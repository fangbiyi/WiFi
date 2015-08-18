%% knncEval
% K-nearest neighbor classifier (KNNC)
%% Syntax
% * 		[computedClass, overallComputedClass, nearestIndex, knncMat]=knncEval(testSet, knncPrm)
%% Description
%
% <html>
% <p>computedClass = knncEval(testSet, knncPrm) returns the results of KNNC, where
% 	<ul>
% 	<li>testSet: the test set
% 	<li>knncPrm: parameters for KNNC
% 		<ul>
% 		<li>knncPrm.k: the value of k for k-nearest neighbor classification
% 		</ul>
% 	<li>computedClass: output vector by KNNC
% 	</ul>
% <p>[computedClass, overallComputedClass, nearestIndex, knncMat] = knncEval(testSet, knncPrm) returns extra info:
% 	<ul>
% 	<li>overallComputedClass: a single output by KNNC, assuming all testSet are of the same class
% 	<li>nearestIndex: Index of prmSet.input that are closest to testSet.input
% 	<li>knncMat(i,j) = class of i-th nearest point of j-th test input vector
% 	</ul>
% </html>
%% Example
%%
%
[trainSet, testSet]=prData('iris');
trainNum=size(trainSet.input, 2);
testNum =size(testSet.input, 2);
fprintf('Use of KNNC for Iris data:\n');
fprintf('\tSize of train set (odd-indexed data) = %d\n', trainNum);
fprintf('\tSize of test set (even-indexed data) = %d\n', testNum);
knncTrainPrm.method='none';
knncPrm=knncTrain(trainSet, knncTrainPrm);
fprintf('\tRecognition rates as K varies:\n');
kMax=15;
for k=1:kMax
	knncPrm.k=k;
	computed=knncEval(testSet, knncPrm);
	correctCount=sum(testSet.output==computed);
	recogRate(k)=correctCount/testNum;
	fprintf('\t%d-NNC ===> RR = 1-%d/%d = %.2f%%.\n', k, testNum-correctCount, testNum, recogRate(k)*100);
end
plot(1:kMax, recogRate*100, 'b-o'); grid on;
title('Recognition rates of Iris data using KNN classifier');
xlabel('K'); ylabel('Recognition rates (%)');
