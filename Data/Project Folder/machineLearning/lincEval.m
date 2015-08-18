function [lincOutput, recogRate, errorIndex1, errorIndex2, regOutput, regError]=lincEval(DS, coef)
% lincEval: Evaluation of linear classifier
%
%	Usage:
%		[lincOutput, recogRate, errorIndex1, errorIndex2, regOutput, regError]=lincEval(DS, coef)
%
%	Description:
%		lincOutput=lincEval(DS, coef) returns the evaluation result of a linear classifier based on the given dataset DS and coefficients coef.
%
%	Example:
%		DS=prData('linSeparable');
%		coef=lincTrain(DS);
%		output=lincEval(DS, coef);
%		fprintf('Recog. rate = %.2f%%\n', 100*sum(output==DS.output)/length(output));
%
%	See also lincTrain, lincEval, lincOptSet.

%	Category: Linear classifier
%	Roger Jang, 20041106, 20101231

if nargin<1, selfdemo; return; end

[dim, dataNum]=size(DS.input);
% Preapre A matrix for A*x=desired
regOutput=coef'*[DS.input; ones(1, dataNum)];	% Regression output
lincOutput=ones(1, dataNum);			% Classification output
lincOutput(regOutput>1.5)=2;			% lincOutput is -1 or 1

if isfield(DS, 'output')
	recogRate=sum(lincOutput==DS.output)/dataNum;		% Classification recognition rate
	errorIndex1=find(DS.output<1.5 & lincOutput>1.5);	% - ===> +
	errorIndex2=find(DS.output>1.5 & lincOutput<1.5);	% + ===> -
	regError=sum((regOutput-DS.output).^2);				% Regression MSE
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
