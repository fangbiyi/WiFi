function list=fileList(directoryList, opt)
% fileList: File list of given directories with a given extension name
%
%	Usage:
%		opt=fileList('defaultOpt');
%		list=fileList(directoryList, opt)
%
%	Description:
%		fileList(directoryList, opt) returns all the files with the given directory (or directory list) according to the give options opt.
%			opt.extName: Extension names of the returned files.
%			opt.maxFileNumInEachDir: Max. no. of files of each directory to be returned.
%			opt.mode: 'recursive' or 'nonRecursive'
%		The default options can be obtain via "opt=fileList('defaultOpt')".
%
%	Example:
%		opt=fileList('defaultOpt');
%		opt.extName='m';
%		opt.maxFileNumInEachDir=1;
%		opt.mode='recursive';
%		data=fileList([matlabroot, '/toolbox/matlab'], opt)

%	Category: Utility
%	Roger Jang, 20030316, 20111118

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(directoryList) && strcmpi(directoryList, 'defaultOpt')
	list.extName='m';
	list.maxFileNumInEachDir=inf;
	list.mode='recursive';	% 'recursive' or 'nonrecursive'
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

if isstr(directoryList), directoryList={directoryList}; end
if isstr(opt.extName), opt.extName={opt.extName}; end

list=[];
if strcmpi(opt.mode, 'nonrecursive')
	for k=1:length(directoryList)
		directory=directoryList{k};
		% === Get files in the given directory
		if (directory(end)=='/') | (directory(end)=='\'); directory(end)=[]; end
		for j=1:length(opt.extName)
			data=dir([directory, '/*.', opt.extName{j}]);
			data=data(1:min(length(data), opt.maxFileNumInEachDir));
			for i=1:length(data)
				data(i).path=[directory, '/', data(i).name];
				[parentPath, junk, junk]=fileparts(data(i).path);
				[junk, data(i).parentDir, junk]=fileparts(parentPath);
			end
			list=[list; data];
		end
	end
end

if strcmpi(opt.mode, 'recursive')
	for j=1:length(opt.extName)
		data=recursiveFileList(directoryList, opt.extName{j}, opt.maxFileNumInEachDir);
		list=[list; data];
	end
end

if isempty(list)		% Create necessary fields even list is empty
	list(1).path='';
	list(1).parentDir='';
	list(1)=[];
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
