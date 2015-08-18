function [minValue, minIndex] = minXy(mat)
%minxy: Minimum of a matrix
%	Usage: [minValue, minIndex] = minxy(A)
%		minValue: the minimum of the matrix A
%		minIndex: the 2D index of minValue in A
%
%	For example:
%		[minValue, minIndex]=minXy(magic(5))

%	Roger Jang, 20010219, 20071009

[colMin, colMinIndex] = min(mat);
[minValue, tmp] = min(colMin);
minIndex = [colMinIndex(tmp) tmp];