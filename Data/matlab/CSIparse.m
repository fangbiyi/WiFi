% Biyi Fang
% 2015.8.28
% It is a postprocess function for getting amplitude and phase of any arbitrary "csi.dat" file

function [tracelength, amplitude, phase] = CSIparse(filename, rate)
% input:
% filename is the path of target .dat file that contains raw csi.
% rate: the packet rate. right now it is added just to occupy a spot.

% output:
% tracelength: how many packet is measured
% amplitude: return amplitude of all channel * subcarrier set. **abs()
% phase: return phase of all channel * subcarrier set in a form of radian
% [continued] returns the phase angles, in radians. The angles lie between ±?.

csi_trace = read_bf_file(filename);
NUM_Tx = 2;
NUM_Rx = 3;
NUM_Subcarrier = 30;
amplitude = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier, length(csi_trace));
phase = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier, length(csi_trace));

tracelength = length(csi_trace);


for j_Tx = 1 : NUM_Tx
    for j_Rx = 1 : NUM_Rx
        for j_Subcarrier = 1 : NUM_Subcarrier
            for j = 1 : length(csi_trace)
                csi_entry = csi_trace{j};
                csi = get_scaled_csi(csi_entry);
                x_cmplx = csi(j_Tx,j_Rx,j_Subcarrier);
                amplitude(j_Tx*j_Rx*j_Subcarrier,j) = abs(x_cmplx);
                phase(j_Tx*j_Rx*j_Subcarrier,j) = angle(x_cmplx);
            end
        end
    end
end

