function [f, p, r, accuracy, tpCount, fpCount, fnCount]=simSequence(computed, gt, tolerance, plotOpt)
% simSequence: Similarity between 2 sequences (e.g., for beat tracking)
%
%	Usage:
%		f=simSequence(computed, gt, tolerance)
%		f=simSequence(computed, gt, tolerance, plotOpt)
%		[f, p, r, accuracy, tpCount, fpCount, fnCount]=simSequence(...)
%
%	Description:
%		This function is often used to evaluate the similarity between two time sequences, for instance, beat positions generated from beat tracking of audio music.
%		f=simSequence(computed, gt, tolerance) returns the F-measure of two sequences (computed, gt) with the given tolerance.
%		f=simSequence(computed, gt, tolerance, 1) also plots the sequences for visualization.
%		[f, p, r, accuracy, tpCount, fpCount, fnCount]=simSequence(...) returns more info:
%			f: F-measure, equal to 2pr/(p+r) = tp/(tp+(fn+fp)/2)
%			p: precision, equal to tp/(tp+fp)
%			r: recall, equal to tp/(fp+fn)
%			accuracy: equal to tp/(fp+fn+tp)
%			tpCount: true-positive (hit) count
%			fpCount: false-positive (insertion) count
%			fnCount: false-negative (deletion) count
%
%	Example:
%		gt=[1 2 3 4 5];
%		computed=[0.5 2.1 3.1 4.5 5 6];
%		tolerance=0.15;
%		[f, p, r, accuracy, tp, fp, fn]=simSequence(computed, gt, tolerance, 1);
%		fprintf('Precision = tp/(tp+fp)=%d/(%d+%d) = %f\n', tp, tp, fp, p);
%		fprintf('Recall = tp/(tp+fn)=%d/(%d+%d) = %f\n', tp, tp, fn, r);
%		fprintf('F-measure = tp/(tp+(fn+fp)/2)=%d/(%d+(%d+%d)/2) = %f\n', tp, tp, fn, fp, f);
%		fprintf('Accuracy = tp/(tp+fn+fp)=%d/(%d+%d+%d) = %f\n', tp, tp, fn, fp, accuracy);

%	Category: Distance and similarity
%	Roger Jang, 20110813

if nargin<1, selfdemo; return; end
if nargin<4, plotOpt=0; end

gt=gt(:);
computed=computed(:);
gtNum=length(gt);
computedNum=length(computed);

diffMat=computed(:)*ones(1, gtNum)-ones(computedNum,1)*gt(:)';
inInterval=abs(diffMat)<=tolerance;

tpCount=sum(sum(inInterval,2));
fpCount=computedNum-tpCount;
fnCount=gtNum-tpCount;

p=tpCount/computedNum;
r=tpCount/gtNum;
if p==0|r==0
	f=0;
else
	f=2*p*r/(p+r);
end
accuracy=tpCount/(fpCount+fnCount+tpCount);

if plotOpt
	minValue=min([computed; gt]);
	maxValue=max([computed; gt]);
	height=(maxValue-minValue)/10;
	for i=1:length(computed)
		computedH(i)=line(computed(i)*[1 1], [0 -height], 'color', 'b');
		line(computed(i), -height, 'color', 'b', 'marker', '^');
	end
	for i=1:length(gt)
		gtH(i)=line(gt(i)*[1 1], [0 height], 'color', 'r');
		line(gt(i), height, 'color', 'r', 'marker', 'v');
		line(gt(i)+tolerance*[-1 1], [0 0], 'color', 'g', 'linewidth', 3);
	end
	line([minValue-height, maxValue+height], 0*[1 1], 'color', 'k');
	box on
	axis([minValue-height, maxValue+height, -height*2, height*2]);
	legend([computedH(1), gtH(1)], 'Computed', 'GT');
    
	tpIndex=find(sum(inInterval, 2)~=0);
	fpIndex=find(sum(inInterval, 2)==0);
	fnIndex=find(sum(inInterval, 1)==0);
	for i=tpIndex(:)', h=text(computed(i), -height-0.1, 'TP', 'horizontal', 'center', 'vertical', 'top'); end
	for i=fpIndex(:)', h=text(computed(i), -height-0.1, 'FP', 'horizontal', 'center', 'vertical', 'top'); end
	for i=fnIndex(:)', h=text(gt(i),        height+0.1, 'FN', 'horizontal', 'center', 'vertical', 'bottom'); end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
