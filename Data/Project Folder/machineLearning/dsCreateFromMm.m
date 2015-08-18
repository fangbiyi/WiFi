function ds=dsCreateFromMm(mmData, opt, showPlot)
% dsCreateFromMm: Create DS from multimedia dataset
%
%	Usage:
%		ds=dsCreateFromMm(mmData, opt);
%
%	Example:
%		% === Create mmData
%		mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=mmDataCollect('defaultOpt');
%		opt.extName='pgm';
%		mmData=mmDataCollect(mmDir, opt);
%		% === Invoke dsCreateFromMm
%		opt2=dsCreateFromMm('defaultOpt');
%		ds=dsCreateFromMm(mmData, opt2);

if nargin<1, selfdemo; return; end
if ischar(mmData) && strcmpi(mmData, 'defaultOpt')
	% === Set the default options for images
	ds.imReadFcn=@imread;
	ds.imFeaFcn=@imFeaLgbp;		% Feature function
	ds.imFeaOpt=feval(ds.imFeaFcn, 'defaultOpt');	% Feature options
	% === Set the default options for audios
	ds.auReadFcn=@waveFile2obj;
	ds.auFeaFcn=@auFeaMfcc;
	ds.auFeaOpt=feval(ds.auFeaFcn, 'defaultOpt');	% Feature options
	ds.auEpdFcn=@endPointDetect;
	ds.auEpdOpt=feval(ds.auEpdFcn, 'defaultOpt');
	ds.auEpdSelectionMethod='begin2end';		% 'begin2end' (from beginning segment to the ending segment) or 'maxDuration' (to select the segment with the maximum duration)
	ds.auShowEpdPlot=1;
	% === Common options
	ds.cumVarTh=90;		% Threshold of cumulative variance percentage in PCA
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

mmNum=length(mmData);
% Extract features
fprintf('Extracting features from each multimedia object...\n');
[parentDir, mainName, extName]=fileparts(mmData(1).path);

switch(lower(extName))
	case {'.jpg', '.png', '.pgm', '.bmp'}
		for i=1:mmNum
			fprintf('%d/%d: file=%s, ', i, mmNum, mmData(i).path); myTic=tic;
			mm=feval(opt.imReadFcn, mmData(i).path);
			mmData(i).fea=feval(opt.imFeaFcn, mm, opt.imFeaOpt);
			[dim, frameNum]=size(mmData(i).fea);
			fprintf('time=%g sec\n', toc(myTic));
		end
		fprintf('Creating ds...\n');
		ds.input=[mmData.fea];
		ds.output=[mmData.classId];
		ds.outputName=unique({mmData.class});
		ds.file={mmData.path};
	case {'.wav', '.mp3', '.m4a'}
		for i=1:mmNum
			fprintf('%d/%d: file=%s, ', i, mmNum, mmData(i).path); myTic=tic;
			mm=feval(opt.auReadFcn, mmData(i).path);
			if isfield(opt, 'auEpdFcn') & ~isempty(opt.auEpdFcn)	% Perform endpoint detection
				mm.signal=mean(mm.signal, 2);		% Stereo to mono
				if opt.auShowEpdPlot, figure; end
				[epInSample, junk, segment]=feval(opt.auEpdFcn, mm, opt.auEpdOpt, opt.auShowEpdPlot);
			%	fprintf('Press any key to continue...'); pause; fprintf('\n');
				switch(opt.auEpdSelectionMethod)
					case 'begin2end'
						mm.signal=mm.signal(epInSample(1):epInSample(2));
					case 'maxDuration'
						[maxDuration, maxIndex]=max([segment.duration]);
						mm.signal=mm.signal(segment(maxIndex).beginSample:segment(maxIndex).endSample);
					otherwise
						error(sprintf('Unknown epdSelectionMethod: %s', opt.epdSelectionMethod));
				end
			end
			mmData(i).fea=feval(opt.auFeaFcn, mm, opt.auFeaOpt);
			[dim, frameNum]=size(mmData(i).fea);
			mmData(i).output=mmData(i).classId*ones(1, frameNum);
			mmData(i).fileId=i*ones(1, frameNum);		% File ID, for aggregate prediction
			fprintf('time=%g sec\n', toc(myTic));
		end
		fprintf('Creating ds...\n');
		ds.input=[mmData.fea];
		ds.output=[mmData.output];
		ds.outputName=unique({mmData.class});
		ds.fileId=[mmData.fileId];
		ds.fileClassId=[mmData.classId];
		ds.file={mmData.path};
	otherwise
		error(sprintf('Unknown extName: %s', extName));
end


% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
