%This is a Script that calls (in order) the code for the default RhyEEG
%Missing Pulse Study Cortical Frequency Analysis.  The only thing that
%needs to cbe changes is line 10 or 11 (the vhdr filename that you want to work
%with and its containing folder, respectivly).

clear all
close all
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/MATLAB Analysis code'));
clc
%% (1) Define File to be used
tic
subID = {'F1703'};
% subID = {'Sum1703'};

% subID = {'S1702';'S1703'; 'S1704'; 'S1705'; 'S1706'; 'S1707'; 'S1708'; 'S1709'; 'S1710'; 'S1711'; 'S1712'; 'S1713'; 'S1714'; 'S1715'; 'S1716'; 'S1717'};
Condition = {'Comp1'; 'Comp2'; 'ISO'; 'Rand'};
% Condition = {'ISO'};
% TapKey=nan(6,4);
%%
for s = 1:size(subID,1)
    %%
    for c = 1:size(Condition,1)
        vhdrNames = cell(8,1);
        tapNames = cell(8,1);
        
        for i = 1:8
            vhdrNames{i} = [subID{s} '_' Condition{c} '_' num2str(i) '.vhdr'];
            tapNames{i} = [subID{s} '_' Condition{c} '_' num2str(i) '_taps.mat'];
        end
        ContainingPath = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/raw eeg'];
        tappingPath = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/In-EEG-Tapping/' subID{s}];
        clear i
        clc
        %% (2) Calls Preprocessing Code and returnes basic filtered Data with new Channels from StimTrak  %%
        [ filteredEEGdata, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{1}, ContainingPath);
        [ filteredEEGdata2, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{2}, ContainingPath);
        [ filteredEEGdata3, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{3}, ContainingPath);
        [ filteredEEGdata4, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{4}, ContainingPath);
        [ filteredEEGdata5, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{5}, ContainingPath);
        [ filteredEEGdata6, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{6}, ContainingPath);
        [ filteredEEGdata7, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{7}, ContainingPath);
        [ filteredEEGdata8, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{8}, ContainingPath);
        
        
        figure
        ReviewEEG_8trials
        figure(2)
        ReviewEMG_8trials
        %% (2.5) TRIM TRIALS TO ONLY INCLUDE LISTENING PORTION
        %Trim files to eliminate extra pre and post recording data
        %Stop is determined individually for each recording in order to remove
        %extra data before stim presentation began
        
        filteredEEGdata = NEWEEGTrim72(filteredEEGdata,Fs);
        filteredEEGdata2 = NEWEEGTrim72(filteredEEGdata2,Fs);
        filteredEEGdata3 = NEWEEGTrim72(filteredEEGdata3,Fs);
        filteredEEGdata4 = NEWEEGTrim72(filteredEEGdata4,Fs);
        filteredEEGdata5 = NEWEEGTrim72(filteredEEGdata5,Fs);
        filteredEEGdata6 = NEWEEGTrim72(filteredEEGdata6,Fs);
        filteredEEGdata7 = NEWEEGTrim72(filteredEEGdata7,Fs);
        filteredEEGdata8 = NEWEEGTrim72(filteredEEGdata8,Fs);
        
        figure
        ReviewEEG_8trials
        %% (3) EXTRACT STIMTRAK CHANNEL AND CREATE CHANNELS FOR FFR AND CORTICAL ANALYSIS MARKERS %%
        %NOTE: Find threshold for StimTrak before running part 3 or the default of
        %20,000 will be used.
        close all
        [filteredEEGdata] = NEWPlaceMarkers_CapEMG(filteredEEGdata, Fs);
        [filteredEEGdata2] = NEWPlaceMarkers_CapEMG(filteredEEGdata2, Fs);
        [filteredEEGdata3] = NEWPlaceMarkers_CapEMG(filteredEEGdata3, Fs);
        [filteredEEGdata4] = NEWPlaceMarkers_CapEMG(filteredEEGdata4, Fs);
        [filteredEEGdata5] = NEWPlaceMarkers_CapEMG(filteredEEGdata5, Fs);
        [filteredEEGdata6] = NEWPlaceMarkers_CapEMG(filteredEEGdata6, Fs);
        [filteredEEGdata7] = NEWPlaceMarkers_CapEMG(filteredEEGdata7, Fs);
        [filteredEEGdata8] = NEWPlaceMarkers_CapEMG(filteredEEGdata8, Fs);
        
        
        StimCheck = zeros(1,8);
        StimCheck(1,1) = sum(filteredEEGdata(:,38));
        StimCheck(1,2) = sum(filteredEEGdata2(:,38));
        StimCheck(1,3) = sum(filteredEEGdata3(:,38));
        StimCheck(1,4) = sum(filteredEEGdata4(:,38));
        StimCheck(1,5) = sum(filteredEEGdata5(:,38));
        StimCheck(1,6) = sum(filteredEEGdata6(:,38));
        StimCheck(1,7) = sum(filteredEEGdata7(:,38));
        StimCheck(1,8) = sum(filteredEEGdata8(:,38));
        
        
        StimCheck
        %% StdAR Steam (4) Calls Code that defines Segmentation Points for Envelope Epoching
        [ Pre, Post] = NEWSegmentation4sEMG( filteredEEGdata, Fs);
        [ Pre2, Post2] = NEWSegmentation4sEMG( filteredEEGdata2, Fs);
        [ Pre3, Post3] = NEWSegmentation4sEMG( filteredEEGdata3, Fs);
        [ Pre4, Post4] = NEWSegmentation4sEMG( filteredEEGdata4, Fs);
        [ Pre5, Post5] = NEWSegmentation4sEMG( filteredEEGdata5, Fs);
        [ Pre6, Post6] = NEWSegmentation4sEMG( filteredEEGdata6, Fs);
        [ Pre7, Post7] = NEWSegmentation4sEMG( filteredEEGdata7, Fs);
        [ Pre8, Post8] = NEWSegmentation4sEMG( filteredEEGdata8, Fs);
        
        
        %% StdAR Steam (5) Calls Code That Epochs Data and Outputs a multidimensional matrix
        [ CorticalEpochData ] = NEWEpochingCortical( filteredEEGdata, Pre, Post, Fs);
        [ CorticalEpochData2 ] = NEWEpochingCortical( filteredEEGdata2, Pre2, Post2, Fs);
        [ CorticalEpochData3 ] = NEWEpochingCortical( filteredEEGdata3, Pre3, Post3, Fs);
        [ CorticalEpochData4 ] = NEWEpochingCortical( filteredEEGdata4, Pre4, Post4, Fs);
        [ CorticalEpochData5 ] = NEWEpochingCortical( filteredEEGdata5, Pre5, Post5, Fs);
        [ CorticalEpochData6 ] = NEWEpochingCortical( filteredEEGdata6, Pre6, Post6, Fs);
        [ CorticalEpochData7 ] = NEWEpochingCortical( filteredEEGdata7, Pre7, Post7, Fs);
        [ CorticalEpochData8 ] = NEWEpochingCortical( filteredEEGdata8, Pre8, Post8, Fs);
        
        clear filteredEEGdata filteredEEGdata2 filteredEEGdata3 filteredEEGdata4 filteredEEGdata5 filteredEEGdata6 filteredEEGdata7 filteredEEGdata8
        %% (5.1) Removes first 8sec (2 x 4sec epoch) from each trial
        CorticalEpochData = CorticalEpochData(:,1:37,3:8);
        CorticalEpochData2 = CorticalEpochData2(:,1:37,3:8);
        CorticalEpochData3 = CorticalEpochData3(:,1:37,3:8);
        CorticalEpochData4 = CorticalEpochData4(:,1:37,3:8);
        CorticalEpochData5 = CorticalEpochData5(:,1:37,3:8);
        CorticalEpochData6 = CorticalEpochData6(:,1:37,3:8);
        CorticalEpochData7 = CorticalEpochData7(:,1:37,3:8);
        CorticalEpochData8 = CorticalEpochData8(:,1:37,3:8);
        
        
        %% StdAR Steam (6.5 v1) Combine the nine recording sessions into one matrix for ploting
        CorticalEpochData = cat(3,CorticalEpochData, CorticalEpochData2, CorticalEpochData3, CorticalEpochData4, CorticalEpochData5, CorticalEpochData6, CorticalEpochData7, CorticalEpochData8);
        %         [file1,path1] = uiputfile('*.mat','Save file');
        
        clearvars -except c s Condition subID CorticalEpochData Fs path1 tapNames tappingPath vhdrNames ContainingPath
        
        
        path1 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/mat files'];
        cd(path1);
        save([subID{s} '_' Condition{c}],'CorticalEpochData');
        
        %% StdAR Steam (7v1) Standard Artifact Rejection for Epoched Data (Cort ONLY)
        ArtifactThreshold = 100;
        [ArtifactedEpochData, PercCorticalArtifact] = EpochArtifactRej_maxsubmin( CorticalEpochData, ArtifactThreshold );
        %         EvokedEEG_Artifacted = nanmean(ArtifactedEpochData,3);
        %% (8) Analyzes in-eeg tapping to determine phase sorting for Evoked FFT
        load([subID{s} '_inEEG_TappingKey.mat'])
        %% (9) Calls Code to Perform FFT and Average per Electrode and plot response CORTICAL
        [ EvokedFFTdata ] = NEWCortFFT_8Parts( ArtifactedEpochData, Fs, subID, s, Condition, c, TapKey );
        %         [ CorticalFFTdata_win, EvokedFFTdata_win ] = NEWCortFFT_6PartsV2_win( ArtifactedEpochData, Fs, subID, s, Condition, c, TapKey );
        
        close all
        %% Save FFT data for later plotting or group analysis
        path1 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/mat files'];
        cd(path1);
%         save([subID{s} '_' Condition{c} '_InducedFFT'],'CorticalFFTdata');
        save([subID{s} '_' Condition{c} '_EvokedFFT'],'EvokedFFTdata');
        
        %% Cleanup
        clearvars -except c s Condition subID
    end
    
end
% NEWRhyEEGEMG_CortAnalysis_SCRIPT_6file
toc
%% HEAD MAPS
%Creates HeadMaps of 2Hz Activity relative to the power in the Delta Band
%(1-3Hz)

%[ z,Jetmap, relamp2hz ] = RelDelta2HzHeadMap( CorticalFFTdata );