function DS=dsNameAdd(DS)
% dsNameAdd: Add names to a dataset if they are missing
%
%	Usage:
%		DS2=dsNameAdd(DS)
%
%	Description:
%		DS2=dsNameAdd(DS) returns a new dataset with necessary names for other dataset visualization function.
%
%	Example:
%		DS.input=rand(1,10);
%		DS.output=double(rand(1,10)>0.5)+1;
%		fprintf('Original DS:\n'); disp(DS)
%		DS2=dsNameAdd(DS);
%		fprintf('Final DS:\n'); disp(DS2);
%
%	See also dsFormatCheck, dsClassSize.

%	Category: Dataset manipulation
%	Roger Jang, 20110726

if nargin<1, selfdemo; return; end

[dim, dataNum]=size(DS.input);
if ~isfield(DS, 'dataName'), DS.dataName=''; end
if ~isfield(DS, 'inputName'), for i=1:dim, DS.inputName{i}=['Input-', int2str(i)]; end, end
if ~isfield(DS, 'annotation'), for i=1:dataNum, DS.annotation{i}=int2str(i); end, end
if isfield(DS, 'output') & ~isfield(DS, 'outputName')
	uniqueOutput=unique(DS.output);
	for i=1:length(uniqueOutput), DS.outputName{i}=['Output-', int2str(uniqueOutput(i))]; end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
