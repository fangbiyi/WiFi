function string = cell2str(cellstr)
% cellstr: Cell string to string conversion
%
%	For example:
%		x={'mon', 'tue', 'wed'};
%		y=cell2str(x)

%	Roger Jang, 20010610, 20071009

if ischar(cellstr)
	string = ['''', cellstr, ''''];
	return
end

string = [];
for i=1:length(cellstr),
	string = [string, '''', cellstr{i}, ''''];
	if i~=length(cellstr),
		string = [string, ', '];
	end
end
string = ['{', string, '}'];
