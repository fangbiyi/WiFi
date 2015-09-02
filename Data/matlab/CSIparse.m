% Biyi Fang
% 2015.8.28
% It is a postprocess function for getting amplitude and phase of any arbitrary "csi.dat" file
% Example: [length, amplitude, phase]= CSIparse('d/test5g2.dat', 1, 2, 1, 0, 0)

function [tracelength, amplitude, phase, num_trace] = CSIparse(filename, NUM_Tx, NUM_Rx, rate, START, END)
% Input:
% filename:  the path of target .dat file that contains raw csi.
% NUM_Tx: number of transmitters.
% NUM_Rx: number of receivers.
% rate: the packet rate. 
% START: begin evaluating after ingnore START seconds.If no need, put a '0'.
% END: stop evaluating END seconds before. If all length needs to be considered put a '0'.

% Output:
% tracelength: how many packet is measured
% amplitude: return amplitude of all channel * subcarrier set. **abs()
% phase: return phase of all channel * subcarrier set in a form of radian returns the phase angles, in radians. The angles lie between ?.




csi_trace = read_bf_file(filename);
% calculate the starts and ends time, in packet number.
starts = 1 + START / rate;
ends = length(csi_trace) - END / rate;
tracelength = ends - starts + 1 ;

NUM_Subcarrier = 30; % always the case
num_trace = NUM_Tx*NUM_Rx*NUM_Subcarrier;
amplitude = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier, tracelength);
phase = zeros(NUM_Tx*NUM_Rx*NUM_Subcarrier, tracelength);



for j_Tx = 1 : NUM_Tx
    for j_Rx = 1 : NUM_Rx
        for j_Subcarrier = 1 : NUM_Subcarrier
            for j = starts : ends
                csi_entry = csi_trace{j};
                csi = get_scaled_csi(csi_entry);
                x_cmplx = csi(j_Tx,j_Rx,j_Subcarrier);
                amplitude(j_Tx*j_Rx*j_Subcarrier,j - starts + 1) = abs(x_cmplx);
                phase(j_Tx*j_Rx*j_Subcarrier,j - starts + 1) = angle(x_cmplx);
            end
        end
    end
end

