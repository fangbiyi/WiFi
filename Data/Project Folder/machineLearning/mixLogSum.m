function output=mixLogSum(input)
% mixLogSum: Compute the mixture log sum
%
%	Usage:
%		output=mixLogSum(input)
%
%	Description:
%		mixLogSum(input) returns log(e^x + e^y + e^z...) when input=[x, y,z..].
%		This function is more robust, For instance, compare the difference:
%			mixLogSum([-2000, -1999])
%			log(sum(exp([-2000, -1999])))
%		This function is primarily used for computing the log likelihood of a GMM. For efficiency, you can use the equivalent mixLogSumMex.mex* instead.
%
%	Example:
%		fprintf('mixLogSum([-2000, -1999])=%f\n', mixLogSum([-2000, -1999]));
%		fprintf('log(sum(exp([-2000, -1999])))=%f\n', log(sum(exp([-2000, -1999]))));

%	Category: Utility
%	Roger Jang, 20070324

if nargin<1, selfdemo; return; end

%input=flipud(sort(input(:)));
output=input(1);
for i=2:length(input)
	if output<input(i)
		temp=output; output=input(i); input(i)=temp;
	end
	output=output+log(1+exp(input(i)-output));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
