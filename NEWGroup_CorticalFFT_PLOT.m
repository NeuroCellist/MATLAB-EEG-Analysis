function [] = NEWGroup_CorticalFFT_PLOT( CorticalFFTdata, Fs )
%Expects group FFT data (not already averaged)
%   The function normalizes all the FFTs and then averages them before
%   plotting
% Plot single-sided amplitude spectrum.
close all

load plotinfo

chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};
dur = size(CorticalFFTdata,1);
chan = size(CorticalFFTdata,2);
sub = size(CorticalFFTdata,3);
NormedFFTData = zeros(dur,chan,sub);

% Time vector
NFFT = dur; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);

binSize = 1/(NFFT/Fs);  %for use w/ nozFilter

index2Hz = find(f==2);
index025Hz = find(f==0.25);
index6Hz = find(f==6);
[b,a,x]=nozFilter(binSize,(binSize*8));  %Default SD = (binSize*8)

for i = 1:sub
    for k = 1:chan
        %finds the max amplitude of the fft between .25 and 6Hz in order to
        %normalize for averaging accross subjects.
        %     MaxAmp = max(2*abs(CorticalFFTdata(8:192,k,i)));
        if k ~= 33
            CorticalFFTdata(:,k,i)= filtfilt(b,a,(2*abs(CorticalFFTdata(:,k,i))));
        elseif k == 33
            CorticalFFTdata(:,k,i)= (2*abs(CorticalFFTdata(:,k,i)));
        end
        MaxAmp = max(CorticalFFTdata(index025Hz:index6Hz,k,i));
        NormedFFTData(:,k,i)= (CorticalFFTdata(:,k,i)./MaxAmp);
        %         NormedFFTData(:,k,i)= CorticalFFTdata(:,k,i);
        
    end
end
AvgNormedFFTData= nanmean(NormedFFTData,3);

figure

for k = 1:32
    name=chnames{k};
    axes ('position',[posX(k) posY(k) .1 .1]);
    %finds the max amplitude of the fft between .25 and 6Hz in order to
    %normalize for plotting.
    %     MaxAmp = max(2*abs(CorticalFFTdata(8:192,k)));
    %     NormedFFTData= (CorticalFFTdata/MaxAmp);
    hold on
    plot(f,(AvgNormedFFTData(1:NFFT/2+1,33)./2), 'Color', [.5 .5 .5], 'LineWidth', 2)
    plot(f,(AvgNormedFFTData(1:NFFT/2+1,k)), 'b', 'LineWidth', 2)
    
    %plot(f,(2*abs(CorticalFFTdata(1:NFFT/2+1,k)/MaxAmp)), 'b')
    title(num2str(name))
    if k==33
        xlabel('Frequency (Hz)')
        ylabel('Norm. Amp')
    end
    xlim([0.25 6])
    %     xlim([-1 6])
    ylim([0 1])
    ax = gca;
    set(ax,'XTick',[.5 .75 1 1.25 2 4])
    grid
    hold off
end
% figure(2)
% eegData=nanmean(AvgNormedFFTData(:,1:32),2);
% stim=AvgNormedFFTData(:,33);
% subplot(2,1,1)
% plot(f,(eegData(1:NFFT/2+1)), 'b')
% xlim([0.25 6])
% ylim([0 1])
% ax = gca;
% set(ax,'XTick',[.5 .75 1 1.25 2 4])
% grid
% xlabel('Frequency (Hz)')
% ylabel('Norm. Amp')
% 
% subplot(2,1,2)
% plot(f,(stim(1:NFFT/2+1)), 'b')
% xlim([0.25 6])
% ylim([0 1])
% ax = gca;
% set(ax,'XTick',[.5 .75 1 1.25 2 4])
% grid
% xlabel('Frequency (Hz)')
% ylabel('Norm. Amp')
%%
figure(3)
subplot(2,1,1)
hold on
plot(f,(AvgNormedFFTData(1:NFFT/2+1,33)./2), 'Color', [.5 .5 .5], 'LineWidth', 2)
plot(f,(AvgNormedFFTData(1:NFFT/2+1,7)), 'b', 'LineWidth', 2)
xlim([0.25 6])
ylim([0 1])
ax = gca;
set(ax,'XTick',[.5 .75 1 1.25 2 4], 'fontsize', 20)
grid
xlabel('Frequency (Hz)', 'fontsize', 20)
ylabel('Norm. Amp', 'fontsize', 20)
title('Electrode FC1', 'fontsize', 20)
hold off

subplot(2,1,2)
hold on
plot(f,(AvgNormedFFTData(1:NFFT/2+1,33)./2), 'Color', [.5 .5 .5], 'LineWidth', 2)
plot(f,(AvgNormedFFTData(1:NFFT/2+1,23)), 'b', 'LineWidth', 2)
xlim([0.25 6])
ylim([0 1])
ax = gca;
set(ax,'XTick',[.5 .75 1 1.25 2 4], 'fontsize', 20)
grid
xlabel('Frequency (Hz)', 'fontsize', 20)
ylabel('Norm. Amp', 'fontsize', 20)
title('Electrode CP2', 'fontsize', 20)

hold off
end

