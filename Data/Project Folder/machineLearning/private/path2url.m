function url=path2url(pathStr)
% toAbsPath: Convert a disk path to an URL address
%
%	Usage:
%		url=path2url(pathStr)
%
%	Example:
%		url=path2url(which('qcTrain'));
%		web(url);

%	Roger Jang, 20140821

absPath=toAbsPath(pathStr);
absPath=strrep(absPath, '\', '/');

url=regexprep(absPath, '^d:/users/jang', 'http://mirlab.org/jang');
url=regexprep(url, '^/users/jang', 'http://mirlab.org/jang');
url=regexprep(url, '^d:/dataSet', 'http://mirlab.org/dataSet');
url=regexprep(url, '^/dataSet', 'http://mirlab.org/dataSet');
