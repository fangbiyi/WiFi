%% faceRecog
% Face recognition via eigenfaces or fisherfaces
%% Syntax
% * 		index=faceRecog(testImage, faceData)
% * 		index=faceRecog(testImage, faceData, frOpt)
%% Description
%
% <html>
% <p>index=faceRecog(testImage, faceData) returns the index of the closest image from the faceData, given the test image.
% <p>index=faceRecog(testImage, faceData, frOpt) specifies the options for face recognition via frOpt.
% </html>
%% Example
%%
%
imageDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=fileList('defaultOpt'); opt.extName='pgm'; opt.mode='recursive';
faceData=fileList(imageDir, opt);
fprintf('Reading %d face images from %s...', length(faceData), imageDir);
tic
for i=1:length(faceData)
%	fprintf('%d/%d: file=%s\n', i, length(faceData), faceData(i).path);
	faceData(i).image=imread(faceData(i).path);
end
fprintf(' ===> %.2f sec\n', toc);
testImage=faceData(1).image;		% Use the first face as the test image
faceData(1)=[];				% Remove the test image from faceData
index=faceRecog(testImage, faceData);	% Perform face recognition using default option
subplot(1,2,1); image(testImage); axis image
title('Query image');
subplot(1,2,2); image(faceData(index).image); axis image
title('Retrieved image');
