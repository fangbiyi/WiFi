function distanceMatrix = distPairwise(mat1, mat2, p)
% distLpNormPairwise: Pairwise Lp-norm distance between two set of vectors
%
%	Usage:
%		distanceMatrix=distLpNormPairwise(mat1, mat2)
%		distanceMatrix=distLpNormPairwise(mat1, mat2, p)
%
%	Description:
%		distLpNormPairwise(mat1, mat2, p) returns the distance matrix between two set of column vectors mat1 and mat2.
%		The element at row i and column j of the return matrix is the L-p norm distance (with parameter p) between column i of mat1 and column j of mat2.
%
%	Example:
%		mat1=[1 3 3;2 3 4];
%		mat2=[4 5 6 7;3 3 4 5];
%		fprintf('mat1 =\n'); disp(mat1);
%		fprintf('mat2 =\n'); disp(mat2);
%		out=distLpNormPairwise(mat1, mat2, 1);
%		fprintf('distLpNormPairwise(mat1, mat2, 1) =\n'); disp(out);
%		out=distLpNormPairwise(mat1, mat2, 2);
%		fprintf('distLpNormPairwise(mat1, mat2, 2) =\n'); disp(out);
%		out=distLpNormPairwise(mat1, mat2, inf);
%		fprintf('distLpNormPairwise(mat1, mat2, inf) =\n'); disp(out);

%	Category: Distance and similarity
%	Roger Jang, 19960924, 20100731

if nargin<1, selfdemo; return; end
if nargin<2, mat2=mat1; end
if nargin<3, p=2; end

[dim1, num1]=size(mat1);
[dim2, num2]=size(mat2);

if dim1~=dim2
	error('Matrix dimensions mismatch!');
end

distanceMatrix=zeros(num1, num2);

if num1<num2
	for i=1:num1
		distanceMatrix(i,:)=distLpNorm(mat1(:,i)*ones(1, num2)-mat2, p);
	end
else 
	for i=1:num2
		distanceMatrix(:,i)=distLpNorm(mat2(:,i)*ones(1,num1)-mat1, p).';
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
