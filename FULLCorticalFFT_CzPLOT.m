function [] = FULLCorticalFFT_CzPLOT( CorticalFFTdata, electrode, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Plot single-sided amplitude spectrum.
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};
[logic, local]=ismember(electrode,chnames);
plotelectrode = local;
T = 1/Fs;                     % Sample time
L = length(CorticalFFTdata/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);
GroupCorticalFFTdata= nanmean(CorticalFFTdata,3);
figure
hold on
for s = 1:size(CorticalFFTdata,3)  
        MaxAmp = max(2*abs(CorticalFFTdata(8:192,plotelectrode,s)));
        NormedFFTData= (CorticalFFTdata/MaxAmp);
        plot(f,(2*abs(NormedFFTData(1:NFFT/2+1,plotelectrode,s))),'linewidth', 1, 'color', [.5 .5 .5]);    
end
%Plots the Stim Envelope FFT
MaxAmp2 = max(2*abs(GroupCorticalFFTdata(8:192,33)));
NormedFFTData2= (GroupCorticalFFTdata/MaxAmp2);
plot(f,(2*abs(NormedFFTData2(1:NFFT/2+1,33))), 'r','linewidth', 2);
% Plots the Group Averaged FFT
MaxAmp1 = max(2*abs(GroupCorticalFFTdata(8:192,plotelectrode)));
NormedFFTData1= (GroupCorticalFFTdata/MaxAmp1);
GrpAvgPlot=(2*abs(NormedFFTData1(1:NFFT/2+1,plotelectrode)));
plot(f,GrpAvgPlot,'b','linewidth', 2);
%Finishing Touches
title(['FFT of Responses at ' num2str(electrode)])
xlabel('Frequency (Hz)')
ylabel('Normalized Amplitude')
xlim([0.25 6])
ax = gca;
set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
grid
end

