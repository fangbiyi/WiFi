function [FPR DR]= Quality_rates(Actual_indices, Measured_indices, Len_Data)

% DR
I=intersect(Measured_indices,Actual_indices);
DR = length(I)/length(Actual_indices);


D=setdiff(Measured_indices,Actual_indices);
FPR=length(D)/Len_Data; % Dividing y data length

