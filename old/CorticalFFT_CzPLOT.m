function [] = CorticalFFT_CzPLOT( CorticalFFTdata, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Plot single-sided amplitude spectrum.
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
T = 1/Fs;                     % Sample time
L = length(CorticalFFTdata/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);
figure
hold on
for s = 1:10
    for k = 23
        name=chnames{k};
        MaxAmp = max(2*abs(CorticalFFTdata(8:192,k,s)));
        NormedFFTData= (CorticalFFTdata/MaxAmp);
        plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,k,s))),'linewidth', 1, 'color', [.5 .5 .5]);
        %plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,k))),'linewidth',1,'Color',[1 1 1]);
        
        % MaxAmp = max(2*abs(CorticalFFTdata(1:NFFT/2+1,k)));
        % plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k))/MaxAmp), 'b')
        % plot(f,2*abs(CorticalFFTdata(1:NFFT/2+1,k)), 'b')
    end
end
title('FFT of y(t) at Cz')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0.25 6])
ax = gca;
set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
grid
end

