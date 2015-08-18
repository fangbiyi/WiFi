%% mmDataList
% Collect multimedia data from a given directory
%% Syntax
% * 		out=mmDataList(mmData)
% * 		out=mmDataList(mmData, opt)
%% Description
%
% <html>
% <p>out=mmDataList(mmData, opt) creates a web page to display the classification results of a set of image/audio files
% 	<ul>
% 	<li>mmData: A structure array of all the collected multimedia files
% 	</ul>
% </html>
%% Example
%%
%
mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=mmDataCollect('defaultOpt');
opt.extName='pgm';
mmData=mmDataCollect(mmDir, opt);
for i=1:length(mmData)
	mmData(i).classPredicted=mmData(i).class;
end
listOpt=mmDataList('defaultOpt');
listOpt.listType='all';
mmDataList(mmData, listOpt);
%% See Also
% <mmDataCollect_help.html mmDataCollect>,
% <dsCreateFromMm_help.html dsCreateFromMm>.
