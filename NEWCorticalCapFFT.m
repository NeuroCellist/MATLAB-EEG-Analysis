function [ CorticalFFTdata ] = NEWCorticalCapFFT( ArtifactedEpochData, Fs )
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
ArtifactedEpochData = nanmean(ArtifactedEpochData,3);
for c = 1:32
    if c== 32
       ArtifactedEpochData(:,c)= abs(hilbert(ArtifactedEpochData(:,c)));
    end  
        T = 1/Fs;                     % Sample time
        L = length(ArtifactedEpochData/Fs);   % Length of signal
        t = (0:L-1)*T;                % Time vector
        NFFT = L*4; % length of y
        Y = fft(ArtifactedEpochData,NFFT)/L;
        f = Fs./2*linspace(0,1,NFFT/2+1);
    
end
CorticalFFTdata = Y;

end

