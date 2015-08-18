function [maxValue, maxIndex] = maxXy(mat)
%maxxy: Maximum of a matrix
%	Usage: [maxValue, maxIndex] = maxxy(A)
%		maxValue: the maximum of the matrix A
%		maxIndex: the 2D index of maxValue in A
%
%	For example:
%		[maxValue, maxIndex]=maxXy(magic(5))

%	Roger Jang, 20010219, 20071009

[colMax, colMaxIndex] = max(mat);
[maxValue, tmp] = max(colMax);
maxIndex = [colMaxIndex(tmp) tmp];