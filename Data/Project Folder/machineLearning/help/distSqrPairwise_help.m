%% distSqrPairwise
% Pairwise squared Euclidean distance between two set of vectors
%% Syntax
% * 		distMatrix=distSqrPairwise(mat1)
% * 		distMatrix=distSqrPairwise(mat1, mat2)
%% Description
%
% <html>
% <p>distSqrPairwise(mat1, mat2) returns the squared distance matrix between two set of column vectors mat1 and mat2.
% <p>The element at row i and column j of the return matrix is the squared Euclidean distance between column i of mat1 and column j of mat2.
% </html>
%% Example
%%
%
mat1=[1 3 3;2 3 4];
mat2=[4 5 6 7;3 3 4 5];
fprintf('mat1 =\n'); disp(mat1);
fprintf('mat2 =\n'); disp(mat2);
out=distSqrPairwise(mat1, mat2);
fprintf('distPairwise(mat1, mat2) =\n'); disp(out);
