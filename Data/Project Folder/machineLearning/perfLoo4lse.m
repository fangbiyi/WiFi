function [trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt)

if nargin<3, plotOpt=0; end

[dataNum, feaDim]=size(A);
testMae=zeros(dataNum, 1);
trainMae=zeros(dataNum, 1);

for i=1:dataNum
	hiddenA=A(i,:);
	hiddenB=b(i,:);
	A2=A; A2(i,:)=[];
	b2=b; b2(i,:)=[];
	x=A2\b2;
	trainMae(i)=mean(abs(b2-A2*x));
	testMae(i)=abs(abs(hiddenB-hiddenA*x));
end
trainMaeMean=mean(trainMae);
testMaeMean=mean(testMae);

if plotOpt
	plot(1:dataNum, trainMae, 1:dataNum, testMae);
	legend('Training MAE', 'Test MAE');
	title(sprintf('trainMaeMean=%g, testMaeMean=%g', trainMaeMean, testMaeMean));
end
