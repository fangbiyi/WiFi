function DS=faceData2ds(faceData, faceNumPerPerson)
% faceData2ds: Convert face data to a dataset of the standard format
%
%	Usage:
%		DS=faceData2ds(faceData)
%		DS=faceData2ds(faceData, faceNumPerPerson)
%
%	Description:
%		DS=faceData2ds(faceData) converts a structure array faceData to a dataset of the standard format.
%		DS=faceData2ds(faceData, faceNumPerPerson) limits the face number per person.
%
%	Example:
%		imageDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=fileList('defaultOpt');
%		opt.extName='pgm';
%		opt.mode='recursive';
%		faceData=fileList(imageDir, opt);
%		fprintf('Reading %d face images from %s...', length(faceData), imageDir);
%		tic
%		for i=1:length(faceData)
%		%	fprintf('%d/%d: file=%s\n', i, length(faceData), faceData(i).path);
%			faceData(i).image=imread(faceData(i).path);
%		end
%		fprintf(' ===> %.2f sec\n', toc);
%		DS=faceData2ds(faceData);
%		fprintf('Display DS...\n'); disp(DS);
%
%	Category: Face recognition
%	Roger Jang, 20110922

if nargin<1, selfdemo; return; end

faceNum=length(faceData);
[rowNum, colNum]=size(faceData(1).image);
DS.input=zeros(rowNum*colNum, faceNum);
for i=1:faceNum
	DS.input(:,i)=double(faceData(i).image(:));
end
DS.outputName=unique({faceData.parentDir});
DS.output=zeros(1, faceNum);
for i=1:faceNum
	DS.output(i)=find(strcmp(DS.outputName, faceData(i).parentDir));
	DS.annotation{i}=faceData(i).path;
end

if nargin>1
	DS2=DS;
	DS.input=[];
	DS.output=[];
	DS.annotation={};
	for i=1:length(DS2.outputName)
		index=find(DS2.output==i);
		usedIndex=index(1:min(faceNumPerPerson, length(index)));
		DS.input=[DS.input, DS2.input(:, usedIndex)];
		DS.output=[DS.output, DS2.output(:, usedIndex)];
		DS.annotation={DS.annotation{:}, DS2.annotation{usedIndex}};
	end
end


% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
