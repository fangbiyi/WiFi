%% mmDataCollect
% Collect multimedia data from a given directory
%% Syntax
% * 		mmData=mmDataCollect(mmDir)
% * 		mmData=mmDataCollect(mmDir, extName)
% * 		mmData=mmDataCollect(mmDir, extName, showPlot)
%% Description
%
% <html>
% <p>mmData=mmDataCollect(mmDir, extName, showPlot) returns a structure array of multimedia data that is collected from the given directory with given file extension names.
% 	<ul>
% 	<li>mmDir: Directory containing multimedia files
% 	<li>opt: Options for multimedia collection
% 	<li>showPlot: 1 for displaying multimedia of different opt.sepField in different figure windows.
% 	<li>mmData: A structure array of all the collected multimedia files
% 	</ul>
% </html>
%% Example
%%
%
mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=mmDataCollect('defaultOpt');
opt.extName='pgm';
opt.montageSize=[nan, 10];
opt.newSize=[100, 100];
mmData=mmDataCollect(mmDir, opt, 1);
%% See Also
% <imFeaLbp_help.html imFeaLbp>,
% <imFeaLgbp_help.html imFeaLgbp>.
