function strVecPrint(strVec, name)
% strVecPrint: Print a string vector
%	Usage: strVecPrint(strVec, name)

%	Roger Jang, 20070117

if nargin<1; selfdemo; return; end

fprintf('%s = {', name);
if length(strVec)==0
	fprintf('}\n');
	return;
end

fprintf('''%s''', strVec{1});
for i=2:length(strVec)
	fprintf(', ''%s''', strVec{i});
end
fprintf('}\n');

% ====== Self selfdemo
function selfdemo
myStrVec={'abc','mn','xyz'};
strVecPrint(myStrVec, 'myStrVec');