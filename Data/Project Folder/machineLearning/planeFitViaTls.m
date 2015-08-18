function coef=planeFitViaTls(data, showPlot)
% Plane fit via total lease-squares
%
%	Usage:
%		coef=planeFitViaTls(data, showPlot)
%
%	Description:
%		coef=planeFitViaTls(data) returns the hyperplane coef'*[x_1, x_2, ..., x_d, 1]=0 which achieves total least-squares via PCA (principal component analysis). 
%
%	Example:
%		% === Line fitting
%		x=[1.44  2.27  4.12  3.04  5.13  7.01  7.01 10.15  8.30  9.88];
%		y=[8.20 11.12 14.31 17.78 17.07 21.95 25.11 30.19 30.95 36.05];
%		data=[x; y];
%		coef=planeFitViaTls(data, 1);
%		% === Plane fitting
%		x=10*rand(1,100)-5;
%		y=10*rand(1,100)-5;
%		z=x+2*y+3+randn(size(x));
%		data=[x; y; z];
%		figure; coef=planeFitViaTls(data, 1);
%
%	See also PCA.

%	Category: Least squares
%	Roger Jang, 20140107

if nargin<1, selfdemo; return; end
if nargin<2, showPlot=0; end

mu=mean(data, 2);
data2=bsxfun(@minus, data, mu);		% Mean subtraction
[newDataset, eigVec, eigValue]=pca(data2);
lastEigVec=eigVec(:,end);
coef=[lastEigVec; -lastEigVec'*mu];

dim=size(data,1)-1;
if showPlot
	switch(dim)
		case 1
			x2=linspace(min(data(1,:)), max(data(1,:)));
			y2=(-coef(1)*x2-coef(3))/coef(2);
			plot(data(1,:), data(2,:), 'ro', x2, y2, 'b-'); axis image
			title('Line fit via total least-squares');
		case 2
			x2=linspace(min(data(1,:)), max(data(1,:)));
			y2=linspace(min(data(2,:)), max(data(2,:)));
			[xx2, yy2]=meshgrid(x2, y2);
			zz2=(-coef(1)*xx2-coef(2)*yy2-coef(4))/coef(3);
			mesh(xx2, yy2, zz2); axis tight;
			for i=1:size(data,2)
				line(data(1,i), data(2,i), data(3, i), 'marker', 'o');
			end
			title('Plane fit via total least-squares');
		otherwise
			fprintf('Plotting not support!\n');
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);