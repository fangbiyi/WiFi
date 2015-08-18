function inputSelectPlot(allRecogRate, allSelectedInput, inputName, callingFunction);
% inputSelectPlot: Plot for input selection
%
%	Usage:
%		inputSelectPlot(allRecogRate, allSelectedInput, inputName, callingFunction);
%
%	Description:
%		inputSelectPlot(allRecogRate, allSelectedInput, inputName, callingFunction) plots the result of input selection
%
%	Example:
%		DS=prData('iris');
%		[bestSelectedInput, bestRecogRate, allSelectedInput, allRecogRate]=inputSelectSequential(DS);
%		inputSelectPlot(allRecogRate*100, allSelectedInput, DS.inputName, 'inputSelectSequential');

%	Category: Input selection
%	Roger Jang, 20041102

if nargin<1; selfdemo; return; end

modelNum=length(allRecogRate);
% ====== Display the results
x = (1:modelNum)';
clf;	% Clear all subplots
subplot(211);
plot(x, allRecogRate, '-', x, allRecogRate, 'ko');
tmp = x(:, ones(1, 3))';
X = tmp(:);
tmp = [zeros(modelNum, 1), allRecogRate(:), nan*ones(modelNum, 1)]';
Y = tmp(:);
hold on; plot(X, Y, 'g'); hold off;
[a, b] = max(allRecogRate);
hold on; plot(b, a, 'r*'); hold off;
axis([1 modelNum -inf inf]);
set(gca, 'xticklabel', []);
ylabel('LOO Recognition Rates (%)');
grid on
%h = findobj(gcf, 'type', 'line'); set(h, 'linewidth', 2)

% ====== Add text of input variables
for i=1:modelNum
	text(x(i), 0, strPurify(join(inputName(allSelectedInput{i}), ', ')));
end
h = findobj(gcf, 'type', 'text'); set(h, 'rot', 90, 'fontsize', 11, 'hori', 'right');
ylabel('Recognition rates (%)');
title(['Recognition rates using ', callingFunction, ': ', int2str(modelNum), ' Models']);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
