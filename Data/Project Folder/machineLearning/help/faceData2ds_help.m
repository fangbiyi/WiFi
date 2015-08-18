%% faceData2ds
% Convert face data to a dataset of the standard format
%% Syntax
% * 		DS=faceData2ds(faceData)
% * 		DS=faceData2ds(faceData, faceNumPerPerson)
%% Description
%
% <html>
% <p>DS=faceData2ds(faceData) converts a structure array faceData to a dataset of the standard format.
% <p>DS=faceData2ds(faceData, faceNumPerPerson) limits the face number per person.
% </html>
%% Example
%%
%
imageDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=fileList('defaultOpt');
opt.extName='pgm';
opt.mode='recursive';
faceData=fileList(imageDir, opt);
fprintf('Reading %d face images from %s...', length(faceData), imageDir);
tic
for i=1:length(faceData)
%	fprintf('%d/%d: file=%s\n', i, length(faceData), faceData(i).path);
	faceData(i).image=imread(faceData(i).path);
end
fprintf(' ===> %.2f sec\n', toc);
DS=faceData2ds(faceData);
fprintf('Display DS...\n'); disp(DS);
