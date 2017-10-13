%This is a Script that calls (in order) the code for the default RhyEEG
%Missing Pulse Study Cortical Frequency Analysis.  The only thing that
%needs to be changes is line 10 or 11 (the vhdr filename that you want to work
%with and its containing folder, respectivly).

clear all
close all
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/MATLAB Analysis code'));
clc
%% (1) Define File to be used
tic
%subID = {'S1702'};
subID = {'S1702';'S1703'; 'S1704'; 'S1705'; 'S1706'; 'S1707'; 'S1708'; 'S1709'; 'S1710'; 'S1711'; 'S1712'; 'S1713'; 'S1714'; 'S1715'; 'S1716'; 'S1717'};
% subID = {'S1702';'S1703'};
Condition = {'Comp1'; 'Comp2'; 'ISO'; 'Rand'};
% Condition = {'Comp1'; 'Comp2';};
% Condition = {'ISO'};
HandCode = {2; 2; 2; 2; 2; 2; 2; 1; 2; 1; 2; 2; 1; 2; 2; 2};
SavedEMG_FFT = NaN(256,size(subID,1),size(Condition,1),6);
SavedEMG_avgFFT = NaN(256,size(subID,1),size(Condition,1),6);
x = 1/32:1/32:8;

for s = 1:size(subID,1)
    for c = 1:size(Condition,1)
        close all
        vhdrNames = cell(6,1);
        for i = 1:6
            vhdrNames{i} = [subID{s} '_' Condition{c} '_' num2str(i) '.vhdr'];
            
        end
        ContainingPath = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/raw eeg'];
        clear i
        clc
        %% (2) Calls Preprocessing Code and returnes basic filtered Data with new Channels from StimTrak  %%
        [ filteredEMGdata, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{1}, ContainingPath);
        [ filteredEMGdata2, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{2}, ContainingPath);
        [ filteredEMGdata3, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{3}, ContainingPath);
        [ filteredEMGdata4, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{4}, ContainingPath);
        [ filteredEMGdata5, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{5}, ContainingPath);
        [ filteredEMGdata6, Fs ] = BrainVision33Chw4EMG_EMGTapping_Preprocess(vhdrNames{6}, ContainingPath);
        
        figure
        ReviewEMG_6trialsv2
        %% (2.5) TRIM TRIALS TO ONLY INCLUDE LISTENING PORTION
        %Trim files to eliminate extra pre and post recording data
        %Stop is determined individually for each recording in order to remove
        %extra data before stim presentation began
        
        filteredEMGdata = EMGTrim64(filteredEMGdata,Fs);
        filteredEMGdata2 = EMGTrim64(filteredEMGdata2,Fs);
        filteredEMGdata3 = EMGTrim64(filteredEMGdata3,Fs);
        filteredEMGdata4 = EMGTrim64(filteredEMGdata4,Fs);
        filteredEMGdata5 = EMGTrim64(filteredEMGdata5,Fs);
        filteredEMGdata6 = EMGTrim64(filteredEMGdata6,Fs);
        close all
        figure(2)
        ReviewEMG_6trialsv2
        %% Cat all 6 trials into 1 matrix
        EMGdata = cat(3, filteredEMGdata, filteredEMGdata2, filteredEMGdata3, filteredEMGdata4, filteredEMGdata5, filteredEMGdata6);
        Stimtrack = mean(EMGdata(:,1,:),3);
        EMGdata = EMGdata(:,2:end,:);
        %% Plot FFT of EMG data
        close all
        [EMG_FFT] = EMGtappingFFT(EMGdata, Fs, subID{s}, Condition{c});
        path2 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/figs'];
        cd(path2);
        set(gcf, 'Position', get(0, 'Screensize'));
        savefig([subID{s} '_' Condition{c} 'EMGtappingFFT']);
        %% Saves Subject data for each condition and trial just 0-8Hz of the
        % EMG tapping FFTs (uses Handedness to determine what sensor is
        % saved
        for t = 1:6
            SavedEMG_FFT(1:256,s,c,t) = EMG_FFT(1:256,HandCode{s},t);
            
            %% OR Same as above but saves athe averge of all 4 sensors
            
            SavedEMG_avgFFT(1:256,s,c,t) = nanmean(EMG_FFT(1:256,:,t),2);
        end
    end
end
close all
%% Run classifier based on 2Hz (1.875-2.125) peak in tapping FFT.
% [TapTrialCode TapTrialMag] = EMGFFT_Classifier(SavedEMG_FFT);
[TapTrialCode TapTrialMag] = EMGFFT_Classifier(SavedEMG_avgFFT);

% Computes percentage tapping succes per condition
ISO_Percent_Taps = 100*(sum(sum(~isnan(TapTrialCode(:,:,1,:))))/96)
MP1_Percent_Taps = 100*(sum(sum(~isnan(TapTrialCode(:,:,2,:))))/96)
MP2_Percent_Taps = 100*(sum(sum(~isnan(TapTrialCode(:,:,3,:))))/96)
Rand_Percent_Taps = 100*(sum(sum(~isnan(TapTrialCode(:,:,4,:))))/96)

% Computes Average Tapping Magnitude for primary tapping frequency per
% condition (avg across trial and sub)
ISO_AvgMag = (nanmean(nanmean(TapTrialMag(:,:,1,:))))
MP1_AvgMag = (nanmean(nanmean(TapTrialMag(:,:,2,:))))
MP2_AvgMag = (nanmean(nanmean(TapTrialMag(:,:,3,:))))
Rand_AvgMag = (nanmean(nanmean(TapTrialMag(:,:,4,:))))
