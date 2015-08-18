function gmm=gmmRead(gmmFile)
%gmmRead: Read GMM parameters from a file
%
%	Usage:
%		gmmPrm=gmmRead(gmmFile)
%
%	Description:
%		gmmPrm=gmmRead(gmmFile) returns the GMM parameters from a given GMM parameter file.
%
%	Example:
%		gmmPrm=gmmRead('example.gmm')
%
%	See also gmmWrite.

%	Category: GMM
%	Roger Jang, 20070903

if nargin<1, selfdemo; return; end

fid=fopen(gmmFile, 'r');
% ====== Read comments
target='<comment>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.comment=line;
% ====== Read version
target='<version>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.version=line;
% ====== Read gmmType
target='<gmmType>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.gmmType=eval(line);
% ====== Read name
target='<name>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.name=line;
% ====== Read dim
target='<dim>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.dim=eval(line);
% ====== Read mixNum
target='<mixNum>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.mixNum=eval(line);
% ====== Read mean
target='<mean>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
for i=1:gmm.mixNum
	line=fgetl(fid);
	gmm.mean(:,i)=eval(['[', line, ']']);
end
% ====== Read covariance
target='<covariance>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.covariance=eval(['[', line, ']']);
% ====== Read weight
target='<weight>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.prior=eval(['[', line, ']']);
% ====== Read gConst
target='<gConst>';
line=fgetl(fid);
if strcmp(line, target)==0, fprintf('line=%s\n', line); error('Cannot find "%s"!\n', target); end
line=fgetl(fid);
gmm.gConst=eval(['[', line, ']']);
fclose(fid);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
