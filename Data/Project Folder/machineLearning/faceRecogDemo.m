function faceRecogDemo(faceData, frOpt, testCaseNum)
% faceRecogDemo: Demo of face recognition using fisherfaces
%	Usage:
%		faceRecogDemo
%
%	Description:
%		faceRecogDemo starts face recognition demo, which randomly selects a face image and identifies a nearest one in the face database.
%
%	Example:
%		faceRecogDemo
%
%	See also faceData2ds, faceRecog.
%
%	Category: Face recognition
%	Roger Jang, 20110922

if nargin<1, load([mltRoot, '/dataSet/faceData.mat']); end
if nargin<2,
	frOpt.method='pca';
	frOpt.pcaDim=28;
	frOpt.method='pca+lda';
	frOpt.pcaDim=60;
	frOpt.ldaDim=12;
	frOpt.plot=1;
end
if nargin<3, testNum=1; end

faceNum=length(faceData);
for i=1:testNum
	index=ceil(rand*faceNum);
	testImage=faceData(index).image;
	faceData(index)=[];
	tic
	faceRecog(testImage, faceData, frOpt);
	fprintf('Method=%s\n', frOpt.method);
	fprintf('Time=%.2f sec\n', toc);
	if i~=testNum
		fprintf('Hit any key to continue...'); pause; fprintf('\n');
	end
end
