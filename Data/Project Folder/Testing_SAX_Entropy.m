
E = [];
for i = 1:(length(TEMP(:,3)) - 701)
    E = [E Entropy(TEMP(i:i+700,3))];
end

%% 
% close all
index_max_E = [];
for j = 1:3
    [symbolic_data, pointers] =  timeseries2symbol(TEMP(:,j)', 900, 500, 10);
    E = Entropy(symbolic_data');
    [nn, mm] = max(E);
    index_max_E = [index_max_E mm];
end
s_plt = max(index_max_E)-50;
figure;plot(TEMP(s_plt:700+s_plt+150,:))

%% SAX Demo
close all
LEN = 20;
START = 1;
ALPHABETS = 4;
floor(length(TEMP(START:end,2)')/LEN)
sax_demo(TEMP(START:(end-mod(length(TEMP(START:end,2)'),floor(length(TEMP(START:end,2)')/LEN))),2)',floor(length(TEMP(START:end,2)')/LEN),ALPHABETS)