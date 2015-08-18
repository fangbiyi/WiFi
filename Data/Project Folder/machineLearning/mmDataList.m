function out=mmDataList(mmData, opt, showPlot)
% mmDataCollect: Collect multimedia data from a given directory
%
%	Usage:
%		out=mmDataList(mmData)
%		out=mmDataList(mmData, opt)
%
%	Description:
%		out=mmDataList(mmData, opt) creates a web page to display the classification results of a set of image/audio files
%			mmData: A structure array of all the collected multimedia files
%
%	Example:
%		mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=mmDataCollect('defaultOpt');
%		opt.extName='pgm';
%		mmData=mmDataCollect(mmDir, opt);
%		for i=1:length(mmData)
%			mmData(i).classPredicted=mmData(i).class;
%		end
%		listOpt=mmDataList('defaultOpt');
%		listOpt.listType='all';
%		mmDataList(mmData, listOpt);
%
%	See also mmDataCollect, dsCreateFromMm.

%	Category: Multimedia data processing
%	Roger Jang, 20140821

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(mmData) && strcmpi(mmData, 'defaultOpt')
	out.listType='misclassified';		% 'all' or 'misclassified'
	out.format='inline';		% 'inline' or 'singleHtmlPage';
	out.outputFile='mmDataList.htm';
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

% ====== Fill necessary fields
for i=1:length(mmData)
	mmData(i).gt2predicted=sprintf('%s ==> %s', mmData(i).class, mmData(i).classPredicted);
	mmData(i).hit=strcmp(mmData(i).class, mmData(i).classPredicted);
%	mmData(i).url=['../', mmData(i).path];
	mmData(i).url=path2url(mmData(i).path);
end

% ====== Use the right type
tableTitle=sprintf('List of %d cases', length(mmData));
if strcmp(opt.listType, 'misclassified')
	mmData=mmData(~[mmData.hit]);
	tableTitle=sprintf('List of %d misclassified cases', length(mmData));
end

[parentDir, mainName, extName]=fileparts(mmData(1).path);
switch(lower(extName))
	case {'.jpg', '.png', '.pgm', '.bmp'}
		output=structDispInHtml(mmData, tableTitle, {'name', 'gt2predicted', 'hit', 'url'}, {'File', 'GT ==> Predicted', 'Hit', 'url'},      [], opt.outputFile, {'url'});
	case {'.wav', '.mp3', '.m4a'}
		output=structDispInHtml(mmData, tableTitle, {'name', 'gt2predicted', 'hit', 'url'}, {'File', 'GT ==> Predicted', 'Hit', 'url'}, {'url'}, opt.outputFile);
	otherwise
		error(sprintf('Unknown extName: %s', extName));
end

if strcmp(opt.format, 'inline')
	output(output==10)=[];		% To avoid not being rendering as HTML
	disp(output);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
