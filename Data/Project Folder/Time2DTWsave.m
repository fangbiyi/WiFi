function [] = Time2DTWsave(ID, No_Keys, no_DTW)

% DTW optimization parameters
DTW_OPT = struct;
DTW_OPT.type = 1;
DTW_OPT.endCorner = 1;
DTW_OPT.beginCorner = 1;
DTW_OPT.distanceBound = inf;

X = zeros(3,1151);
%% Time series to DTW
for TX = 1:2
    for g = 1:3
        count = 1;
        for PCA_comp = 1:3
            for k = 1:str2num(No_Keys)
                load(['TX' num2str(TX) 'RX' num2str(ID) '-' num2str(g) '-' 'key-' num2str(k) '.mat']);
                X(count,:) = TEMP(1:Size_lim,PCA_comp)';
                count = count + 1;
            end
            save(['TX' num2str(TX) 'RX' num2str(ID) '-' num2str(g) '-' 'key-' num2str(k) '.mat'], 'TEMP');
        end
    end
end

for l = 1:str2num(no_DTW)
    
    [TEMP1, ~] = dwt(XI, 'db4');
end
end