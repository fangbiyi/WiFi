function strEval(cellStr)
% strEval: Evaluation of strings

if isstruct(cellStr)	% If cellStr is in face mObj.example...
	cellStr=cellStr(1).code;
end

% ====== Get rid of comments starting at the very first character
deleteIndex=[];
for i=1:length(cellStr)
	aLine=cellStr{i};
	if aLine(1)=='%'
		deleteIndex=[deleteIndex, i];
	end
end
cellStr(deleteIndex)=[];

% ====== Get rid of the trailing comments
for i=1:length(cellStr)
	aLine=cellStr{i};
	index=find(aLine=='%');
	if isempty(index), continue; end
	lastPos=index(end);
	if any(aLine(lastPos+1:end)==')'), continue; end	% To avoid something like "fprintf('%d\n', x)"
	cellStr{i}=cellStr{i}(1:lastPos-1);
end

% ====== Make sure every line ends with a ";"
for i=1:length(cellStr)
	if cellStr{i}(end)~=';'
		cellStr{i}(end+1)=';';
	end
end

% ====== Eval after joining to avoid error line-by-line execution of for-loop
cmd=join(cellStr, ' ');
eval(cmd);
