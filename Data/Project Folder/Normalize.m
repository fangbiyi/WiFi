%% Normalizer

clc
clear all

%% 
% mkdir('Data_4_new\','Var2');
WIN = 2; count = 1; ID1 = 't';
% for ID1 = ['qwertyuiopasdfghjklzxcvbnm'] %
Keys = 90:93;
DIR = 'Data_5_new\TX'; % 'Data_5_new\TX' Test_Data
M_DIR = 'TX'; % Data_5_new\meanSub\
for k = Keys
    for i = 1:2
        for j = 1:3
            load([DIR num2str(i) 'RX' ID1 '-' num2str(j) '-' 'key-' num2str(k) '.mat']);
%             TEMP = TEMP - repmat(mean(TEMP),length(TEMP),1); % Subtracting mean
%             TEMP = VarianceVector(TEMP,WIN); % Moving variance
%             for l = 1:4 
%                 TEMP(:,l) = (TEMP(:,l)-min(TEMP(:,l)))/(max(TEMP(:,l)-min(TEMP(:,l))));
%             end
%             figure;plot(TEMP)
            save([M_DIR num2str(i) 'RX' ID1 '-' num2str(j) '-' 'key-' num2str(k) '.mat'],'TEMP');
        end
    end
end
count = count + 1;
% end