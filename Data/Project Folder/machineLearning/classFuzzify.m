function fuzzyClass = classFuzzify(DS, k)
%classFuzzify: Initialize fuzzy membership grades for a dataset
%
%	Usage:
%		fuzzyClass = classFuzzify(DS, k)
%
%	Description:
%		fuzzyClass = classFuzzify(DS, k) returns the fuzzy membership grades of each sample data point:
%			DS: dataset
%			k: the no. of nearest neighbors used for computing the membership grades.
%
%	Example:
%		DS=prData('3classes');
%		dsScatterPlot(DS);
%		line([0 1], [0 1], 'linestyle', ':');		% Plot boundary
%		line([0.5 1], [0.5 0], 'linestyle', ':');	% Plot boundary
%		k=5;
%		fuzzyClass = classFuzzify(DS, k);
%		index=find(sum(fuzzyClass.^0.5)~=1); 
%		line(DS.input(1,index), DS.input(2,index), 'linestyle', 'none', 'marker', 'o', 'color', 'k');
%		title('Circled data points have fuzzy membership grades.');
%
%	See also knncFuzzy.
%
%	Reference:
%		J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy K-Nearest Neighbor Algorithm", IEEE Transactions on Systems, Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585, 1985.

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19990805

if nargin<1, selfdemo; return; end

classNum=max(DS.output);
dataNum=size(DS.input,2);

% Euclidean distance matrix
distMat=distPairwise(DS.input);
distMat(1:(dataNum+1):dataNum^2) = inf;		% Set diagonal elements to infs

% knnmat(i,j) = class of i-th nearest point of j-th input vector
% (The size of knnmat is k times dataNum.)
[junk, index] = sort(distMat);
knnmat = reshape(DS.output(index(1:k,:)), k, dataNum);

% class_count(i,j) = count of class-i points within j-th test input vector's
% neighborhood
%class_count = zeros(classNum, test_n);
%for i = 1:test_n,
%	[sorted_element, element_count] = countele(knnmat(:,i));
%	class_count(sorted_element, i) = element_count;
%end

% Compute the membership grades for each sample point
fuzzyClass = zeros(classNum, dataNum);
for i = 1:dataNum,
	for j = 1:classNum
		desiredClass = DS.output(i);
		n = length(find(knnmat(:,i)==j));
		if j == desiredClass,
			fuzzyClass(j,i) = n/k*0.49+0.51;
		else
			fuzzyClass(j,i) = n/k*0.49;
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
