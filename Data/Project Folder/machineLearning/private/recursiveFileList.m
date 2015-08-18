function allData=recursiveFileList(directoryList, extName, maxFileNumInEachDir)
% RecursiveFileList: List files with a given extension recursively
%
%	Usage:
%		allData=recursiveFileList(directoryList, extName)
%		allData=recursiveFileList(directoryList, extName, maxFileNumInEachDir)
%
%	Description:
%		recursiveFileList(directoryList, extName) returns all the files with the given extension name within the given directory or directory list.
%		recursiveFileList(directoryList, extName, maxFileNumInEachDir) returns all the files with the specs, but limit the number of files per sub-directory.
%
%	Example:
%		data=recursiveFileList([matlabroot, '/toolbox/matlab'], 'm', 1)

%	Category: Utility
%	Roger Jang, 20030316

if nargin<1, selfdemo; return; end
if nargin<3, maxFileNumInEachDir=inf; end
if isstr(directoryList); directoryList={directoryList}; end

allData=[];
for k=1:length(directoryList)
	directory=directoryList{k};

	% === Get files in the given directory
	if (directory(end)=='/') | (directory(end)=='\'); directory(end)=[]; end

	data=dir([directory, '/*.', extName]);
	data=data(1:min(length(data), maxFileNumInEachDir));

	for i=1:length(data)
		data(i).path=[directory, '/', data(i).name];
		[parentPath, junk, junk]=fileparts(data(i).path);
		[junk, data(i).parentDir, junk]=fileparts(parentPath);
	end
	
	% === Get files in sub-directories
	subdirs=dir(directory);
	subdirs=subdirs([subdirs.isdir]);	% Get directories only
	for i=1:length(subdirs),
		if strcmp(subdirs(i).name, '.'), continue; end
		if strcmp(subdirs(i).name, '..'), continue; end
		thisPath=[directory, '/', subdirs(i).name];
		data2=feval(mfilename, thisPath, extName, maxFileNumInEachDir);
		if length(data2)==0; data2=[]; end
		if length(data)==0; data=[]; end
		data=[data; data2];
	end
	allData=[allData; data];
end

if isempty(allData)		% Create necessary fields even allData is empty
	allData(1).path='';
	allData(1).parentDir='';
	allData(1)=[];
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
