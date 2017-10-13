function [] = SortedGroup_CorticalFFT_PLOT( goodFFTdata, badFFTdata, Fs )
%Expects group FFT data (not already averaged)
%   The function normalizes all the FFTs and then averages them before
%   plotting
% Plot single-sided amplitude spectrum.
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};
dur = size(goodFFTdata,1);
chan = size(goodFFTdata,2);
goodFFTdata = nanmean(goodFFTdata,3);
badFFTdata = nanmean(badFFTdata,3);

% data avg for good tappers
% sub = size(goodFFTdata,3);
NormedFFTData = zeros(dur,chan);
% for i = 1:size(goodFFTdata,3)
    for k = 1:chan
        %finds the max amplitude of the fft between .25 and 6Hz in order to
        %normalize for averaging accross subjects.
        MaxAmp = max(2*abs(goodFFTdata(8:192,k)));
        NormedFFTData(:,k)= (goodFFTdata(:,k)/MaxAmp);
    end
% end

% data avg for bad tappers
% bad_sub = size(badFFTdata,3);
bad_NormedFFTData = zeros(dur,chan);
% for i = 1:size(badFFTdata,3)
    for k = 1:chan
        %finds the max amplitude of the fft between .25 and 6Hz in order to
        %normalize for averaging accross subjects.
        bad_MaxAmp = max(2*abs(badFFTdata(8:192,k)));
        bad_NormedFFTData(:,k)= (badFFTdata(:,k)/bad_MaxAmp);
    end
% end
% Y = fft(data,NFFT)/L;
figure
hold on
T = 1/Fs;                     % Sample time
L = length(NormedFFTData/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
bad_AvgNormedFFTData= fft(bad_NormedFFTData,NFFT)/L;
AvgNormedFFTData= fft(NormedFFTData,NFFT)/L;


f = Fs./2*linspace(0,1,NFFT/2+1);
for k = 1:chan
    name=chnames{k};
    subplot(7,6,k)
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    %     MaxAmp = max(2*abs(CorticalFFTdata(8:192,k)));
    %     NormedFFTData= (CorticalFFTdata/MaxAmp);
    badplot = detrend(2*abs(bad_AvgNormedFFTData(1:NFFT/2+1,k)));
    goodplot = detrend(2*abs(AvgNormedFFTData(1:NFFT/2+1,k)));
    
    plot(f,badplot, 'r')
    hold on
    plot(f,goodplot, 'b')
    
    %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
    title(['FFT of Response at ' num2str(name)])
    xlabel('Frequency (Hz)')
    ylabel('Norm. Amp')
    xlim([0.25 6])
    ylim([0 1])
    ax = gca;
    set(ax,'XTick',[.5 .75 1 1.25 2 3 4])
    grid
    hold off
end

end

