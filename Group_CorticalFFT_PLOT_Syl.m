function [] = Group_CorticalFFT_PLOT_Syl( CorticalFFTdata, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Plot single-sided amplitude spectrum.
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
CorticalFFTdata= nanmean(CorticalFFTdata,3);
T = 1/Fs;                     % Sample time
L = length(CorticalFFTdata/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);
figure

%apply binning procedure from (Nazoradan, 2012)
channels = (size(CorticalFFTdata,2));
bins = size(CorticalFFTdata,1);
CorticalFFTdata_Sylvie = zeros(bins,channels);
for i = 1:channels
    if i == 32
        CorticalFFTdata_Sylvie(:,i) = CorticalFFTdata(:,i);
    end
    for b = 1:bins
        if b == 1
            point = CorticalFFTdata(b,i);
            flankBinAvg = CorticalFFTdata((b+1),i);
            CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        elseif b == bins
            point = CorticalFFTdata(b,i);
            flankBinAvg = CorticalFFTdata((b-1),i);
            CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        else
            point = CorticalFFTdata(b,i);
            prebin = CorticalFFTdata((b-1),i);
            postbin = CorticalFFTdata((b+1),i);
            flankBinAvg = ((prebin + postbin)/2);
            CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        end
    end
end

for k = 1:32
    name=chnames{k};
    subplot(6,6,k)
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    MaxAmp = max(2*abs(CorticalFFTdata_Sylvie(8:192,k)));
    NormedFFTData= (CorticalFFTdata_Sylvie/MaxAmp);
    plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,k))), 'b')
    %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
    title(['FFT of Response at ' num2str(name)])
    xlabel('Frequency (Hz)')
    ylabel('Normalized Amplitude')
    xlim([0.25 6])
    ylim([0 1])
    ax = gca;
    set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
    grid
end

end

