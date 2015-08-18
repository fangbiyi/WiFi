function [newSampleIn, discrimVec] = flda(sampleIn, sampleOut, discrimVecNum)
% flda: fuzzy LDA (linear discriminant analysis)
%
%	Usage:
%		[NEWSAMPLE, DISCRIM_VEC] = flda(SAMPLE, discrimVecNum)
%
%	Description:
%		[NEWSAMPLE, DISCRIM_VEC] = flda(SAMPLE, discrimVecNum) returns the new dataset after fuzzy LDA.
%			SAMPLE: Sample data with class information, where each row of SAMPLE is a sample point, with the last column being the class label ranging from 1 to no. of classes
%			discrimVecNum: No. of discriminant vectors
%			NEWSAMPLE: new sample after projection
%
%	Reference:
%		J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
%
%	Type "flda" for a self-demo.

%	Category: Data dimension reduction
%	Roger Jang, 990829

if nargin<1, selfdemo; return; end
if nargin<3, discrimVecNum = size(sampleIn ,2); end

% ====== Initialization
n = size(sampleIn, 1);
m = size(sampleIn,2);
A = sampleIn;
mu = mean(A);

% ====== Compute B and W
% ====== B: between-class scatter matrix
% ====== W:  within-class scatter matrix
% MMM = \sum_k m_k*mu_k*mu_k^T
U = sampleOut';
count = sum(U, 2);	% Cardinality of each class
% Each row of MU is the mean of a class
MU = U*A./(count*ones(1, m));
MMM = MU'*diag(count)*MU;
W = A'*A - MMM;
B = MMM - n*mu'*mu;

% ====== Find the best discriminant vectors
invW = inv(W);
Q = invW*B;
D = [];
for i = 1:discrimVecNum,
	[eigVec, eigVal] = eig(Q);
	[maxEigVal, index] = max(abs(diag(eigVal)));  
	D = [D, eigVec(:, index)];	% Each col of D is a eigenvector
	Q = (eye(m)-invW*D*inv(D'*invW*D)*D')*invW*B;
end
newSampleIn = A*D(:,1:discrimVecNum); 
discrimVec = D;

%---------------------------------------------------
function selfdemo
% Self demo using IRIS dataset
load iris.dat
sampleIn = iris(:, 1:end-1);
sampleOut = iris(:, end);

DS=prData('iris');
sampleIn=DS.input';
sampleOut=DS.output';

sampleFuzzyOut = initfknn(iris, 3);
newSampleIn = flda(sampleIn, sampleFuzzyOut);
data = newSampleIn;
index1 = find(iris(:,5)==1);
index2 = find(iris(:,5)==2);
index3 = find(iris(:,5)==3);
figure;
plot(data(index1, 1), data(index1, 2), '*', ...
     data(index2, 1), data(index2, 2), 'o', ...
     data(index3, 1), data(index3, 2), 'x');
legend('Class 1', 'Class 2', 'Class 3');
title('LDA projection of IRIS data onto the first 2 discriminant vectors');

DS2.input=data';
DS2.output=DS.output;
loo_error = knncloo(DS2);
xlabel(['Leave-one-out misclassification count = ', int2str(loo_error)]);
axis equal; axis tight;
 
figure;
plot(data(index1, 3), data(index1, 4), '*', ...
     data(index2, 3), data(index2, 4), 'o', ...
     data(index3, 3), data(index3, 4), 'x');
legend('Class 1', 'Class 2', 'Class 3');
title('LDA projection of IRIS data onto the last 2 discriminant vectors');
DS2.input=DS2.input(3:4, :);
loo_error = knncloo(DS2);
xlabel(['Leave-one-out misclassification count = ', int2str(loo_error)]);
axis equal; axis tight;
