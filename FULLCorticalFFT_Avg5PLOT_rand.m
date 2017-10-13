function [topchans] = FULLCorticalFFT_Avg5PLOT_rand( CorticalFFTdata, Fs, chans )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Plot single-sided amplitude spectrum.
T = 1/Fs;                     % Sample time
L = length(CorticalFFTdata/Fs);   % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = L; % length of y
f = Fs./2*linspace(0,1,NFFT/2+1);
index2Hz = find(f==2);
index025Hz = find(f==0.25);
index6Hz = find(f==6);
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'NaN'};
plotelectrode = nan(size(CorticalFFTdata,3),1);
plotdata = nan(size(CorticalFFTdata,1),5,size(CorticalFFTdata,3));
NormedFFTData = nan(size(CorticalFFTdata,1),32,size(CorticalFFTdata,3));
BestEdata = nan(size(CorticalFFTdata,1),size(CorticalFFTdata,3));
top5=nan(5,size(CorticalFFTdata,3));
figure
hold on
for s = 1:size(CorticalFFTdata,3)
    goodChanCount = 1;
    
    for e = 1:32
        MaxAmp = max(2*abs(CorticalFFTdata(index025Hz:index6Hz,e,s)));
        NormedFFTData(:,e,s)= ((2*abs(CorticalFFTdata(:,e,s)))./MaxAmp);
        %         [peaks,locs] = findpeaks(((NormedFFTData(1:index6Hz,e,s))),'SortStr','descend');
        %         if ismember(index2Hz,locs)
        %             goodChans(goodChanCount) = e;
        %             goodChanCount=goodChanCount+1;
        %         end
    end
    goodChans = chans;
    %     [sortedX,sortingIndices] = sort(NormedFFTData(index2Hz,goodChans(:,s),s),'descend');
    %     sortingIndices=goodChans(sortingIndices);
    %     if size(sortingIndices)<5
    %         numChans = size(sortingIndices,2);
    %         top5(1:numChans,s) = sortingIndices(1:numChans);
    %         plotdata(:,1:numChans,s) = NormedFFTData(:,top5(1:numChans,s),s);
    %         sortedX(1:numChans)
    %     else
    top5(:,s) = goodChans(:,s);
    plotdata(:,1:5,s) = NormedFFTData(:,top5(:,s),s);
%     sortedX(1:5)
    % end
    
    BestEdata(:,s) = nanmean(plotdata(:,:,s),2);
    plot(f,((BestEdata(1:NFFT/2+1,s))),'linewidth', 1, 'color', [.5 .5 .5]);
    
    clear e goodChanCount goodChans
end

StimTrak= nanmean(CorticalFFTdata(:,33,:),3);
GrpAvg5 = nanmean(BestEdata,2);
%Plots the Stim Envelope FFT
MaxAmp2 = max(2*abs(StimTrak(index025Hz:index6Hz)));
NormedStim= (StimTrak./MaxAmp2);
plot(f,(2*abs(NormedStim(1:NFFT/2+1))), 'r','linewidth', 2);
% Plots the Group Averaged FFT
MaxAmp1 = max(2*abs(GrpAvg5(index025Hz:index6Hz)));
NormedFFTData1= (GrpAvg5./MaxAmp1);
GrpAvgPlot=(2*abs(NormedFFTData1(1:NFFT/2+1)));
plot(f,GrpAvgPlot,'b','linewidth', 2);
%Finishing Touches
title('FFT of Responses at 5 Best Electrodes per Subject')
xlabel('Frequency (Hz)')
ylabel('Normalized Amplitude')
xlim([0.25 6])
ylim([0 1])
% xlim([0 6])

ax = gca;
set(ax,'XTick',[ .5 .75 1 1.25 2 4])
grid
top5(isnan(top5)) = 34;
topchans=chnames(top5);
% topchans=top5;
end

