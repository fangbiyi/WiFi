function table=tableRead(fileName, format, fieldNames, delimiter)
% tableRead: Read a table with tab-separated fields
%	Usage: table=tableRead(fileName, format, fieldNames, delimiter)
%		fileName: table file name
%		format: 1 (see table01.txt), 2 (see table02.txt), or 3 (see table03.txt)
%		fieldNames: names of fields (for type-1 format only)
%
%	For example:
%		table=tableRead('table01.txt', 1, {'id', 'word', 'count'})

%	Roger Jang, 20051111, 20071009

if nargin<1, selfdemo; return; end
if nargin<4, delimiter=9; end		% \t as the default delimiter

splitMode=1;
switch format
	case 1
		contents=textread(fileName, '%s', 'delimiter', '\n', 'whitespace', '', 'bufsize', 20000);
		table=[];
		for i=1:length(contents)
			line=contents{i};
		%	fprintf('%d/%d: line=%s\n', i, length(contents), line);
			items=split(line, delimiter, splitMode);		% tab separated
		%	keyboard
			itemNum=min(length(items), length(fieldNames));		% Assign parsed items
			for j=1:itemNum   % This is slow! How to improve it?
				table=setfield(table, {i}, fieldNames{j}, items{j}); 
			end
		end
	case 2
		contents=textread(fileName, '%s', 'delimiter', '\n', 'whitespace', '', 'bufsize', 20000);
		fieldNames=split(contents{1}, delimiter, splitMode);
		table=[];
		for i=2:length(contents)
			line=contents{i};
			items=split(line, delimiter, splitMode);		% tab separated
			itemNum=min(length(items), length(fieldNames));		% Assign parsed items
			for j=1:itemNum
				table=setfield(table, {i-1}, fieldNames{j}, items{j}); 
			end
		end
	case 3
		contents=textread(fileName, '%s', 'delimiter', '\n', 'whitespace', '', 'bufsize', 20000);
		table=[];
		for i=1:length(contents)
			line=contents{i};
			items=split(line, delimiter, splitMode);		% '\t' as the delimiter
			for j=1:length(items),
				temp=split(items{j}, '=');
				field=temp{1};
				if length(temp)==2
					value=temp{2};
				else
					value='';
				end
				table=setfield(table, {i}, field, {1:length(value)}, value);
			end
		end
	otherwise
		disp('Unknown format!');
end

% ====== self demo
function selfdemo
table01 = tableRead('table01.txt', 1, {'id', 'word', 'count'});
dispStructInHtml(table01);
fprintf('Hit any key to view table02...'); pause; fprintf('\n');
table02 = tableRead('table02.txt', 2);
dispStructInHtml(table02);
fprintf('Hit any key to view table03...'); pause; fprintf('\n');
table03 = tableRead('table03.txt', 3);
dispStructInHtml(table03);