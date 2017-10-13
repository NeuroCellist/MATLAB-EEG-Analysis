% Looks at low freq oscilations in the amplitude of a frequency band.  This
% function includes Artifact Rejection, Averaging, FFT and ploting (in that
% order).  This function should be run after data are recombined, but
% before any other functions that include AR or plotting.
Data = s1_Comp1_CortData;
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
Fs = 5000;
LowCF = 15;
HighCF = 25;
FiltOrd = 8;
ArtifactThreshold = 150;

trials =size(Data,3);
channels = size(Data,2);


%% Artifact Rejection

for k = 1:channels
    if k ~= 32
        for i = 1:trials
            if max(abs(Data(:,k,i)))>ArtifactThreshold
                Data(:,k,i) = NaN;
            end
        end
    end
end
ArtifactedEpochData = Data;

for q = 1:channels
    %assumes that first timepoint is representative of entire trial
    nanTrials(q)=sum(isnan(ArtifactedEpochData(1,q,:)));
end
TotalNan = sum(nanTrials);
PercArtifact=(TotalNan/(trials*channels))*100;


%% Filters Data with a bandpass butterworth filter between the HighCF and
% LowCF
nyqu = (Fs/2);
[b,a] = butter(FiltOrd, [(LowCF/nyqu) (HighCF/nyqu)],'bandpass');
%EEGfiltered = filtfilt(b,a,ArtifactedEpochData);
EEGfiltered = filter(b,a,ArtifactedEpochData);
%EEGfiltered = Data;



%% Takes the abs(hilbert(x))
for c = 1:channels
    for z = 1:trials
        EEGfilteredEnv(:,c,z)= abs(hilbert(EEGfiltered(:,c,z)));
    end
end

%% Averaging

EEGfilteredAvg = nanmean(EEGfilteredEnv,3);

%%  FFT then Plot (with or without Sylvie Correction)
for c = 1:32
    %CorticalEpochData(:,c)= abs(hilbert(EEGfiltered(:,c)));
    T = 1/Fs;                     % Sample time
    L = length(EEGfilteredAvg/Fs);   % Length of signal
    NFFT = L; % length of y
    Y = fft(EEGfilteredAvg,NFFT)/L;
    
end
CorticalFFTdata = Y;

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
% Plot single-sided amplitude spectrum.
figure
for k = 1:32
    name=chnames{k};
    subplot(6,6,k)
    f = Fs./2*linspace(0,1,NFFT/2+1);
    MaxAmp = max(2*abs(CorticalFFTdata(1:NFFT/2+1,k)));
    %MaxAmp = max(2*abs(CorticalFFTdata_Sylvie(1:NFFT/2+1,k)));
    %plot(f,(2*abs(CorticalFFTdata_Sylvie(1:NFFT/2+1,k))/MaxAmp), 'b')
    plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k))/MaxAmp), 'b')
    title(['FFT of y(t) at ' num2str(name)])
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    xlim([.25 6])
    ylim([0 .05])
    ax = gca;
    set(ax,'XTick',[.5 .75 1 1.25 2 4])
    grid
    
    %FFTDataOut = CorticalFFTdata;
end
toc


