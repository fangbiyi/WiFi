function logA=myLog(A)
% myLog: 避免產生 log of zero 的警告訊息

%logA=log(A+eps);
logA=log(A+realmin);

%index=find(A==0);
%A(index)=eps;
%logA=log(A);
%logA(index)=-inf;