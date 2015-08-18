%% dsClassMerge
% Merge classes in a dataset
%% Syntax
% * 		DS2 = dsClassMerge(DS, equivClass)
%% Description
%
% <html>
% <p>DS2=dsClassMerge(DS, equivClass) returns a new DS2 which merges classes in DS based on equivClass.
% 	<ul>
% 	<li>DS: Original dataset
% 	<li>equivClass: A cell vector specifying which output to be combined. For instance, {[1 3], [2 4]} specifies outputs 1 & 3 to be combined into new output 1, and outputs 2 & 4 to be combined into new output 2.
% 	<li>DS2: New dataset with the combined outputs
% 	</ul>
% </html>
%% Example
%%
%
DS=prData('iris');
DS2=dsClassMerge(DS, {[1,3], [2]})
%% See Also
% <dsClassSize_help.html dsClassSize>.
