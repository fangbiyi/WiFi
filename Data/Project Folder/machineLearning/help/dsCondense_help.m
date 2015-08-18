%% dsCondense
% Data condensing
%% Syntax
% * 		DS2=dsCondense(DS)
% * 		DS2=dsCondense(DS, method)
% * 		DS2=dsCondense(DS, method, plotOpt)
%% Description
%
% <html>
% <p>DS2=dsCondense(DS) returns a reduced dataset using data condensing.
% <p>DS2=dsCondense(DS, method) uses the following methods to generate reduced dataset:
% 	<ul>
% 	<li>method='mcs' for the method of minimal consistent set (See ref [2])
% 	<li>method='random' for the method of random selection
% 	<li>method='loo' for the method of leave-one-out.
% 	</ul>
% <p>DS2=dsCondense(DS, method, plotOpt) plots the result after data condensing (if the dimension of the dataset is 2)
% </html>
%% References
% # 		P. E. Hart, ¡§The condensed nearest neighbor rule,¡¨ IEEE Trans. on Inform. Theory, vol. IT-14, pp. 515¡V516, May 1968.
% # 		B. V. Dasarathy, "Minimal consistent set (MCS) identification for optimal nearest neighbor decision systems design," IEEE Trans. on Systems, Man, Cybernetics, vol. 24, pp. 511¡V517, Mar. 1994.
%% Example
%%
%
DS=prData('peaks');
plotOpt=1;
DS2=dsCondense(DS, 'mcs', plotOpt);
%% See Also
% <dsEdit_help.html dsEdit>.
