function [ CorticalFFTdata ] = RhyEEG1chFFT( Data, Fs )
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here

T = 1/Fs;                     % Sample time
L = length(Data/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L*16; % length of y
Y = fft(Data,NFFT)/L;
f = Fs./2*linspace(0,1,NFFT/2+1);

index2Hz = find(f==2);
index025Hz = find(f==0.25);
index6Hz = find(f==6);

MaxAmp = max(2*abs(Y(index025Hz:index6Hz)));
NormedFFTData= ((2*abs(Y))./MaxAmp);
hold on
plot(f,((NormedFFTData(1:NFFT/2+1))), 'r')
plot(f,(2*abs(Y(1:NFFT/2+1))), 'b')

title('FFT (red=sig/max)')
xlabel('Frequency (Hz)')
ylabel('Amp_normed')
xlim([0.25 6])
ylim([0 1])
ax = gca;
set(ax,'XTick',[0 .5 .75 1 1.25 2 4])
grid
hold off
end

