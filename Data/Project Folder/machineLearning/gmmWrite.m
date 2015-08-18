function gmmWrite(gmm, gmmFile, useInt, weightSf)
%gmmWrite: Write the parameters of a GMM to a file
%
%	Usage:
%		gmmWrite(gmmPrm, gmmFile)
%		gmmWrite(gmmPrm, gmmFile, useInt)
%		gmmWrite(gmmPrm, gmmFile, useInt, weightSf)
%
%	Description:
%		gmmWrite(gmmPrm, gmmFile) writes the given GMM parameters in gmmPrm to a GMM parameter file. 
%		gmmWrite(gmmPrm, gmmFile, useInt) convert the parameters into integers before saving.
%		gmmWrite(gmmPrm, gmmFile, useInt, weightSf) uses scaling factor of weights (This should be the same as those used in goLog.m, goLogSum.m for generating C tables.)
%
%	Example:
%		DS=dcData(2);
%		trainingData=DS.input;
%		gmmOpt=gmmTrain('defaultOpt');
%		gmmOpt.config.gaussianNum=8;
%		gmmOpt.config.covType=1;
%		[gmmPrm, logLike]=gmmTrain(trainingData, gmmOpt);
%		gmm.gmmPrm=gmmPrm;
%		gmm.name='Test example';
%		gmmFile=[tempname, '.gmm'];
%		gmmWrite(gmm, gmmFile);
%		edit(gmmFile)

%	Category: GMM
%	Roger Jang, 20070627, 20080728

if nargin<1, selfdemo; return; end
if nargin<3, useInt=0; end
if nargin<4, weightSf=1; end

if ~isfield(gmm, 'name')
	gmm.name='None';
end

dim=length(gmm.gmmPrm(1).mu);
mixNum=length(gmm.gmmPrm);

fid=fopen(gmmFile, 'w');
fprintf(fid, '<comment>\r\n%s\r\n', 'Put your comments here!');
fprintf(fid, '<version>\r\n%s\r\n', '1.0');
fprintf(fid, '<gmmType>\r\n%d\r\n', 1);
fprintf(fid, '<name>\r\n%s\r\n', gmm.name);
fprintf(fid, '<dim>\r\n%d\r\n', dim);
fprintf(fid, '<mixNum>\r\n%d\r\n', mixNum);
% ====== Write mean
fprintf(fid, '<mean>\r\n');
for i=1:mixNum
	for j=1:dim
		if useInt==0
			fprintf(fid, '%e ', gmm.gmmPrm(i).mu(j));
		else
			fprintf(fid, '%d ', round(gmm.gmmPrm(i).mu(j)));
		end
	end
	fprintf(fid, '\r\n');
end
fprintf(fid, '<covariance>\r\n');
% ====== Write covariance
for i=1:mixNum
	if useInt==0
		fprintf(fid, '%e ', gmm.gmmPrm(i).sigma);
	else
		fprintf(fid, '%d ', round(gmm.gmmPrm(i).sigma));
	end
end
fprintf(fid, '\r\n');
% ====== Write weight
fprintf(fid, '<weight>\r\n');
for i=1:mixNum
	if useInt==0
		fprintf(fid, '%e ', gmm.gmmPrm(i).w);
	else
		fprintf(fid, '%d ', round(weightSf*gmm.gmmPrm(i).w));
	end
end
fprintf(fid, '\r\n');
% ====== Write gConst
fprintf(fid, '<gConst>\r\n');
for i=1:mixNum
	gConst=dim*log(2*pi*gmm.gmmPrm(i).sigma);
	if useInt==0
		fprintf(fid, '%e ', gConst);
	else
		fprintf(fid, '%d ', round(weightSf*gConst));
	end
end
fclose(fid);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);