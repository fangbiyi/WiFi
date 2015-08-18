%% faceRecogPerfLoo
% 
%% Syntax
% * 		[recogRate, computedClass, correct, time]=faceRecogPerfLoo(faceData, opt)
%% Description
% 		[looRecogRate, computedClass, correct, time]=faceRecogPerfLoo(DS, opt) returns the results of face recognition using PCA + LDA.
%% Example
%%
%
load([mltRoot, '/dataSet/faceData.mat']);
DS=faceData2ds(faceData);
opt=faceRecogPerfLoo('defaultOpt');
[looRecogRate, computedClass, correct, time]=faceRecogPerfLoo(DS, opt);
fprintf('Overall recog. rate = %.2f%%\n', looRecogRate*100);
fprintf('Total time = %.2f sec\n', sum(time));
