%% fileList
% File list of given directories with a given extension name
%% Syntax
% * 		opt=fileList('defaultOpt');
% * 		list=fileList(directoryList, opt)
%% Description
%
% <html>
% <p>fileList(directoryList, opt) returns all the files with the given directory (or directory list) according to the give options opt.
% 	<ul>
% 	<li>opt.extName: Extension names of the returned files.
% 	<li>opt.maxFileNumInEachDir: Max. no. of files of each directory to be returned.
% 	<li>opt.mode: 'recursive' or 'nonRecursive'
% 	</ul>
% <p>The default options can be obtain via "opt=fileList('defaultOpt')".
% </html>
%% Example
%%
%
opt=fileList('defaultOpt');
opt.extName='m';
opt.maxFileNumInEachDir=1;
opt.mode='recursive';
data=fileList([matlabroot, '/toolbox/matlab'], opt)
