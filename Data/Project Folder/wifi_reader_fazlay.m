function [] = wifi_reader_fazlay(Activity, File_name, STARTING, ENDING, END_GIVEN, CHANGE, B_WINDOW, P_START, FI1, FI2, FA1, FA2, COMP_SHIFT, PCA_COMPS,doPlot,mMakeFolder,mFolderName)
%input
%Activity = Movement being detected.
%File_name = Input data containing CSI time series data.
%STARTING = Where to start processing data.
%ENDING = Where to end processing data.
%END_GIVEN = Flag to tell if ENDING value is explicitly provided or not.
%CHANGE= 
%B_WINDOW=
%P_START = After processing, this is the starting point of time series which will be saved at the end.
%FI1=
%FI2=
%FA1=
%FA2=
%COMP_SHIFT= Where to start picking 3 PCA components. If e.g. COMP_SHIFT = 2 and PCA_COMPS = 4, you get components 2-3-4
%PCA_COMPS = Last PCA component. If COMP_SHIFT = 2, and PCA_COMPS = 5, you get 2-3-4-5 components
%doPlot = Plot final results
%mMakeFolder =
%mFolderName = 

%sample calling:
% wifi_reader_fazlay('1', '.\Kamran_Pass\Kamran_Pass_3.dat', '100', '13000', '0', '0.8', '200', '300', '0.055','0.063', '0.055','0.063','2','4','1','1','Authenticate_Ali')

Mov_avg_Len = 1; % Averaging readings over Mov_avg_Len*0.4ms
Param = 'Left';
w = -pi:0.01*pi:pi;
SubCarr = 30;
csi_trace = read_bf_file(File_name);

assignin('base', 'csi_trace', csi_trace);

START = str2num(STARTING);

if (str2num(END_GIVEN) == 1)
    END = str2num(ENDING);
else
    END = length(csi_trace)-1000;%length(csi_trace)-1000;
end
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

assignin('base', 'Squeezed2', Squeezed2);

%% Start
COMPS = str2num(PCA_COMPS); % PCA components considered.

% Main filter design using fdesign
fd=fdesign.lowpass(str2num(FI1),str2num(FI2),1,40);%0.033,0.053 ; 0.023,0.033
fi=design(fd,'butter');

% Second filter, for more effective removal of noise to get good PCA
% components
fd2=fdesign.lowpass(str2num(FA1),str2num(FA2),1,40);%0.033,0.053 ; 0.023,0.033
fi2=design(fd2,'butter');

% PeakToPeak DSP object
PP1 = dsp.PeakToPeak;
% Delay filter, used when a you have to compensate for a group delay of
% another filter:
Hd = dfilt.delay(210);

% For Binomial filter
h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:8
    binomialCoeff = conv(binomialCoeff,h);
end
% For moving average filter
alpha = 0.5;
Plotcount = 0;
Active_bins = []; % Will save indices of key presses
TX_RX_pairs = struct;
for TX_antenna = 1:2
    Squeezed1 = eval( ['Squeezed' num2str(TX_antenna)]);
    
    % Initializing
    PLOT_START = str2num(P_START); Change = str2num(CHANGE); Burst_Window = str2num(B_WINDOW); % constants for key press detection, pick smaller Change =1 for 2,3,4
    % Change depends how fast signal changes over the key press window, +
    % BurstWindow size selected + filters because noise can lead to spurious changes as well
    BIN_left = floor(Burst_Window/3); BIN_right = 700 + floor(Burst_Window/2); % 800 + Burst_Window, was giving index exeed error in "tempp"
    %     Final_temp = [];
    %     Final_temp__PCA = [];
    
    for RXIndex = [1 2 3]
        Plotcount = Plotcount + 1;
        %% For Tx antenna 1 (i.e. Squeezed 2)
        Index = 30; % carrier index, which carrier to plot (plotting all using for loop)
        % RXIndex = 1; % rx antenna index
        Mov_avg_Len = 50;
        columnSums = num2cell(reshape(Squeezed1(RXIndex,:),SubCarr,data_size),2); % 1x1x30
        columnSums1 = columnSums; % So that there is no change in actual values, only one filter gets applied !
        % 1st derivative stuff
        columnSums = cellfun(@(x) movavgFilt(x,Mov_avg_Len,Param),columnSums, 'UniformOutput', false);
        %         columnSums1 = columnSums;
        % Moving average stuff
        %         columnSums1 = cellfun(@(x) movavgFilt_backup(x,Mov_avg_Len+200,Param),columnSums, 'UniformOutput', false);
        %         columnSums = cellfun(@(x) movavgFilt_backup(x,Mov_avg_Len-60,Param),columnSums, 'UniformOutput', false);
        
        %% Initiallizing processing
        Mov_avg_Len = Mov_avg_Len + 200; % +1800, just to get rid of initial stuff
        ccc1 = zeros(30,data_size-Mov_avg_Len+1);
        ccc2 = zeros(30,data_size-Mov_avg_Len+1);
        % Creating final vector for processing, for each subcarrier in following for loop.
%         figure
        for j = 1:SubCarr
