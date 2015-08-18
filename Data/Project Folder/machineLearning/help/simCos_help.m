%% simCos
% Cosine of the angles betweeen two set of vectors
%% Syntax
% * 		cosine = simCos(mat1, mat2)
%% Description
%
% <html>
% <p>cosine = simCos(mat1, mat2) returns the cosine of the angles between two set of vectors mat1 and mat2.
% 	<ul>
% 	<li>mat1: Data matrix 1 with each column is an observation
% 	<li>mat2: Data matrix 2 with each column is an observation
% 	<li>cosine: The cosine of the angles between two set of vectors mat1 and mat2.
% 	</ul>
% <p>The element at row i and column j of the return matrix is the cosine of the angle between column i of mat1 and column j of mat2.
% </html>
%% Example
%%
%
mat1=rand(2, 3);
mat2=rand(2, 4);
cosine=simCos(mat1, mat2)
%% See Also
% <distPairwise_help.html distPairwise>.
