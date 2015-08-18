function [DS2, discrimVec, eigValues] = lda(DS, discrimVecNum)
%lda: Linear discriminant analysis
%
%	Usage:
%		DS2 = lda(DS)
%		DS2 = lda(DS, discrimVecNum)
%		[DS2, discrimVec, eigValues] = lda(...)
%
%	Description:
%		DS2 = lda(DS, discrimVecNum) returns the results of LDA (linear discriminant analysis) on DS
%			DS: input dataset (Try "DS=prData('iris')" to get an example of DS.)
%			discrimVecNum: No. of discriminant vectors
%			DS2: output data set, with new feature vectors
%		[DS2, discrimVec, eigValues] = lda(DS, discrimVecNum) returns extra info:
%			discrimVec: discriminant vectors identified by LDA
%			eigValues: eigen values corresponding to the discriminant vectors
%
%	Example:
%		% === Scatter plots of the LDA projection
%		DS=prData('wine');
%		DS2=lda(DS);
%		DS12=DS2; DS12.input=DS12.input(1:2, :);
%		subplot(1,2,1); dsScatterPlot(DS12); xlabel('Input 1'); ylabel('Input 2');
%		title('Wine dataset projected on the first 2 LDA vectors'); 
%		DS34=DS2; DS34.input=DS34.input(end-1:end, :);
%		subplot(1,2,2); dsScatterPlot(DS34); xlabel('Input 3'); ylabel('Input 4');
%		title('Wine dataset projected on the last 2 LDA vectors');
%		% === Leave-one-out accuracy of the projected dataset using KNNC
%		fprintf('LOO accuracy of KNNC over the original wine dataset = %g%%\n', 100*perfLoo(DS, 'knnc'));
%		fprintf('LOO accuracy of KNNC over the wine dataset projected onto the first two LDA vectors = %g%%\n', 100*perfLoo(DS12, 'knnc'));
%		fprintf('LOO accuracy of KNNC over the wine dataset projected onto the last two LDA vectors = %g%%\n', 100*perfLoo(DS34, 'knnc'));
%
%	Reference:
%		[1] J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
%
%	See also ldaPerfViaKnncLoo.

%	Category: Data dimension reduction
%	Roger Jang, 19990829, 20030607, 20100212

if nargin<1, selfdemo; return; end
if ~isstruct(DS)
	fprintf('Please try "DS=prData(''iris'')" to get an example of DS.\n');
	error('The input DS should be a structure variable!');
end
if nargin<2, discrimVecNum=size(DS.input,1); end

% ====== Initialization
m = size(DS.input,1);	% Dimension of data point
n = size(DS.input,2);	% No. of data point
A = DS.input;
if size(DS.output, 1)==1	% Crisp output
	classLabel = DS.output;
	[diffClassLabel, classSize] = elementCount(classLabel);
	classNum = length(diffClassLabel);
	mu = mean(A, 2);

	% ====== Compute B and W
	% ====== B: between-class scatter matrix
	% ====== W:  within-class scatter matrix
	% M = \sum_k m_k*mu_k*mu_k^T
	M = zeros(m, m);
	for i = 1:classNum,
		index = find(classLabel==diffClassLabel(i));
		classMean = mean(A(:, index), 2);
		M = M + length(index)*classMean*classMean';
	end
	W = A*A'-M;
	B = M-n*mu*mu';
else				% Potential fuzzy output
	% Put fuzzy lda code here
end

% ====== Find the best discriminant vectors
if det(W)==0
	error('W is singular. One possible reason: a feature has the same value across all training data.'); 
end
invW = inv(W);
Q = invW*B;

D = [];
for i = 1:discrimVecNum
	[eigVec, eigVal] = eig(Q);
	[eigValues(i), index] = max(diag(eigVal));  
	D = [D, eigVec(:, index)];		% Each col of D is a eigenvector
	Q = (eye(m)-invW*D*inv(D'*invW*D)*D')*invW*B;
end
DS2=DS;
DS2.input = D(:,1:discrimVecNum)'*A; 
discrimVec = D;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
