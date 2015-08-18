function DS = dsClassMerge(DS, equivClass)
%dsClassMerge: Merge classes in a dataset
%
%	Usage:
%		DS2 = dsClassMerge(DS, equivClass)
%
%	Description:
%		DS2=dsClassMerge(DS, equivClass) returns a new DS2 which merges classes in DS based on equivClass.
%			DS: Original dataset
%			equivClass: A cell vector specifying which output to be combined. For instance, {[1 3], [2 4]} specifies outputs 1 & 3 to be combined into new output 1, and outputs 2 & 4 to be combined into new output 2.
%			DS2: New dataset with the combined outputs
%
%	Example:
%		DS=prData('iris');
%		DS2=dsClassMerge(DS, {[1,3], [2]})
%
%	See also dsClassSize.

%	Category: Dataset manipulation
%	Roger Jang, 20120115

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

% ====== Merge output
newOutput=0*DS.output;
for i=1:length(equivClass)
	for j=1:length(equivClass{i})
		newOutput(DS.output==equivClass{i}(j))=i;
	end
end
if ~all(newOutput), error('Error in %s', mfilename); end
DS.output=newOutput;
% ====== Merge predicted output
if isfield(DS, 'predictedOutput')
	newPredictedOutput=0*DS.predictedOutput;
	for i=1:length(equivClass)
		for j=1:length(equivClass{i})
			newPredictedOutput(DS.predictedOutput==equivClass{i}(j))=i;
		end
	end
	if ~all(newPredictedOutput), error('Error in %s', mfilename); end
	DS.predictedOutput=newPredictedOutput;
end
% ====== Merge output names
if isfield(DS, 'outputName')
	for i=1:length(equivClass)
		newOutputName{i}=join(DS.outputName(equivClass{i}), ' & '); 
	end
	DS.outputName=newOutputName;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
