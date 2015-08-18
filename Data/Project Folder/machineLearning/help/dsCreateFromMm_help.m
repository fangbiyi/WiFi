%% dsCreateFromMm
% Create DS from multimedia dataset
%% Syntax
% * 		ds=dsCreateFromMm(mmData, opt);
%% Description
%
% <html>
% </html>
%% Example
%%
% Create mmData
mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=mmDataCollect('defaultOpt');
opt.extName='pgm';
mmData=mmDataCollect(mmDir, opt);
%%
% Invoke dsCreateFromMm
opt2=dsCreateFromMm('defaultOpt');
ds=dsCreateFromMm(mmData, opt2);
