function x2=inputPass(x)
%inputWhiten: Pass the input to the output directly
%
%	Usage:
%		X2=inputPass(X)
%
%	Description:
%		X2=inputPass(X) passes the input X to the output X2 directly.
%
%	Example:
%		x=magic(5);
%		x2=inputPass(x);
%

%	Category: Dataset manipulation
%	Roger Jang, 20110214

if nargin<1, selfdemo; return; end
x2=x;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
