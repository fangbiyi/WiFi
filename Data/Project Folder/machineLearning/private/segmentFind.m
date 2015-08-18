function segment=segmentFind(inputVec)
% segmentFind: find positive segment in a vector
%	Usage: segment=segmentFind(inputVec)
%
%	For example:
%		x= [0 1 0 1 1 0 1 1 1 1 0];
%		segment=segmentFind(x);
%		fprintf('x = %s\n', mat2str(x));
%		for i=1:length(segment)
%			fprintf('Segment %d: %d~%d\n', i, segment(i).begin, segment(i).end);
%		end

%	Roger Jang, 20041021

if nargin<1, selfdemo; return; end

segment=[];
inputVec=inputVec(:)';
inputVec=inputVec>0;
start=find(diff([0, inputVec, 0])==1);
stop= find(diff([0, inputVec, 0])==-1)-1;
segmentNum=length(start);
for i=1:segmentNum
	segment(i).begin=start(i);
	segment(i).end=stop(i);
	segment(i).duration=stop(i)-start(i)+1;
end

% ====== Self demo
function selfdemo
x=randsrc(1, 10);
x(x==-1)=0;
fprintf('x = %s\n', mat2str(x));
out=feval(mfilename, x);
for i=1:length(out)
	fprintf('Segment %d: %d~%d\n', i, out(i).begin, out(i).end);
end

x=randn(1, 5);
fprintf('x = %s\n', mat2str(x));
out=feval(mfilename, x);
for i=1:length(out)
	fprintf('Segment %d: %d~%d\n', i, out(i).begin, out(i).end);
end