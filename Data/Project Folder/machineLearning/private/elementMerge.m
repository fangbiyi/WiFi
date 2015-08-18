function vec2 = elementMerge(vec)
%elementMerge: Merge neighboring same elements in a vector.
%	Usage: vec2 = elementMerge(vec)
%
%	For example:
%		vec1=[1 5 5 5 5 3 3 3 1 1 1 0 0 9 9 9 9];
%		vec2=elementMerge(vec1);
%		fprintf('vec1 = %s\n', mat2str(vec1));
%		fprintf('vec2 = elementMerge(vec1) = %s\n', mat2str(vec2));
%		
%	Type "elementMerge" for a self demo.

%	Roger Jang, 20060530, 20071009

if nargin==0, selfdemo; return, end

vec2=vec([1, diff(vec)]~=0);

% ====== Seld demo ======
function selfdemo
vec1=[1 5 5 5 5 3 3 3 1 1 1 0 0 9 9 9 9];
vec2=elementMerge(vec1);
fprintf('vec1 = %s\n', mat2str(vec1));
fprintf('vec2 = elementMerge(vec1) = %s\n', mat2str(vec2));