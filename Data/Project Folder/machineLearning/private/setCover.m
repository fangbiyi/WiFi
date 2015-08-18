function [selectedIndex, coverRate] = setCover(scm, selectedNum, plotOpt)
%setCover: Min. set covering problem via greedy approach
%
%	Usage: 
%		[selectedIndex, coverRate] = setCover(scm, selectedNum)
%		scm: Set covering matrix, an indexing matrix indicating that
%			set i contain element scm(i,j). It can also be an incidence
%			matrix where scm(i,j)=1 indicates set i contains element j.
%		selectedNum: No. of selected set
%		selectedIndex: index of selected sets
%		coverRate: progressive cover rate (0 to 1) of the selected index
%
%	Example:
%		setNum=10000;
%		incidenceMat=sparse(rand(setNum, 411)>0.99);
%		selectedNum=100;
%		plotOpt=1;
%		[selectedIndex, coverRate] = setCover(incidenceMat, selectedNum, plotOpt);

%	Roger Jang, 20010222, 20110212

if nargin<1, selfdemo; return; end
if nargin<2, selectedNum=100; end
if nargin<3, plotOpt=0; end

setNum=size(scm, 1);
if islogical(scm)
	incidenceMat=scm;
else
	% Transform scm into a 0-1 incidence matrix, where each row is a document
	% and each column is a term. I(i,j)=1 indicate document i contains term j.
	elementNum = max(max(scm));
	incidenceMat=sparse(setNum, elementNum);
%	fprintf('Converting to incidence matrix...\n');
	for i=1:setNum,
	%	if rem(i, 1000)==0, fprintf('i = %g\n', i); end
		temp=scm(i, :);
		temp(find(temp==0))=[];		% 0 is don't-care
		incidenceMat(i, double(temp))=1;
	end
end
elementNum=size(incidenceMat, 2);

% Minimun set covering via greedy algorithm
selectedIndex=[];
origIndex=1:setNum;
coverRate=zeros(selectedNum, 1);
for i=1:selectedNum
	[junk, index]=max(sum(incidenceMat, 2));
%	fprintf('Selected index: %g\n', origIndex(index));
	selectedIndex=[selectedIndex; origIndex(index)];
	origIndex(index)=[];
	incidenceMat(:, incidenceMat(index,:))=[];
	incidenceMat(index, :)=[];
	coverRate(i)=1-size(incidenceMat,2)/elementNum;
	if coverRate(i)==1, break; end
%	fprintf('\tCoverage rate = %g%%\n', coverRate(i));
end
coverRate=coverRate(1:i);

if plotOpt
	plot(1:length(coverRate), 100*coverRate, '-o');
	xlabel('No. of selected sets');
	ylabel('Coverage rates (%)');
	grid on
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
