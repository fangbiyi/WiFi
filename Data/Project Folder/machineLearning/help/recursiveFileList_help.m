%% recursiveFileList
% List files with a given extension recursively
%% Syntax
% * 		allData=recursiveFileList(directoryList, extName)
% * 		allData=recursiveFileList(directoryList, extName, maxFileNumInEachDir)
%% Description
%
% <html>
% <p>recursiveFileList(directoryList, extName) returns all the files with the given extension name within the given directory or directory list.
% <p>recursiveFileList(directoryList, extName, maxFileNumInEachDir) returns all the files with the specs, but limit the number of files per sub-directory.
% </html>
%% Example
%%
%
data=recursiveFileList([matlabroot, '/toolbox/matlab'], 'm', 1)
