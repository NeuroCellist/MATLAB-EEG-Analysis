function [] = Group_CorticalFFT_CzPLOT( CorticalFFTdata, Fs )
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
hold on
name=chnames{k};
%finds the max amplitude of the fft between .25 and 6Hz in order to
%normalize for plotting.
MaxAmp1 = max(2*abs(CorticalFFTdata(8:192,23)));
NormedFFTData1= (CorticalFFTdata/MaxAmp1);
plot(f,(2*abs(NormedFFTData1(1:NFFT/2+1,23))), 'b')
MaxAmp2 = max(2*abs(CorticalFFTdata(8:192,32)));
NormedFFTData2= (CorticalFFTdata/MaxAmp2);
plot(f,(2*abs(NormedFFTData2(1:NFFT/2+1,32))), 'r')
%plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
title('FFT of Response at Cz')
xlabel('Frequency (Hz)')
ylabel('Normalized Amplitude')
xlim([0.25 6])
%ylim([0 1])
ax = gca;
set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
grid
hold off
end


