function [perfData, bestClassifierIndex, bestClassifier, bestInputFunction]=perfCv4classifier(DS, opt, plotOpt)
% perfCv4classifier: Performance evaluation for various combinations of classifiers and input normalization schemes
%
%	Usage:
%		perfData=perfCv4classifier(DS, opt)
%		perfData=perfCv4classifier(DS, opt, plotOpt)
%		[perfData, bestClassifierIndex]=perfCv4classifier(DS, opt, plotOpt)
%		[perfData, bestClassifierIndex, bestClassifier, bestInputFunction]=perfCv4classifier(DS, opt, plotOpt)
%
%	Description:
%		perfData=perfCv4classifier(DS, opt) tries out various classifiers combined with various schemes of input normalization to derive the leave-one-out accuracy.
%
%	Example:
%		DS=prData('iris');
%		opt=perfCv4classifier('defaultOpt');
%		opt.foldNum=10;
%		[perfData, bestId]=perfCv4classifier(DS, opt, 1);
%		structDispInHtml(perfData, 'Performance of various classifiers via cross validation');
%		% === Display the confusion matrix
%		confMat=confMatGet(DS.output, perfData(bestId).bestComputedClass);
%		opt=confMatPlot('defaultOpt');
%		opt.className=DS.outputName;
%		figure; confMatPlot(confMat, opt);
%
%	See also perfCv, perfLoo.

%	Category: Performance evaluation
%	Roger Jang, 20120507

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	perfData.classifiers={'nbc', 'qc', 'src', 'knnc', 'gmmc', 'linc', 'svmc'};
	perfData.inputFunctions={'inputPass', 'inputNormalize', 'inputWhiten'};
	perfData.foldNum=10;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end

for j=1:length(opt.inputFunctions)
	DS3=DS;
	inputFunction=opt.inputFunctions{j};
	DS3.input=feval(inputFunction, DS3.input);
	for i=1:length(opt.classifiers)
		perfData(i).classifier=opt.classifiers{i};
		myTic=tic;
		try
		%	rr=perfLoo(DS3, perfData(i).classifier);
			[rr, tRrOverall, vRr, tRr, computedClass]=perfCv(DS3, perfData(i).classifier, [], opt.foldNum);
			perfData(i).errorMessage='';
        catch ME
			rr=nan;
			computedClass=[];
			perfData(i).errorMessage=ME.message;
		end
		time=toc(myTic);
		perfData(i).rr(j)=rr;
		perfData(i).computedClass{j}=computedClass;
		perfData(i).time(j)=time;
%{
	%	perfData(i)=setfield(perfData(i), sprintf('rrVia%s', inputFunction), rr);
		cmd=['perfData(i).', sprintf('rrVia%s', inputFunction), '=rr;'];
		eval(cmd);
	%	perfData(i)=setfield(perfData(i), sprintf('rrVia%sTime', inputFunction), time);
		cmd=['perfData(i).', sprintf('rrVia%sTime', inputFunction), '=time;'];
		eval(cmd);
	%	fprintf('RR=%g%% via %s\n', recogRate*100, perfData(i).classifier);
%}
	end
end

% ====== Compute the average computation time
for i=1:length(opt.classifiers)
	perfData(i).avgTime=mean(perfData(i).time);
	[perfData(i).maxRr, maxIndex]=max(perfData(i).rr);
	perfData(i).bestInputFunction=opt.inputFunctions{maxIndex};
	perfData(i).bestComputedClass=perfData(i).computedClass{maxIndex};
end
[maxRr, bestClassifierIndex]=max([perfData.maxRr]);
bestClassifier=opt.classifiers{bestClassifierIndex};
bestInputFunction=perfData(bestClassifierIndex).bestInputFunction;
str=sprintf('Max RR=%f%%, bestClassifier=%s, bestInputFunction=%s', maxRr*100, bestClassifier, bestInputFunction);

if plotOpt
	rr=cat(1, perfData.rr);
	subplot(211); bar(rr*100); grid on
	set(gca, 'xticklabel', opt.classifiers);
	ylabel('Recog. rates (%)');
	title(sprintf('RR vs. classifiers (%s)', str));
	legend(opt.inputFunctions, 'location', 'northOutside', 'orientation', 'horizontal');
	time=cat(1, perfData.time);
	subplot(212); bar(time); grid on
	set(gca, 'xticklabel', opt.classifiers);
	xlabel('Classifiers');
	ylabel('Computation time (sec)');
	title('Time vs. classifiers');
	legend(opt.inputFunctions, 'location', 'northOutside', 'orientation', 'horizontal');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
