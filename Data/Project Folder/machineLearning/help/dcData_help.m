%% dcData
% Dataset generation for data clustering (no class label)
%% Syntax
% * 		DS = dcdata(dataId)
%% Description
%
% <html>
% <p>DS = dcdata(dataId) generate a dataset for data clustering.
% 	<ul>
% 	<li>dataId: an integer between 1 to 7 (inclusive).
% 	<li>DS: the returned dataset
% 	</ul>
% </html>
%% Example
%%
%
for i=1:6
	DS=dcData(i);
	subplot(2,3,i);
	dsScatterPlot(DS);
	title(['dataId = ', num2str(i)]);
end
%% See Also
% <prData_help.html prData>.
