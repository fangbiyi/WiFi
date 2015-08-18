%% dsNameAdd
% Add names to a dataset if they are missing
%% Syntax
% * 		DS2=dsNameAdd(DS)
%% Description
% 		DS2=dsNameAdd(DS) returns a new dataset with necessary names for other dataset visualization function.
%% Example
%%
%
DS.input=rand(1,10);
DS.output=double(rand(1,10)>0.5)+1;
fprintf('Original DS:\n'); disp(DS)
DS2=dsNameAdd(DS);
fprintf('Final DS:\n'); disp(DS2);
%% See Also
% <dsFormatCheck_help.html dsFormatCheck>,
% <dsClassSize_help.html dsClassSize>.
