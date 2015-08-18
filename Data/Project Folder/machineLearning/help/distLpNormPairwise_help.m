%% distLpNormPairwise
% Pairwise Lp-norm distance between two set of vectors
%% Syntax
% * 		distanceMatrix=distLpNormPairwise(mat1, mat2)
% * 		distanceMatrix=distLpNormPairwise(mat1, mat2, p)
%% Description
%
% <html>
% <p>distLpNormPairwise(mat1, mat2, p) returns the distance matrix between two set of column vectors mat1 and mat2.
% <p>The element at row i and column j of the return matrix is the L-p norm distance (with parameter p) between column i of mat1 and column j of mat2.
% </html>
%% Example
%%
%
mat1=[1 3 3;2 3 4];
mat2=[4 5 6 7;3 3 4 5];
fprintf('mat1 =\n'); disp(mat1);
fprintf('mat2 =\n'); disp(mat2);
out=distLpNormPairwise(mat1, mat2, 1);
fprintf('distLpNormPairwise(mat1, mat2, 1) =\n'); disp(out);
out=distLpNormPairwise(mat1, mat2, 2);
fprintf('distLpNormPairwise(mat1, mat2, 2) =\n'); disp(out);
out=distLpNormPairwise(mat1, mat2, inf);
fprintf('distLpNormPairwise(mat1, mat2, inf) =\n'); disp(out);
