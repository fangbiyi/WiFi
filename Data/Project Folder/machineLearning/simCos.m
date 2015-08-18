function cosine = simCos(mat1, mat2)
% simCos: Cosine of the angles betweeen two set of vectors
%
%	Usage:
%		cosine = simCos(mat1, mat2)
%
%	Description:
%		cosine = simCos(mat1, mat2) returns the cosine of the angles between two set of vectors mat1 and mat2.
%			mat1: Data matrix 1 with each column is an observation
%			mat2: Data matrix 2 with each column is an observation
%			cosine: The cosine of the angles between two set of vectors mat1 and mat2.
%		The element at row i and column j of the return matrix is the cosine of the angle between column i of mat1 and column j of mat2.
%
%	Example:
%		mat1=rand(2, 3);
%		mat2=rand(2, 4);
%		cosine=simCos(mat1, mat2)
%
%	See also distPairwise.

%	Category: Distance and similarity
%	Roger Jang, 19971227, 20080915.

if nargin<1, selfdemo; return; end
if nargin<2, mat2=mat1; end

leng1 = (sum((mat1).^2).^.5);
leng2 = (sum((mat2).^2).^.5);
cosine = (mat1.'*mat2)./(leng1.'*leng2);

% ====== Selfdemo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
