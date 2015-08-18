function mmData=mmDataCollect(mmDir, opt, showPlot)
% mmDataCollect: Collect multimedia data from a given directory
%
%	Usage:
%		mmData=mmDataCollect(mmDir)
%		mmData=mmDataCollect(mmDir, extName)
%		mmData=mmDataCollect(mmDir, extName, showPlot)
%
%	Description:
%		mmData=mmDataCollect(mmDir, extName, showPlot) returns a structure array of multimedia data that is collected from the given directory with given file extension names.
%			mmDir: Directory containing multimedia files
%			opt: Options for multimedia collection
%			showPlot: 1 for displaying multimedia of different opt.sepField in different figure windows.
%			mmData: A structure array of all the collected multimedia files
%
%	Example:
%		mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=mmDataCollect('defaultOpt');
%		opt.extName='pgm';
%		opt.montageSize=[nan, 10];
%		opt.newSize=[100, 100];
%		mmData=mmDataCollect(mmDir, opt, 1);
%
%	See also imFeaLbp, imFeaLgbp.

%	Category: Multimedia data processing
%	Roger Jang, 20140613

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(mmDir) && strcmpi(mmDir, 'defaultOpt')
	mmData.extName={'jpg', 'png'};
	mmData.sepField='class';	% For ploting different fields in different windows
	mmData.montageSize=[nan, 10];	% For myMontage
	mmData.newSize=[100, 100];	% For myMontage
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

flOpt=fileList('defaultOpt'); flOpt.extName=opt.extName;
mmData=fileList(mmDir, flOpt);

mmNum=length(mmData);
fprintf('Collecting %d files with extension "%s" from "%s"...\n', mmNum, opt.extName, mmDir);
if mmNum==0; mmData=[]; return; end

for i=1:mmNum
%	fprintf('%d/%d\n', i, mmNum);
	[parentDir, mainName, extName]=fileparts(mmData(i).path);
	mmData(i).class=mmData(i).parentDir;
end
uniqueClassName=unique({mmData.class});
for i=1:mmNum
	mmData(i).classId=find(strcmp(mmData(i).class, uniqueClassName));
end

if showPlot	
	allClassName={mmData.(opt.sepField)};
	uniqueClassName=unique(allClassName);
	if find(strcmp(opt.extName, {'png', 'jpg', 'pgm', 'bmp'}))
		for i=1:length(uniqueClassName)
			index=find(strcmp(uniqueClassName{i}, allClassName));
			figure; myMontage(mmData(index), opt);
			title(sprintf('%d files of extension "%s" of class "%s"', length(index), opt.extName, uniqueClassName{i}));
		end
	elseif find(strcmp(opt.extName, {'wav', 'mp3', 'aif', 'au'}))
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);