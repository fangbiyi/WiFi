function DS = dcData(dataId)
% dcData: Dataset generation for data clustering (no class label)
%
%	Usage:
%		DS = dcdata(dataId)
%
%	Description:
%		DS = dcdata(dataId) generate a dataset for data clustering.
%			dataId: an integer between 1 to 7 (inclusive).
%			DS: the returned dataset
%
%	Example:
%		for i=1:6
%			DS=dcData(i);
%			subplot(2,3,i);
%			dsScatterPlot(DS);
%			title(['dataId = ', num2str(i)]);
%		end
%
%	See also prData.

%	Category: Dataset generation
%	Roger Jang

if nargin<1, selfdemo; return; end

if dataId==1
	n=100;
	d1=randn(2,n)*0.25+[1; 1.5]*ones(1,n);
	d2=randn(2,n)*0.25+[2; 0.0]*ones(1,n);
	d3=randn(2,n)*0.25+[1;-1.5]*ones(1,n);
	DS.clusterNum = 6;
	DS.input = [d1 d2 d3 -d1 -d2 -d3];
elseif dataId==2
	d1=randn(2, 4000);
	mag = sqrt(sum(d1.^2));
	DS.clusterNum = 8;
	DS.input = d1(:, mag>0.4 & mag<1.0);
elseif dataId==3
	d1 = randn(2,1000)*.5;
	d2 = randn(2,1500)*5 + 10;
	d3 = randn(2,2000)*7 + 30;
	DS.clusterNum = 3;
	DS.input = [d1 d2 d3];
elseif dataId==4
	multiplier=1;
	d1 = randn(2,500*multiplier)*20+[50;  0]*ones(1,500*multiplier);
	d2 = randn(2,200*multiplier)*3 +[20; 35]*ones(1,200*multiplier);
	d3 = randn(2,200*multiplier)*3 +[10;  5]*ones(1,200*multiplier);
	DS.clusterNum = 3;
	DS.input = [d1 d2 d3];
elseif dataId==5	
	dataNum = 150;
	data1 = ones(dataNum, 1)*[0 0] + randn(dataNum, 2)/5;
	data2 = ones(dataNum, 1)*[0 1] + randn(dataNum, 2)/5;
	data3 = ones(dataNum, 1)*[1 0] + randn(dataNum, 2)/5;
	data4 = ones(dataNum, 1)*[1 1] + randn(dataNum, 2)/5;
	DS.clusterNum = 4;
	DS.input = [data1; data2; data3; data4]';
elseif dataId==6
	n=100;
	dim=2;
	c1 = [0.125 0.25]'; data1 = randn(dim,n)/8 + c1*ones(1,n);
	c2 = [0.625 0.25]'; data2 = randn(dim,n)/8 + c2*ones(1,n);
	c3 = [0.375 0.75]'; data3 = randn(dim,n)/8 + c3*ones(1,n);
	c4 = [0.875 0.75]'; data4 = randn(dim,n)/8 + c4*ones(1,n);
	DS.clusterNum = 4;
	DS.input = [data1, data2, data3, data4];
elseif dataId==7
	dataNum = 300;
	data = randn(1,dataNum)+j*randn(1,dataNum)/3;
	data = data*exp(j*pi/6);	% 旋轉30度
	data = data-mean(data);		% 平均值等於零
	DS.clusterNum=3;
	DS.input=[real(data); imag(data)];
elseif dataId==8	% 一維資料！
	dataNum = 1000;
	data1 = randn(1,2*dataNum);
	data2 = randn(1,3*dataNum)/2+2;
	data3 = randn(1,1*dataNum)/3-2;
	DS.clusterNum=3;
	DS.input = [data1, data2, data3];
elseif dataId==9	% 一維資料！
	dataNum = 100;
	data1 = randn(1,2*dataNum);
	data2 = randn(1,3*dataNum)/2+3;
	data3 = randn(1,1*dataNum)/3-3;
	data4 = randn(1,1*dataNum)+6;
	data = [data1, data2, data3, data4];
	DS.clusterNum=4;
	DS.input = [data1, data2, data3, data4];
else
	error('Unknown Data ID!')
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
