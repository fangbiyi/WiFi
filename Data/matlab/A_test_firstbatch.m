% Biyi Fang
% 2015.8.15
% Test Visualize the first batch of data

csi_trace = read_bf_file('sample_data/shield.dat');
NUM_Tx = 1;
NUM_Rx = 1;
NUM_Subcarrier = 1;
x_abs = zeros(1,length(csi_trace));

for j = 1 : length(csi_trace)
    csi_entry = csi_trace{j};
    csi = get_scaled_csi(csi_entry);
    x_cmplx = csi(NUM_Tx,NUM_Rx,NUM_Subcarrier);
    x_abs(j) = abs(x_cmplx);
end

plot(x_abs);