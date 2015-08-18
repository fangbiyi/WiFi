function dpPathPlot4strMatch(str1, str2, lcsPath, lcsTable, prevx, prevy)
% dpPathPlot4strMatch: Plot the path of dynamic programming for string match.
%
%	Usage:
%		dpPathPlot4strMatch(str1, str2, lcsPath, lcsTable, prevx, prevy)
%
%	Description:
%		dpPathPlot4strMatch(str1, str2, lcsPath, lcsTable, prevx, prevy) plot the DP path of string match.
%		This is primarily used in lcs.m and editDistance.m.
%		To see the result, try "lcs" or "editDistance".
%
%	Example:
%		% === Display the edit distance between 2 strings:
%		editDistance;
%		% === Display the LCS (longest common distance) between 2 strings:
%		lcs;

%	Category: String match
%	Roger Jang, 20081009

m = length(str1);
n = length(str2);
%[xx, yy] = meshgrid(1:m, 1:n);
%plot(xx(:), yy(:), '.');
plot(nan, nan); axis([0 m+1 0 n+1]); box on; axis image
set(gca, 'xtick', 1:m);
set(gca, 'ytick', 1:n);
set(gca, 'xticklabel', str1(:));
set(gca, 'yticklabel', str2(:));
xlabel(['String1 = ', str1]);
ylabel(['String2 = ', str2]);
% === Plot bounding boxes for LCS table element
for i = 1:m
	for j = 1:n
		line(i, j, 'marker', 'square', 'markersize', 15, 'color', 'g', 'linestyle', 'none');
	end
end
% === Plot prevPos
for i=1:m
	for j=1:n
		now=i+j*sqrt(-1);
		next=prevx(i,j)+prevy(i,j)*sqrt(-1);
		start=now+(next-now)*0.2;
		stop =now+(next-now)*0.5;
		if prevx(i,j)>0 & prevy(i,j)>0
			arrowPlot(start, stop, [0 0 1]);
		end
	end
end
% === Plot DP path
for i=1:size(lcsPath,1)-1
	line(lcsPath(i:i+1, 1)+0.2, lcsPath(i:i+1, 2)-0.2, 'color', 'm', 'linewidth', 2);
end
% === Circle matched elements
for i=1:size(lcsPath,1)
	if str1(lcsPath(i,1))==str2(lcsPath(i,2))
		line(lcsPath(i,1), lcsPath(i,2), 'marker', 'o', 'markersize', 15, 'color', 'r', 'linestyle', 'none', 'linewidth', 2);
	end
end
% === Plot LCS table element
for i = 1:m
	for j = 1:n
		text(i, j, int2str(lcsTable(i,j)), 'hori', 'center');
	end
end
