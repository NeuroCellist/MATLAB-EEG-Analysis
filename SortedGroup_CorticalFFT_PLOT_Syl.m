function [] = SortedGroup_CorticalFFT_PLOT_Syl( goodFFTdata, badFFTdata, Fs )
%Expects group FFT data (not already averaged)
%   The function normalizes all the FFTs and then averages them before
%   plotting
% Plot single-sided amplitude spectrum.
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};
dur = size(goodFFTdata,1);
chan = size(goodFFTdata,2);

% data avg for good tappers
sub = size(goodFFTdata,3);
NormedFFTData = zeros(dur,chan,sub);
for i = 1:size(goodFFTdata,3)
    for k = 1:chan
        %finds the max amplitude of the fft between .25 and 6Hz in order to
        %normalize for averaging accross subjects.
        MaxAmp = max(2*abs(goodFFTdata(8:192,k,i)));
        NormedFFTData(:,k,i)= (goodFFTdata(:,k,i)/MaxAmp);
    end
end
AvgNormedFFTData= nanmean(NormedFFTData,3);

% data avg for bad tappers
bad_sub = size(badFFTdata,3);
bad_NormedFFTData = zeros(dur,chan,bad_sub);
for i = 1:size(badFFTdata,3)
    for k = 1:chan
        %finds the max amplitude of the fft between .25 and 6Hz in order to
        %normalize for averaging accross subjects.
        bad_MaxAmp = max(2*abs(badFFTdata(8:192,k,i)));
        bad_NormedFFTData(:,k,i)= (badFFTdata(:,k,i)/bad_MaxAmp);
    end
end
bad_AvgNormedFFTData= nanmean(bad_NormedFFTData,3);

%apply binning procedure from (Nazoradan, 2012)
channels = (size(AvgNormedFFTData,2));
bins = size(AvgNormedFFTData,1);
goodCorticalFFTdata_Sylvie = zeros(bins,channels);
for i = 1:channels
    if i >= 32
        goodCorticalFFTdata_Sylvie(:,i) = AvgNormedFFTData(:,i);
    end
    for b = 1:bins
        if b == 1
            point = AvgNormedFFTData(b,i);
            flankBinAvg = AvgNormedFFTData((b+1),i);
            goodCorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        elseif b == bins
            point = AvgNormedFFTData(b,i);
            flankBinAvg = AvgNormedFFTData((b-1),i);
            goodCorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        else
            point = AvgNormedFFTData(b,i);
            prebin = AvgNormedFFTData((b-1),i);
            postbin = AvgNormedFFTData((b+1),i);
            flankBinAvg = ((prebin + postbin)/2);
            goodCorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        end
    end
end

%apply binning procedure from (Nazoradan, 2012)
channels = (size(bad_AvgNormedFFTData,2));
bins = size(bad_AvgNormedFFTData,1);
bad_CorticalFFTdata_Sylvie = zeros(bins,channels);
for i = 1:channels
    if i >= 32
        bad_CorticalFFTdata_Sylvie(:,i) = bad_AvgNormedFFTData(:,i);
    end
    for b = 1:bins
        if b == 1
            point = bad_AvgNormedFFTData(b,i);
            flankBinAvg = bad_AvgNormedFFTData((b+1),i);
            bad_CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        elseif b == bins
            point = bad_AvgNormedFFTData(b,i);
            flankBinAvg = bad_AvgNormedFFTData((b-1),i);
            bad_CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        else
            point = bad_AvgNormedFFTData(b,i);
            prebin = bad_AvgNormedFFTData((b-1),i);
            postbin = bad_AvgNormedFFTData((b+1),i);
            flankBinAvg = ((prebin + postbin)/2);
            bad_CorticalFFTdata_Sylvie(b,i) = (point - flankBinAvg);
        end
    end
end

% Normalize amplitudes
for k = 1:chan
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for averaging accross subjects.
    badMaxAmp = max(bad_CorticalFFTdata_Sylvie(8:192,k));
    goodMaxAmp = max(goodCorticalFFTdata_Sylvie(8:192,k));
    
    good2plotFFTData(:,k)= (goodCorticalFFTdata_Sylvie(:,k)/goodMaxAmp);
    bad2plotFFTData(:,k)= (bad_CorticalFFTdata_Sylvie(:,k)/badMaxAmp);
    
end


figure
hold on
T = 1/Fs;                     % Sample time
L = length(AvgNormedFFTData/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);
for k = 1:chan
    name=chnames{k};
    subplot(7,6,k)
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    %     MaxAmp = max(2*abs(CorticalFFTdata(8:192,k)));
    %     NormedFFTData= (CorticalFFTdata/MaxAmp);
    badplot = detrend(2*abs(bad2plotFFTData(1:NFFT/2+1,k)));
    goodplot = detrend(2*abs(good2plotFFTData(1:NFFT/2+1,k)));
    
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

