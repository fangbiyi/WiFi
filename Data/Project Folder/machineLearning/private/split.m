function tokenList = split(str, delimiter, mode)
% split: Split a string based on a given delimiter
%	Usage:
%		tokenList = split(str, delimiter, mode)
%
%	Example:
%		str='--This-is---a-test--';
%		fprintf('str = "%s"\n', str);
%		tokenList=split(str, '-', 0);
%		fprintf('After running "tokenList = split(str, ''-'', 0)":\n');
%		strVecPrint(tokenList, 'tokenList');
%		tokenList=split(str, '-', 1);
%		fprintf('After running "tokenList = split(str, ''-'', 1)":\n');
%		strVecPrint(tokenList, 'tokenList');
%		tokenList=split(str, '-', 2);
%		fprintf('After running "tokenList = split(str, ''-'', 2)":\n');
%		strVecPrint(tokenList, 'tokenList');
%
%	See also JOIN.

%	Roger Jang, 20010324, 20071009

if nargin<1; selfdemo; return; end
if nargin<2; delimiter=' '; end
if nargin<3; mode=0; end

if isempty(str)
	tokenList={};
	return;
end

switch(mode)
	case 0
		index=strfind(str, delimiter);
		delimiterNum=length(index);
		tokenNum=delimiterNum+1;
		if delimiterNum==0; tokenList={str}; return; end
		tokenList=cell(1, tokenNum);
		tokenList{1}=str(1:index(1)-1);
		tokenList{end}=str(index(end)+1:end);
		for i=2:tokenNum-1
			tokenList{i}=str(index(i-1)+1:index(i)-1);
		end
	case 1
		index=strfind(str, delimiter);
		tokenList=cell(1, length(index)+1);
		k=1;
		beginPos=1;
		prevDef=0;
		for i=1:length(str)
			if str(i)==delimiter
				tokenList{k}=str(beginPos:i-1); k=k+1;
				prefDef=0;
				beginPos=i+1;
			end
			if str(i)~=delimiter && ~prevDef
				beginPos=i;
				prevDef=1;
			end 
		end
		if str(end)==delimiter
			tokenList{end}='';
		else
			tokenList{end}=str(beginPos:end);
		end
	case 2
		tokenList = {};
		remain = str;
		i = 1;
		while ~isempty(remain),
			[token, remain] = strtok(remain, delimiter);
			tokenList{i} = token;
			i = i+1;
		end
		% Get rid of the possible empty last element
		if isempty(tokenList{end})
			tokenList(end)=[];
		end
	otherwise
		error('Unknown mode!');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
