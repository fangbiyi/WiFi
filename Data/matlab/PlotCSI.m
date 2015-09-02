% Biyi Fang
% 2015.9.1
% It is a visualization function that pops top four biggest in variance.
% It is used usually after function CSIparse
% Example: PlotCSI(num_trace, amplitude, , phase, 4), we want top 4 in variance.

function [] = PlotCSI(num_trace, amplitude, TOP_amp, phase, TOP_ph)

% Input:
% num_trace:  
% amplitude:
% phase
% TOP: how many plots we want to plot. From biggest variance list.

% Output:

var_amplitude = zeros(num_trace, 1);
var_phase = zeros(num_trace, 1);

for j = 1 : num_trace
    var_amplitude(j) = var(amplitude(j,:));
    var_phase(j) = var(phase(j,:));   
end

if TOP_amp ~= 0
    figure(1);
end
for j = 1 : TOP_amp
    [a, Ind] = max(var_amplitude);
    var_amplitude(Ind) = 0;
    plot(amplitude(Ind,:))
    hold on;
end

if TOP_ph ~= 0
    figure(2);
end
for j = 1 : TOP_ph
    [a, Ind] = max(var_phase);
    var_phase(Ind) = 0;
    plot(phase(Ind,:))
    hold on;
end


  