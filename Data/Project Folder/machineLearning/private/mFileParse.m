function mObj=mFileParse(mFile)
%mFileParse: Parse an m-file into different components (especially for the comments).
%
%	Usage:
%		mObj=mFileParse(mFile)
%
%	Description:
%		This command parses the given m-file into several components.
%		It is primarily for converting the comments in the m-file into another help file.
%
%	Example:
%		mObj=mFileParse('mFileParse.m')
%
%	See also mFile2html.
%
%	Reference:
%		[1] This is a dummy reference.

%	Category: Utility
%	Roger Jang, 20100822

if nargin<1, selfdemo; return; end

contents=textread(mFile,'%s','delimiter','\n','whitespace','', 'bufsize', 20000);

index1=0;	% index for the first comment line
index2=0;	% index for the last comment line
inComments=0;
for i=1:length(contents)
	line=contents{i};
	if inComments==0 & (length(line)>0 & line(1)=='%')
		index1=i;
		inComments=1;
	end
	if inComments==1 & i==length(contents)
		index2=i;
		break;
	end
	if inComments==1 & (length(line)==0 | contents{i}(1)~='%')
		index2=i-1;
		inComments=0;
		break;
	end
end

if index1==0
	comments={};
else
	comments=contents(index1:index2);
end

mObj.mFile=mFile;
mObj.purpose='';
mObj.synopsis='';
mObj.description='';
mObj.example='';
mObj.reference='';
mObj.category='';
mObj.seeAlso='';

% ====== Get category
pattern = '%\s*Category:\s*(.*)\s*$';
for i=1:length(contents)
	line=contents{i};
	[start, finish, token] = regexp(line, pattern);
	if ~isempty(token)
		mObj.category=line(token{1}(1):token{1}(2));
		break;
	end
end
% ====== Get purpose (h1 help)
pattern = '%.*:\s*(.*)\s*$';
for i=1:length(comments)
	line=comments{i};
	[start, finish, token] = regexp(line, pattern);
	if ~isempty(token)
		mObj.purpose=line(token{1}(1):token{1}(2));
		break;
	end
end
% ====== Get "see also"
pattern = '%.*See also\s*(.*?)\.\s*$';
for i=1:length(comments)
	line=comments{i};
	[start, finish, token] = regexp(line, pattern);
	if ~isempty(token)
		mObj.seeAlso=line(token{1}(1):token{1}(2));
		break;
	end
end
if ~isempty(mObj.seeAlso)
	index=find(mObj.seeAlso==' ');
	mObj.seeAlso(index)=[];
	mObj.seeAlso=split(mObj.seeAlso, ',');
end

% ====== Get synopsis (usage)
mObj.synopsis=getBlockInComments(comments, '%.*Usage:\s*$', '% *$');
% ====== Get description
mObj.description=getBlockInComments(comments, '%.*Description:\s*$', '% *$');
% ====== Get example
mObj.example=getBlockInComments(comments, '%.*Example:\s*$', '% *$');
% === Get rid of "common" leading tab
nonTabIndex=ones(1,length(mObj.example));
for i=1:length(mObj.example)
	index=find(mObj.example{i}~=9);
	nonTabIndex(i)=index(1);
end
startIndex=min(nonTabIndex);
for i=1:length(mObj.example)
	mObj.example{i}=mObj.example{i}(startIndex:end);
end
% === Parse the example lines into several examples, if any
if isempty(mObj.example)
	mObj.exampleItem=[];
elseif length(mObj.example{1})<5 || ~strcmp(mObj.example{1}(1:5), '% ===')
	mObj.exampleItem.info='';
	mObj.exampleItem.code=mObj.example;
else
	exampleCount=0;
	for i=1:length(mObj.example)
		if length(mObj.example{i})>=5 && strcmp(mObj.example{i}(1:5), '% ===')
			exampleCount=exampleCount+1;
			mObj.exampleItem(exampleCount).info=mObj.example{i}(6:end);
			mObj.exampleItem(exampleCount).code={};
		else
			mObj.exampleItem(exampleCount).code={mObj.exampleItem(exampleCount).code{:}, mObj.example{i}};
		end
	end
end
% ====== Get reference
mObj.reference=getBlockInComments(comments, '%.*Reference:\s*$', '%\s*$');

% ====== Subfunction
function block=getBlockInComments(comments, pat1, pat2)
index1=0;
index2=0;
inBlock=0;
for i=1:length(comments)
	line=comments{i};
%	fprintf('i=%d, line=%s\n', i, line);
	[start, finish, token] = regexp(line, pat1);
	if inBlock==0 & ~isempty(start)
		index1=i+1;
%		fprintf('\ti=%d, line=%s\n', i, line);
		inBlock=1;
	end
	[start, finish, token] = regexp(line, pat2);
	if inBlock==1 & ~isempty(start)
		index2=i-1;
%		fprintf('\ti=%d, line=%s\n', i, line);
		break;
	end
end
if index1==0; block=[]; return; end
if index2==0; index2=length(comments); end
block=comments(index1:index2);
block=cleanComments(block);

function block=cleanComments(block)
for i=1:length(block)
	line=block{i};
%	[start, finish, token] = regexp(line, '^%\s*(.*?)\s*$');
	[start, finish, token] = regexp(line, '^%(.*?)\s*$');
	block{i}=line(token{1}(1):token{1}(2));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
