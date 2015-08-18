function finalOutput=interpViaGaussian(x, sampleInput, sampleOutput)
%interpViaGaussian: Interpolation via normalized gaussian basis function
%
%	Usage:
%		finalOutput=interpViaGaussian(x, sampleInput, sampleOutput)
%
%	Description:
%		finalOutput=interpViaGaussian(x, sampleInput, sampleOutput) returns the interpolated value based on sampleInput and sampleOutput, using normalized Gaussian basis functions.
%			x: an input matrix whose output values are to be computed
%			sampleInput: sample input matrix where each column is a known data instance
%			sampleOutput: a vector of corresponding output values
%			finalOutput: interpolated output values corresponding to x
%
%	Example:
%		% === 1D example
%		sampleInput=[1 2 3 5 7 6];
%		sampleOutput=[3 5 6 7 8 7.5];
%		x=linspace(min(sampleInput), max(sampleInput));
%		y=0*x;
%		for i=1:length(y);
%			y(i)=interpViaGaussian(x(i), sampleInput, sampleOutput);
%		end
%		plot(sampleInput, sampleOutput, 'o', x, y);
%		legend('Sample data', 'Interpolated curve', 'Location', 'SouthEast');
%		% === 2D example
%		sampleData=[0 3 4; 1 4 2; 3 1 6; 2 4 3; 4 2 1; 2 3 1; 4 4 0];
%		sampleInput=[0 1 3 2 4 2 4;3 4 1 4 2 3 4];
%		sampleOutput=[4 2 6 3 1 1 0];
%		pointNum=20;
%		x=linspace(min(sampleInput(1,:)), max(sampleInput(1,:)), pointNum);
%		y=linspace(min(sampleInput(2,:)), max(sampleInput(2,:)), pointNum);
%		z=zeros(length(x), length(y));
%		for i=1:length(x)
%			for j=1:length(y)
%				z(j,i)=interpViaGaussian([x(i); y(j)], sampleInput, sampleOutput);
%			end
%		end
%		figure; mesh(x, y, z);
%		h=line(sampleInput(1,:), sampleInput(2,:), sampleOutput, 'marker', 'o', 'linestyle', 'none');
%		xlabel('X'); ylabel('Y'); zlabel('Z');
%		title('Interpolated surface');
%		view(120, 20);
%		box on
%		rotate3d on
%		axis tight
%
%	See also interpViaDistance.

%	Category: Interpolation and regression
%	Roger Jang, 20080726

if nargin<1, selfdemo; return; end

inputNum=size(sampleInput,1);
dataNum=size(sampleInput,2);
distance=zeros(1,dataNum);

% ====== Check the validity of the data
sameValueRowIndex=find(~any(diff(sampleInput, 1, 2), 2));
if ~isempty(sameValueRowIndex)
	error('Row %d in the sample input has the same value!\n', sameValueRowIndex);
end
[uniqRow, colCount]=rowCount(sampleInput');
uniqCol=uniqRow';
if any(colCount>1)
	error('Sample input has same-value tuples!');
end

% ====== Normalization of sample data to avoid numerical error
inputMin=min(sampleInput, [], 2);
inputMax=max(sampleInput, [], 2);
for i=1:inputNum
	sampleInput(i,:)=(sampleInput(i,:)-inputMin(i))/(inputMax(i)-inputMin(i));
end
% ====== Normalization of test data
x=(x-inputMin)./(inputMax-inputMin);

sigma=0.3;
% ====== Compute weight matrix of Gaussians
weight=zeros(dataNum, dataNum);
for i=1:dataNum,
	gPrm.mu=sampleInput(:,i); gPrm.sigma=sigma;
	weight(i,:)=gaussian(sampleInput, gPrm); 
end
% ====== Compute normalized weight matrix
normalizedWeight=weight*diag(1./sum(weight));
% ====== Compute desired output of each Gaussian
gaussianOutput=sampleOutput/normalizedWeight;
% ====== Compute the final output
weight=zeros(1, dataNum);
for i=1:dataNum
	gPrm.mu=sampleInput(:,i); gPrm.sigma=sigma;
	weight(i)=gaussian(x, gPrm); 
end
normalizedWeight=weight/sum(weight);
finalOutput=dot(normalizedWeight, gaussianOutput);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
