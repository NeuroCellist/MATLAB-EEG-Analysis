function [ CorticalFFTdata ] =Group_FFT_Avg_Plot_p1( ArtifactedEpochData, Fs )
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
trials =size(ArtifactedEpochData,3);
channels = size(ArtifactedEpochData,2);
phase1 = nanmean(ArtifactedEpochData(:,:,1:20),3);
phase2 = nanmean(ArtifactedEpochData(:,:,21:40),3);

for c = 1:channels
        if c== 32
            phase1(:,c)= abs(hilbert(phase1(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase1/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y1 = fft(phase1,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);
       
end
for c = 1:channels
        if c== 32
            phase2(:,c)= abs(hilbert(phase2(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase2/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y2 = fft(phase2,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);
       
end
Y = cat(3,Y1,Y2);
CorticalFFTdata = nanmean(abs(Y),3);
% Plot single-sided amplitude spectrum.
figure
for k = 1:32
    name=chnames{k};
    subplot(6,6,k)
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    MaxAmp = max(2*abs(CorticalFFTdata(8:192,k)));
    NormedFFTData= (CorticalFFTdata/MaxAmp);
    plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,k))), 'b')
    %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
    title(['FFT of y(t) at ' num2str(name)])
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    xlim([0.25 6])
    ylim([0 1])
    ax = gca;
    set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
    grid
end
end