%             subplot(5,6,j);
%             plot(Mov_avg_Len:data_size,columnSums1{j,1}(Mov_avg_Len:end),'color','r');
%             title(['Carrier' num2str(j) ', RX Ant = ' num2str(RXIndex)])
            ccc1(j,:) = columnSums{j,1}(Mov_avg_Len:end); % saving data into an array from struct4
            ccc2(j,:) = columnSums1{j,1}(Mov_avg_Len:end);
%             display(j)
        end
        %% Filtering the noisy and less noisy vectors for PCA stuff
        ccc1 = filter(binomialCoeff, 1,ccc1'); % Applying binomial filter
        % ccc = filter(bz,az,ccc');  % --1-- filtering before PCA and  analysis
        ccc1 = filter(fi,ccc1);
        ccc2 = filter(fi,ccc2');
        % ccc = ccc'; % If --1-- not called before, this satisfies dimension constraints for next commands.
        
        %% Noisy (noisy filter only)
        new_dat = ccc1 - [mean(ccc1)'*ones(1,data_size-Mov_avg_Len+1)]'; % making data zero mean, removes DC offsets
        new_dat1 = ccc2;
        std_dat = [sqrt(var(new_dat))'*ones(1,data_size-Mov_avg_Len+1)]';
        new_dat = new_dat./std_dat;
        % new_dat = filter(bz,az,new_dat); % filtering after z-normalization
        
        %% Denoised (Moving average + noisy filter)
        %         new_dat1 = ccc2 - [mean(ccc2)'*ones(1,data_size-Mov_avg_Len+1)]'; % making data zero mean, removes DC offsets
        %         std_dat1 = [sqrt(var(new_dat1))'*ones(1,data_size-Mov_avg_Len+1)]';
        %         new_dat1 = new_dat1./std_dat1;
        % new_dat = filter(bz,az,new_dat); % filtering after z-normalization
        %% PCA / Using variable weight PCA:
        %         [PCVEC,~,~,~,~] = pca(new_dat1,'VariableWeights','variance');
        [PCVEC1,~,latent1,~,explained1] = pca(new_dat1);
        [PCVEC,~,latent,~,explained] = pca(new_dat,'VariableWeights','variance');
        %         PCVEC = diag(std(new_dat1)) \ PCVEC;
        %% Principal component scores are the representations of new_dat in the principal component space
        %         xtempp = (new_dat1)*PCVEC1(:,str2num(COMP_SHIFT):COMPS); % No need as tempp takes place
        xtempp1 = (new_dat1)*PCVEC1(:,str2num(COMP_SHIFT):COMPS);
        %         [BB, II] = sort(step(PP1,xtempp1),'descend');
        %         II
        %         xtempp1 = xtempp1(:,II(1:3));
        tempp = (new_dat)*PCVEC(:,str2num(COMP_SHIFT):COMPS);
        %         tempp1 = (new_dat)*PCVEC(:,1:COMPS);   % No need as xtempp1 takes place
        %% Other filtering (EMA, Binomial, polyfit, etc.) after PCA analysis
        
        %% Main fitering after PCA analysis
        % tempp = [filter(fi2,tempp(:,1)) filter(Hd,tempp(:,2))  filter(Hd,tempp(:,3))];
        
        %% Keypress detection
        %         Active_bins = [Active_bins activity_bins_1(tempp(PLOT_START:end,:),Burst_Window, Change)];
        
        %% Saving values to save to a file after loop ends
        TX_RX_pairs.(['TX' num2str(TX_antenna) 'RX' num2str(RXIndex)]) = new_dat1; %xtempp1; new_dat1
        %% Final commulative vector of important PCA components
        % temppx = (new_dat1)*PCVEC(:,1:COMPS);
        % Final_temp__PCA = [Final_temp__PCA temppx(PLOT_START:end,1:COMPS)]; % Denoised projected on its PCA comps
        % Final_temp = [Final_temp tempp(PLOT_START:end,1:COMPS)]; % Noisy projected on denoised PCA
        %% PLOTTING PCA COMPONENTS FOR RX-Antenna
        if (str2num(doPlot) == 1)
            subplot(6,1,Plotcount);
            plot(1:data_size-Mov_avg_Len+1-(PLOT_START-1),xtempp1(PLOT_START:end,:)-repmat(mean(xtempp1(PLOT_START:end,:)),length(xtempp1(PLOT_START:end,:)),1));
            %             title(['RX Ant = ' num2str(RXIndex)])
        end
    end
    
end

return
% if ((PLOT_START+Active_bins(m)-BIN_left > 0) && (PLOT_START+Active_bins(m)+BIN_left < length(TEMP)))
%             if (r == 1)
%                 TEMP = TEMP1(PLOT_START+Active_bins(m)-BIN_left:PLOT_START+Active_bins(m)+BIN_right,:);
%             elseif (r == 2)
%                 TEMP = TEMP2(PLOT_START+Active_bins(m)-BIN_left:PLOT_START+Active_bins(m)+BIN_right,:);
%             else
%                 TEMP = TEMP3(PLOT_START+Active_bins(m)-BIN_left:PLOT_START+Active_bins(m)+BIN_right,:);
%             end
%             save(['RX' Letter '-' num2str(r) '-key-' num2str(m) '.mat'], 'TEMP');
%         end
end
