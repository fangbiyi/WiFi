function out = combine(obj, n)
%	out = combine(obj, n) returns combinations of obj with n distinct
%	elements.
%	For instance: combine([1 2 3 4 5], 2) or combine('abcde', 3).

%	Roger Jang, Sept-21-1996

if n>length(obj)
	out=[];
	return;
end
if n==1
	out = obj(:);
	return;
end
if n==length(obj)
	out = obj(:)';
	return;
end

out = [];
for i = 1:length(obj)-1,
	first = obj(i);
	tail = obj(i+1:end);
	tail_combinat = combine(tail, n-1);
	loop_out = [first*ones(size(tail_combinat,1), 1), tail_combinat]; 
	out = [out; loop_out];
end
