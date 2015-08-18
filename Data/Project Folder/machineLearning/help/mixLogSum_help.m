%% mixLogSum
% Compute the mixture log sum
%% Syntax
% * 		output=mixLogSum(input)
%% Description
%
% <html>
% <p>mixLogSum(input) returns log(e^x + e^y + e^z...) when input=[x, y,z..].
% <p>This function is more robust, For instance, compare the difference:
% 	<ul>
% 	<li>mixLogSum([-2000, -1999])
% 	<li>log(sum(exp([-2000, -1999])))
% 	</ul>
% <p>This function is primarily used for computing the log likelihood of a GMM. For efficiency, you can use the equivalent mixLogSumMex.mex* instead.
% </html>
%% Example
%%
%
fprintf('mixLogSum([-2000, -1999])=%f\n', mixLogSum([-2000, -1999]));
fprintf('log(sum(exp([-2000, -1999])))=%f\n', log(sum(exp([-2000, -1999]))));
