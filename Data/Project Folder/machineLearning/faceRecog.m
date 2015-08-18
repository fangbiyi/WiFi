function index=faceRecog(testImage, faceData, frOpt)
% faceRecog: Face recognition via eigenfaces or fisherfaces
%	Usage:
%		index=faceRecog(testImage, faceData)
%		index=faceRecog(testImage, faceData, frOpt)
%
%	Description:
%		index=faceRecog(testImage, faceData) returns the index of the closest image from the faceData, given the test image.
%		index=faceRecog(testImage, faceData, frOpt) specifies the options for face recognition via frOpt.
%
%	Example:
%		imageDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=fileList('defaultOpt'); opt.extName='pgm'; opt.mode='recursive';
%		faceData=fileList(imageDir, opt);
%		fprintf('Reading %d face images from %s...', length(faceData), imageDir);
%		tic
%		for i=1:length(faceData)
%		%	fprintf('%d/%d: file=%s\n', i, length(faceData), faceData(i).path);
%			faceData(i).image=imread(faceData(i).path);
%		end
%		fprintf(' ===> %.2f sec\n', toc);
%		testImage=faceData(1).image;		% Use the first face as the test image
%		faceData(1)=[];				% Remove the test image from faceData
%		index=faceRecog(testImage, faceData);	% Perform face recognition using default option
%		subplot(1,2,1); image(testImage); axis image
%		title('Query image');
%		subplot(1,2,2); image(faceData(index).image); axis image
%		title('Retrieved image');
%
%	Category: Face recognition
%	Roger Jang, 20110922


if nargin<1, selfdemo; return; end
if nargin<2, load faceData.mat; end
if nargin<3
	frOpt.method='pca';
	frOpt.pcaDim=28;
	frOpt.method='pca+lda';
	frOpt.pcaDim=60;
	frOpt.ldaDim=12;
	frOpt.plot=1;
end

meanFace=mean(double(cat(3, faceData.image)), 3);
[rowDim, colDim]=size(meanFace);

if frOpt.plot
	clf;
	subplot(1,2,1); imshow(testImage);
	title('Query image', 'FontWeight', 'bold', 'Fontsize', 16, 'color', 'b');
	subplot(1,2,2); imshow(testImage*0);
	title('Computing...', 'FontWeight', 'bold', 'Fontsize', 16, 'color', 'b');
	drawnow
end

for i=1:length(faceData)
	faceData(i).imageZeroMean=double(faceData(i).image)-meanFace;
end
A=reshape(cat(3,faceData.imageZeroMean), rowDim*colDim, length(faceData));
[A2, pcaEigVec, pcaEigValue]=pca(A, frOpt.pcaDim);
testSig=pcaEigVec'*(double(testImage(:))-meanFace(:));
for i=1:length(faceData)
	faceData(i).sig=pcaEigVec'*faceData(i).imageZeroMean(:);
end

switch lower(frOpt.method)
	case {'pca'}		
		distVec=distSqrPairwise(testSig, [faceData.sig]);
		[minDist, index]=min(distVec);
	case 'pca+lda'
		% === Create DS2 for LDA
		DS2=faceData2ds(faceData);
		DS2.input=A2;
		[DS3, ldaEigVec]=lda(DS2, frOpt.ldaDim);
		% ====== Process the test data
		testSig=ldaEigVec'*testSig;
		for i=1:length(faceData)
			faceData(i).sig=ldaEigVec'*faceData(i).sig;
		end
		distVec=distSqrPairwise(testSig, [faceData.sig]);
		[minDist, index]=min(distVec);
	otherwise
		disp('Unknown method!')
end

if frOpt.plot
	subplot(1,2,2); imshow(faceData(index).image);
	title('Found image', 'FontWeight', 'bold', 'Fontsize', 16, 'color', 'b');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
