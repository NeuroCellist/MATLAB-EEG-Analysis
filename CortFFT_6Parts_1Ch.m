function [ CorticalFFTdata ] =CortFFT_6Parts_1Ch( ArtifactedEpochData, Fs )
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here
chnames = {'Cz' 'StimTrak'};
trials =size(ArtifactedEpochData,3);
channels = size(ArtifactedEpochData,2);
phase1 = nanmean(ArtifactedEpochData(:,:,1:7),3);
phase2 = nanmean(ArtifactedEpochData(:,:,8:14),3);
phase3 = nanmean(ArtifactedEpochData(:,:,15:21),3);
phase4 = nanmean(ArtifactedEpochData(:,:,22:28),3);
phase5 = nanmean(ArtifactedEpochData(:,:,29:35),3);
phase6 = nanmean(ArtifactedEpochData(:,:,36:42),3);



for c = 1:channels
        if c== channels
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
        if c== channels
            phase2(:,c)= abs(hilbert(phase2(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase2/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y2 = fft(phase2,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);      
end
for c = 1:channels
        if c== channels
            phase3(:,c)= abs(hilbert(phase3(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase3/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y3 = fft(phase3,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);      
end
for c = 1:channels
        if c== channels
            phase4(:,c)= abs(hilbert(phase4(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase4/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y4 = fft(phase4,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);      
end
for c = 1:channels
        if c== channels
            phase5(:,c)= abs(hilbert(phase5(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase5/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y5 = fft(phase5,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);      
end
for c = 1:channels
        if c== channels
            phase6(:,c)= abs(hilbert(phase6(:,c)));
        end
        T = 1/Fs;                     % Sample time
        L = length(phase6/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % Next power of 2 from length of y
        Y6 = fft(phase6,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);      
end


Y = cat(3,Y1,Y2,Y3,Y4,Y5,Y6);
CorticalFFTdata = nanmean(abs(Y),3);
% Plot single-sided amplitude spectrum.
figure
for k = 1:channels
    name=chnames{k};
    subplot(2,1,k)
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

