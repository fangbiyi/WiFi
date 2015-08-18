function output=structDispInHtml(struct, caption, fieldsToBeDisplayed, fieldTitles, fieldsToBeLinked, outputFile, imageFieldsToBeDisplayed)
% structDispInHtml: Display a structure in HTML page
%	Usage: structDispInHtml(struct, caption, fieldsToBeDisplayed, fieldTitles, fieldsToBeLinked, outputFile, imageFieldsToBeDisplayed)
%
%	For example:
%		table=tableRead('table01.txt', 1, {'id', 'word', 'count'});
%		structDispInHtml(table, 'A test table');

%	Roger Jang, 20041001, 20081219

if nargin<1; selfdemo; return; end
if nargin<2, caption=[]; end
if nargin<3 | isempty(fieldsToBeDisplayed), fieldsToBeDisplayed=fieldnames(struct); end
if nargin<4 | isempty(fieldTitles), fieldTitles=fieldsToBeDisplayed; end
if nargin<5 | isempty(fieldsToBeLinked), fieldsToBeLinked={}; end
if nargin<6 | isempty(outputFile), outputFile=[tempname, '.htm']; end
if nargin<7 | isempty(imageFieldsToBeDisplayed), imageFieldsToBeDisplayed={}; end

fid=fopen(outputFile, 'w');
fprintf(fid, '<html><body>\n');
fprintf(fid, '<head>\n');
fprintf(fid, '<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=big5">\n');
fprintf(fid, '</head>\n');
fprintf(fid, '<center>\n');
fprintf(fid, '<table border=1>');
if ~isempty(caption)
	fprintf(fid, '<caption><h2>%s</h2></caption>', caption);
end

fprintf(fid, '<tr><th>Index\\Field');
for i=1:length(fieldTitles)
	fprintf(fid, '<th>%s', fieldTitles{i});
end

for i=1:length(struct)
	fprintf(fid, '<tr><td>&nbsp;%d', i);
	for j=1:length(fieldsToBeDisplayed)
		data=getfield(struct, {i}, fieldsToBeDisplayed{j});
		if isstr(data)
			if any(strcmp(fieldsToBeDisplayed{j}, fieldsToBeLinked))
				fprintf(fid, '<td><a target=_blank href="%s">&nbsp;%s</a>', data, data);
			elseif any(strcmp(fieldsToBeDisplayed{j}, imageFieldsToBeDisplayed))
				fprintf(fid, '<td><a target=_blank href="%s"><img height=200 src="%s"></a>', data, data);
			else
				fprintf(fid, '<td>&nbsp;%s', data);
			end
		elseif iscell(data)
			fprintf(fid, '<td>&nbsp;%s', cell2str(data));
		else
			fprintf(fid, '<td>&nbsp;%s', mat2str(data, 10));
		end
	end
	fprintf(fid, '\n');
end

fprintf(fid, '</table>\n');
fprintf(fid, '</center>\n');
fprintf(fid, '</body></html>\n');
fclose(fid);

%dosCmd=['start "', outputFile, '"']
%dos(dosCmd);
if nargout>0
	output=fileread(outputFile);
else
	web(outputFile, '-browser');
end

% ====== Self demo
function selfdemo
testTable=dir;
feval(mfilename, testTable, 'Test table', [], {'name'});