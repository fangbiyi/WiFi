function distMat=distSqrPairwise(A, B)
% distSqrPairwise: Pairwise squared Euclidean distance between two set of vectors
%
%	Usage:
%		distMatrix=distSqrPairwise(mat1)
%		distMatrix=distSqrPairwise(mat1, mat2)
%
%	Description:
%		distSqrPairwise(mat1, mat2) returns the squared distance matrix between two set of column vectors mat1 and mat2.
%		The element at row i and column j of the return matrix is the squared Euclidean distance between column i of mat1 and column j of mat2.
%
%	Example:
%		mat1=[1 3 3;2 3 4];
%		mat2=[4 5 6 7;3 3 4 5];
%		fprintf('mat1 =\n'); disp(mat1);
%		fprintf('mat2 =\n'); disp(mat2);
%		out=distSqrPairwise(mat1, mat2);
%		fprintf('distPairwise(mat1, mat2) =\n'); disp(out);

%	Category: Distance and similarity
%	Roger Jang, 19960924, 20100731

if nargin<1, selfdemo; return; end

mexCommand='distSqrPairwiseMex';
mCommand='distSqrPairwiseM';
if nargin<2
	try
		distMat=feval(mexCommand, A);
	catch exception
		fprintf('%s is disabled due to the error message "%s".\n%s is activated instead.\n', mexCommand, exception.message, mCommand);
		distMat=feval(mCommand, A);
	end
else
	try
		distMat=feval(mexCommand, A, B);
	catch exception
		fprintf('%s is disabled due to the error message "%s".\n%s is activated instead.\n', mexCommand, exception.message, mCommand);
		distMat=feval(mCommand, A, B);
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
