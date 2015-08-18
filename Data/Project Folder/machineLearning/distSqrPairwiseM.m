function distMat=distPairwiseM(A, B)
% distPairwise: Pairwise Euclidean distance between two set of vectors
%
%	Usage:
%		distMatrix=distPairwise(mat1)
%		distMatrix=distPairwise(mat1, mat2)
%
%	Description:
%		distPairwise(mat1, mat2) returns the distance matrix between two set of column vectors mat1 and mat2.
%		The element at row i and column j of the return matrix is the Euclidean distance between column i of mat1 and column j of mat2.
%
%	Example:
%		mat1=[1 3 3;2 3 4];
%		mat2=[4 5 6 7;3 3 4 5];
%		fprintf('mat1 =\n'); disp(mat1);
%		fprintf('mat2 =\n'); disp(mat2);
%		out=distSqrPairwiseM(mat1, mat2);
%		fprintf('distPairwise(mat1, mat2) =\n'); disp(out);

%	Category: Distance and similarity
%	Roger Jang, 19960924, 20100731

if nargin<1, selfdemo; return; end
if nargin<2
	m=size(A,2);
	distMat=zeros(m, m);
	for i=1:m
		for j=i+1:m
			distMat(i,j)=sum((A(:,i)-A(:,j)).^2);
		end
	end
	distMat=distMat+distMat';
	return
end

m=size(A,2);
n=size(B,2);
distMat=zeros(m, n);
for i=1:m
	for j=1:n
		distMat(i,j)=sum((A(:,i)-B(:,j)).^2);
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
