classifier='qc';

% === No LDA
[trainSet, testSet]=prData('wine');
[cPrm, logLike1, recogRate1]=classifierTrain(classifier, trainSet);
[computedClass, logLike2, recogRate2, hitIndex]=classifierEval(classifier, testSet, cPrm, 1);
fprintf('Using the original dataset:\n');
fprintf('\tInside recog rate = %g%%\n', recogRate1*100);
fprintf('\tOutside recog rate = %g%%\n', recogRate2*100);

% === LDA using all LDA vectors
[trainSet, testSet]=prData('wine');
[trainSet2, ldaVec]=lda(trainSet);
[cPrm, logLike1, recogRate1]=classifierTrain(classifier, trainSet2);
testSet2=testSet; testSet2.input=ldaVec'*testSet2.input;
[computedClass, logLike2, recogRate2, hitIndex]=classifierEval(classifier, testSet2, cPrm, 1);
fprintf('Using the dataset after LDA projection:\n');
fprintf('\tInside recog rate = %g%%\n', recogRate1*100);
fprintf('\tOutside recog rate = %g%%\n', recogRate2*100);

% === LDA using the best no. of LDA vectors
[trainSet, testSet]=prData('wine');
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='exact';
[recogRate, bestFeaNum]=ldaPerfViaKnncLoo(trainSet, opt, 1);
[trainSet2, ldaVec]=lda(trainSet, bestFeaNum);
[cPrm, logLike1, recogRate1]=classifierTrain(classifier, trainSet2);
%testSet2=testSet; testSet2.input=ldaVec'*testSet2.input;
cPrm.ldaVec=ldaVec;
[computedClass, logLike2, recogRate2, hitIndex]=classifierEval(classifier, testSet, cPrm, 1);
fprintf('Using the dataset after LDA projection to %d direction:\n', bestFeaNum);
fprintf('\tInside recog rate = %g%%\n', recogRate1*100);
fprintf('\tOutside recog rate = %g%%\n', recogRate2*100);

% === Input normalization before LDA which uses the best no. of LDA vectors
[trainSet, testSet]=prData('wine');
[trainSet.input, sampleMean, sampleStd]=inputNormalize(trainSet.input);
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='exact';
figure; [recogRate, bestFeaNum]=ldaPerfViaKnncLoo(trainSet, opt, 1);
[trainSet2, ldaVec]=lda(trainSet, bestFeaNum);
[cPrm, logLike1, recogRate1]=classifierTrain(classifier, trainSet2);
testSet2=testSet;
testSet2.input=inputNormalize(testSet2.input, sampleMean, sampleStd);
testSet2.input=ldaVec'*testSet2.input;
%cPrm.ldaVec=ldaVec;
[computedClass, logLike2, recogRate2, hitIndex]=classifierEval(classifier, testSet2, cPrm, 1);
fprintf('Using the dataset after input normalization and LDA projection to %d direction:\n', bestFeaNum);
fprintf('\tInside recog rate = %g%%\n', recogRate1*100);
fprintf('\tOutside recog rate = %g%%\n', recogRate2*100);