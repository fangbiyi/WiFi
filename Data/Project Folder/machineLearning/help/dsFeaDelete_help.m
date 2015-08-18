%% dsFeaDelete
% Delete same-value features from a given dataset
%% Syntax
% * 		[DS2, removedFeaIndex] = dsFeaDelete(DS)
%% Description
% 		DS2=dsFeaDelete(DS) deletes same-value features from the given dataset DS and return the new dataset in DS2.
%% Example
%%
%
DS.input=[1 2 3 9; 1 5 7 9; 1 8 2 9; 1 7 2 9; 1 3 5 9]';
[DS2, removedFeaIndex]=dsFeaDelete(DS);
fprintf('DS.input=\n'); disp(DS.input);
fprintf('[DS2, removedFeaIndex]==dsFeaDelete(DS) produces\n');
fprintf('DS2.input=\n'); disp(DS2.input);
fprintf('removedFeaIndex=\n'); disp(removedFeaIndex);
%% See Also
% <dsFormatCheck_help.html dsFormatCheck>.
