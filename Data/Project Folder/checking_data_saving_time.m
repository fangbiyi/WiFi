function [] = checking_data_saving_time(File_name)
%input

%sample calling:
% wifi_reader_fazlay('1', '.\Kamran_Pass\Kamran_Pass_3.dat', '100', '13000', '0', '0.8', '200', '300', '0.055','0.063', '0.055','0.063','2','4','1','1','Authenticate_Ali')

Mov_avg_Len = 1; % Averaging readings over Mov_avg_Len*0.4ms
Param = 'Left';
w = -pi:0.01*pi:pi;
SubCarr = 30;
csi_trace = read_bf_file(File_name);

assignin('base', 'csi_trace', csi_trace);

START = 0;
END = length(csi_trace)-1000;%length(csi_trace)-1000;
data_size = END - START + 1; % processing over a smaller window of full time series

%% CSI collection, absolute values
csi = [];
Squeezed1 = zeros(3, 30*data_size); % 1st Tx
Squeezed2 = zeros(3, 30*data_size); % 2nd Tx
c1 = 1;
c2 = 0;
for i = START:END
    csi = [csi; get_scaled_csi(csi_trace{i,1})]; % This adds nTx x nRx x 30 things
    
    % For 1st Transmit antenna
    Squeezed1(:,1+(i-START)*30:(i-START+1)*30) = abs(squeeze(csi(c1,:,:))); % 1+(i-1)30:i*30
    %     Squeezed1 = [Squeezed1 abs(squeeze(csi(c1,:,:)))]; % will become 3x30*data_size matrix, 3 = three
    % rx antennas
    c1 = c1 + csi_trace{i,1}.Ntx; % Tx = 1
    
    % Some times 2 antenna transmit, sometimes 1.
    % This makes sure we get value for the same antenna again.
    
    % For 1st Transmit antenna
    if (csi_trace{i,1}.Ntx-1 == 1)
        %         c2 = c2 + 2*(csi_trace{i,1}.Ntx-1); % Tx = 2
        c2 = c2 + 2;
        Squeezed2(:,1+(i-START)*30:(i-START+1)*30) = abs(squeeze(csi(c2,:,:)));
    else
        c2 = c2 + 1;
        Squeezed2(:,1+(i-START)*30:(i-START+1)*30) = 0;
    end
    
    if (mod(i,500) == 0)
        display(i) % display progress
    end
end

assignin('base', 'Squeezed1', Squeezed1);
assignin('base', 'Squeezed2', Squeezed2);