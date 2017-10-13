function [ EMGFFTdata ] = EMGtappingFFT( EMGdata, Fs, subID, Condition)
%CorticalCapFFT Summary of this function goes here
%   Detailed explanation goes here
chnames = {'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot'};
count=1;
figure
hold on
T = 1/Fs;                     % Sample time
L = length(EMGdata/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L*4; % length of y
Y = fft(EMGdata,NFFT)/L;
f = Fs./2*linspace(0,1,NFFT/2+1);
for t = 1:size(EMGdata,3)
    for s = 1:size(EMGdata,2)
        
        name=chnames{count};
        subplot(size(EMGdata,3),size(EMGdata,2),count)
        %finds the max amplitude of the fft between .25 and 8Hz in order to
        %normalize for plotting.
        data = Y(:,s,t);
        MaxAmp = max(2*abs(data(6:256)));
        NormedEMGData= (data/MaxAmp);
        plot(f,(2*abs(NormedEMGData(1:NFFT/2+1))), 'b')
        title([num2str(name) ' FFT'])
        xlabel('Frequency (Hz)')
        xlim([0.3 8])
        ylim([0 1])
        ax = gca;
        set(ax,'XTick',[0 .25 .5 .75 1 1.25 2 3 4 5 6 7 8])
        grid
        if count == 1
            ylabel('Trial 1')
        elseif count == 5
            ylabel('Trial 2')
        elseif count == 9
            ylabel('Trial 3')
        elseif count == 13
            ylabel('Trial 4')
        elseif count == 17
            ylabel('Trial 5')
        elseif count == 21
            ylabel('Trial 6')
        end
        count = count+1;
    end
end
set(gcf,'numbertitle','off','name',[subID '_' Condition '_FFT of EMG Tapping']) % See the help for GCF
hold off
EMGFFTdata = Y;
end

