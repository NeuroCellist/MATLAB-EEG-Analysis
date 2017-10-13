function [ CorticalFFTdata, EvokedFFTdata] =NEWCortFFT_6PartsV2( ArtifactedEpochData, Fs, subID, s, Condition, c, TapKey)
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};
trials =size(ArtifactedEpochData,3);
load plotinfo
time=size(ArtifactedEpochData,1);
channels = size(ArtifactedEpochData,2);
data = ArtifactedEpochData;
stimchan = 33;
window = tukeywin(time,.1);


fftRes=12; % 16 gives a 64sec length FFT; 12 gives a 48sec (same as Cirelli, 2010)
durr = size(data,1);
% win = tukeywin(durr,.5); %2nd argument dictates the window rollof (see doc of tukeywin for details)
% physiochan = [1:32 34:37];
for t = 1:trials
    data(:,stimchan,t)= abs(hilbert(data(:,stimchan,t)));
    %             data(:,physiochan,t) = (data(:,physiochan,t).*win); %Tapering using tukey window
end
T = 1/Fs;                     % Sample time
L = length(data/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L*fftRes; % Length of real signal (4sec) times a constant to zero-pad the fft and increase freq resolution
Y = fft(data,NFFT)/L;

if c ==1 || c==2
    negPhase = find(TapKey(:,c,3)==-1);
    posPhase = find(TapKey(:,c,3)==1);
    
    if isempty(negPhase) || isempty(posPhase)
        for i = 1:32
            for j = 1:trials
                data(:,i,j) = detrend(data(:,i,j));
                data(:,i,j) = data(:,i,j).*window;
            end
        end
        evokeddata = nanmean(data,3);
        EvokedFFTdata= fft(evokeddata,NFFT)/L;
    else
        evokeddata{1} = data(:,:,1:6);
        evokeddata{2} = data(:,:,7:12);
        evokeddata{3} = data(:,:,13:18);
        evokeddata{4} = data(:,:,19:24);
        evokeddata{5} = data(:,:,25:30);
        evokeddata{6} = data(:,:,31:36);
        
        
        NegEvoked = cat(3, evokeddata{negPhase});
        PosEvoked = cat(3,evokeddata{posPhase});
               
        for i = 1:32
            for j = 1:size(NegEvoked,3)
                NegEvoked(:,i,j) = detrend(NegEvoked(:,i,j));
                NegEvoked(:,i,j) = NegEvoked(:,i,j).*window;
            end
            for m = 1:size(PosEvoked,3)
                PosEvoked(:,i,m) = detrend(PosEvoked(:,i,m));
                PosEvoked(:,i,m) = PosEvoked(:,i,m).*window;
            end
        end
        PosEvoked = nanmean(PosEvoked,3);
        NegEvoked = nanmean(NegEvoked,3);
        
        
        Yevoked_pos = fft(PosEvoked,NFFT)/L;
        Yevoked_neg = fft(NegEvoked,NFFT)/L;
        
        Yevoked = cat(3,Yevoked_pos,Yevoked_neg);
        EvokedFFTdata = nanmean(Yevoked,3);
    end
    
else
    for i = 1:32
        for j = 1:trials
            data(:,i,j) = detrend(data(:,i,j));
            data(:,i,j) = data(:,i,j).*window;
        end
    end
    evokeddata = nanmean(data,3);
    EvokedFFTdata= fft(evokeddata,NFFT)/L;
end

f = Fs./2*linspace(0,1,NFFT/2+1);

index025Hz = find(f==0.25);
index6Hz = find(f==6);


% Y = cat(3,Y1,Y2,Y3,Y4,Y5,Y6);
CorticalFFTdata = nanmean(Y,3);
% Plot single-sided amplitude spectrum.
%
% figure(1)
% for k = 1:33
%     name=chnames{k};
%     axes ('position',[posX(k) posY(k) .1 .1]);
%
%     %     subplot(7,6,k)
%     %finds the max amplitude of the fft between .25 and 6Hz in order to
%     %normalize for plotting.
%     MaxAmp = max(2*abs(CorticalFFTdata(index025Hz:index6Hz,k)));
%     NormedFFTData(:,k)= ((2*abs(CorticalFFTdata(:,k)))./MaxAmp);
%     plot(f,((NormedFFTData(1:NFFT/2+1,k))), 'b')
%     %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
%     title(['Induced FFT at ' num2str(name)])
%     xlabel('Frequency (Hz)')
%     ylabel('Amp_normed')
%     xlim([0.25 6])
%     ylim([0 1])
%     ax = gca;
%     set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
%     grid
%
% end
% set(gcf,'numbertitle','off','name',['Induced FFT for Subject ' subID{s} ': ' Condition{c} ' Rhythm']) % See the help for GCF

% set(gcf, 'Position', get(0, 'Screensize'));
% savefig([subID{s} '_' Condition{c} '_Induced_FFT']);
%

figure
for k = 1:33
    name=chnames{k};
    axes ('position',[posX(k) posY(k) .1 .1]);
    
    %     subplot(7,6,k)
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    MaxAmp = max(2*abs(EvokedFFTdata(index025Hz:index6Hz,k)));
    NormedFFTData(:,k)= ((2*abs(EvokedFFTdata(:,k)))./MaxAmp);
    plot(f,((NormedFFTData(1:NFFT/2+1,k))), 'b')
    %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
    title(['Evoked FFT at ' num2str(name)])
    xlabel('Frequency (Hz)')
    ylabel('Amp_normed')
    xlim([0.25 6])
    ylim([0 1])
    ax = gca;
    set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
    grid
end
path2 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/figs'];
cd(path2);
set(gcf,'numbertitle','off','name',['Evoked FFT for Subject ' subID{s} ': ' Condition{c} ' Rhythm']) % See the help for GCF
set(gcf, 'Position', get(0, 'Screensize'));
savefig([subID{s} '_' Condition{c} '_Evoked_FFT']);

% figure(3)
% hold on
% for i = 34:37
%     subplot(2,2,(i-33))
%     name=chnames{i};
%     MaxAmp = max(2*abs(CorticalFFTdata(index025Hz:index6Hz,i)));
%     NormedFFTData= (CorticalFFTdata/MaxAmp);
%     plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,i))), 'b')
%     %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
%     title(['EMG FFT at ' num2str(name)])
%     xlabel('Frequency (Hz)')
%     ylabel('Amp_normed')
%     xlim([0.25 6])
%     ylim([0 1])
%     ax = gca;
%     set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
%     grid
% end
% set(gcf,'numbertitle','off','name',['FFT of EMG Data for Subject ' subID{s} ': ' Condition{c} ' Rhythm']) % See the help for GCF
% set(gcf, 'Position', get(0, 'Screensize'));
% hold off
% savefig([subID{s} '_' Condition{c} '_EMG_FFT']);
end

