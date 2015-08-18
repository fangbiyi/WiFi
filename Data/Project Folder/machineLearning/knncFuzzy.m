function [testFuzzyOutput, testCrispOutput]= knncFuzzy(testSet, trainSet, prm)
%knncFuzzy: Fuzzy k-nearest neighbor classifier
%
%	Usage:
%		testOut = knncFuzzy(testSet, trainSet, prm)
%
%	Description:
%		testOut = knncFuzzy(testSet, trainSet, prm) returns the result of fuzzy KNN classifier, using the given training set trainSet and test set testSet.
%
%	Example:
%		[trainSet, testSet]=prData('3classes');
%		dsScatterPlot(trainSet);		% Plot the training set
%		line([0 1], [0 1], 'linestyle', ':');		% Plot boundary
%		line([0.5 1], [0.5 0], 'linestyle', ':');	% Plot boundary
%		prm.k=5;
%		prm.m=2;
%		[fuzzyOutput, crispOutput]=knncFuzzy(testSet, trainSet, prm);
%		dsScatterPlot(testSet);		% Overlay the test set
%		for i=1:3
%			index=find(crispOutput==i);
%			line(testSet.input(1, index), testSet.input(2, index), 'marker', 'o', 'color', getColor(i), 'linestyle', 'none');
%		end
%		title('Training set (dots) and test set (circles with color indicting the test results)');
%		fprintf('Recog. rate = %.2f%%\n', 100*sum(crispOutput==testSet.output)/length(testSet.output));
%
%	See also classFuzzify.
%
%	Reference:
%		[1] J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy
%			K-Nearest Neighbor Algorithm", IEEE Transactions on Systems,
%			Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585, 1985.

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19990805

if nargin<1, selfdemo; return; end
if nargin<4, prm.k=3; prm.m=2; end

trainNum=size(trainSet.input, 2);
testNum=size(testSet.input, 2);
classNum=max(trainSet.output);
if size(trainSet.output,1)==1
	trainOutputFuzzy=classFuzzify(trainSet, prm.k);
end

% Euclidean distance matrix
distMat = distPairwise(trainSet.input, testSet.input);

% knnmat(i,j) = class of i-th nearest point of j-th input vector
% (The size of knnmat is k times testNum.)
[junk, index] = sort(distMat);
% knnmat = reshape(trainOut(index(1:k,:)), k, testNum);

testFuzzyOutput = zeros(classNum, testNum);
for i = 1:testNum,
	neighbor_index = index(1:prm.k, i);
	weight = distMat(neighbor_index, i).^(-2/(prm.m-1));
	weight(isinf(weight))=realmax;		% To avoid weight of inf
	testFuzzyOutput(:,i) = trainOutputFuzzy(:,neighbor_index)*weight/(sum(weight));
end

if nargout>1
	[junk, testCrispOutput] = max(testFuzzyOutput);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
