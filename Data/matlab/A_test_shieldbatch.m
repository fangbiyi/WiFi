% Biyi Fang
% 2015.8.17
% Find the 5 top waveform with most significant variance. Then display
% The gesture: use laptop to shield the antenna

csi_trace = read_bf_file('sample_data/shield.dat');
NUM_Tx = 2;
NUM_Rx = 3;
NUM_Subcarrier = 30;
x_abs = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier,length(csi_trace));

for j_Tx = 1 : NUM_Tx
    for j_Rx = 1 : NUM_Rx
        for j_Subcarrier = 1 : NUM_Subcarrier
            for j = 1 : length(csi_trace)
                csi_entry = csi_trace{j};
                csi = get_scaled_csi(csi_entry);
                x_cmplx = csi(j_Tx,j_Rx,j_Subcarrier);
                x_abs(j_Tx*j_Rx*j_Subcarrier,j) = abs(x_cmplx);
            end
        end
    end
end

var_csi = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier,1);
for j = 1 : NUM_Tx*NUM_Rx*NUM_Subcarrier
    var_csi(j) = var(x_abs(j,:));
end

figure(1)
plot(x_abs(28,:));
figure(2)
plot(x_abs(56,:));
figure(3)
plot(x_abs(100,:));
figure(4)
plot(x_abs(104,:));


