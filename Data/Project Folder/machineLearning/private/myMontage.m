function out=myMontage(imData, opt)
% myMontage: Display a set of images with possibly different sizes
%
%	Usage:
%		out=myMontage(imData)
%		out=myMontage(imData, opt)
%
%	Description:
%		out=myMontage(imData, opt) plot the given imData using montage.
%
%	Example:
%		imDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=mmDataCollect('defaultOpt');
%		opt.extName='pgm';
%		opt.montageSize=[nan, 20];
%		imData=mmDataCollect(imDir, opt);
%		myMontage(imData, opt);
%
%	See also imFeaLbp, imFeaLgbp.

%	Category: Image data processing
%	Roger Jang, 20140613

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(imData) && strcmpi(imData, 'defaultOpt')
	out.montageSize=[];
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

if isempty(opt.montageSize)
	opt.montageSize=[nan, ceil(4*sqrt(length(imData)/12))];	% To have the aspect ratio of 3:4
end

if iscell(imData)		% imData is actually a cell string
	for i=1:length(imData)
		temp(i).path=imData{i};
	end
	imData=temp;
end

fileList={imData.path};
if ~isfield(imData, 'info')
	for i=1:length(imData)
		imData(i).info=imfinfo(imData(i).path);
	end
end
info=[imData.info];
width=[info.Width];
height=[info.Height];
if any(diff(width)) | any(diff(height))
	% Resize the images for display
	for i=1:length(imData)
		im=imread(imData(i).path);
		im2=imresize(im, [100, 100]);
		fileList{i}=[tempname, '.png'];
		imwrite(im2, fileList{i});
	end
end
out=[];

if isempty(opt.montageSize)
	ratio=0.6;
	side1=1;
	side2=round(side1/ratio);
	while side1*side2<length(imData)
		side1=side1+1;
		side2=round(side1/ratio);
	end
	opt.montageSize=[side1, side2];
end
montage(fileList, 'size', opt.montageSize);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
