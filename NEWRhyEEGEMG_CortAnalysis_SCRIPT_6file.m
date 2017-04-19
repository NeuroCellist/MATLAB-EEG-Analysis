%This is a Script that calls (in order) the code for the default RhyEEG
%Missing Pulse Study Cortical Frequency Analysis.  The only thing that
%needs to be changes is line 10 or 11 (the vhdr filename that you want to work
%with and its containing folder, respectivly).

clear all
close all
addpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/MATLAB Analysis code');
clc
%% (1) Define File to be used
subID = 'S1711';
Condition = 'Rand';
vhdrNames = cell(6,1);
for i = 1:6  
vhdrNames{i} = [subID '_' Condition '_' num2str(i) '.vhdr'];
end
ContainingPath = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID '/raw eeg'];
clear i
clc
%% (2) Calls Preprocessing Code and returnes basic filtered Data with new Channels from StimTrak  %%
[ filteredEEGdata, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{1}, ContainingPath);
[ filteredEEGdata2, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{2}, ContainingPath);
[ filteredEEGdata3, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{3}, ContainingPath);
[ filteredEEGdata4, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{4}, ContainingPath);
[ filteredEEGdata5, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{5}, ContainingPath);
[ filteredEEGdata6, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrNames{6}, ContainingPath);

figure
ReviewEEG_6trials
figure(2)
ReviewEMG_6trials
%% (2.5) TRIM TRIALS TO ONLY INCLUDE LISTENING PORTION
%Trim files to eliminate extra pre and post recording data
%Stop is determined individually for each recording in order to remove
%extra data before stim presentation began

stop1 = 76230;
stop2 = 75830;
stop3 = 74320;
stop4 = 75800;
stop5 = 74720;
stop6 = 75610;

durration = ((Fs*34)-1);

filteredEEGdata = filteredEEGdata((stop1-durration):stop1,:);
filteredEEGdata2 = filteredEEGdata2((stop2-durration):stop2,:);
filteredEEGdata3 = filteredEEGdata3((stop3-durration):stop3,:);
filteredEEGdata4 = filteredEEGdata4((stop4-durration):stop4,:);
filteredEEGdata5 = filteredEEGdata5((stop5-durration):stop5,:);
filteredEEGdata6 = filteredEEGdata6((stop6-durration):stop6,:);

figure
ReviewEEG_6trials
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

StimCheck = zeros(1,6);
StimCheck(1,1) = sum(filteredEEGdata(:,38));
StimCheck(1,2) = sum(filteredEEGdata2(:,38));
StimCheck(1,3) = sum(filteredEEGdata3(:,38));
StimCheck(1,4) = sum(filteredEEGdata4(:,38));
StimCheck(1,5) = sum(filteredEEGdata5(:,38));
StimCheck(1,6) = sum(filteredEEGdata6(:,38));

StimCheck
%% StdAR Steam (4) Calls Code that defines Segmentation Points for Envelope Epoching
[ Pre, Post] = NEWSegmentation4sEMG( filteredEEGdata, Fs);
[ Pre2, Post2] = NEWSegmentation4sEMG( filteredEEGdata2, Fs);
[ Pre3, Post3] = NEWSegmentation4sEMG( filteredEEGdata3, Fs);
[ Pre4, Post4] = NEWSegmentation4sEMG( filteredEEGdata4, Fs);
[ Pre5, Post5] = NEWSegmentation4sEMG( filteredEEGdata5, Fs);
[ Pre6, Post6] = NEWSegmentation4sEMG( filteredEEGdata6, Fs);

%% StdAR Steam (5) Calls Code That Epochs Data and Outputs a multidimensional matrix
[ CorticalEpochData ] = NEWEpochingCortical( filteredEEGdata, Pre, Post, Fs);
[ CorticalEpochData2 ] = NEWEpochingCortical( filteredEEGdata2, Pre2, Post2, Fs);
[ CorticalEpochData3 ] = NEWEpochingCortical( filteredEEGdata3, Pre3, Post3, Fs);
[ CorticalEpochData4 ] = NEWEpochingCortical( filteredEEGdata4, Pre4, Post4, Fs);
[ CorticalEpochData5 ] = NEWEpochingCortical( filteredEEGdata5, Pre5, Post5, Fs);
[ CorticalEpochData6 ] = NEWEpochingCortical( filteredEEGdata6, Pre6, Post6, Fs);

% StdAR Steam (5.1) Removes first 4sec epoch from each trial
CorticalEpochData = CorticalEpochData(:,1:37,2:8);
CorticalEpochData2 = CorticalEpochData2(:,1:37,2:8);
CorticalEpochData3 = CorticalEpochData3(:,1:37,2:8);
CorticalEpochData4 = CorticalEpochData4(:,1:37,2:8);
CorticalEpochData5 = CorticalEpochData5(:,1:37,2:8);
CorticalEpochData6 = CorticalEpochData6(:,1:37,2:8);

%% StdAR Steam (6.5 v1) Combine the nine recording sessions into one matrix for ploting
CorticalEpochData = cat(3,CorticalEpochData, CorticalEpochData2, CorticalEpochData3, CorticalEpochData4, CorticalEpochData5, CorticalEpochData6);
[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'CorticalEpochData');

%% StdAR Steam (7v1) Standard Artifact Rejection for Epoched Data (Cort ONLY)
ArtifactThreshold = 150;
[ArtifactedEpochData, PercCorticalArtifact] = NEWEpochArtifactRej_nar( CorticalEpochData, ArtifactThreshold );

%% (8) Calls Code to Perform FFT and Average per Electrode and plot response CORTICAL
[ CorticalFFTdata ] = NEWCortFFT_6Parts( ArtifactedEpochData, Fs );

%% Save FFT data for later plotting or group analysis
[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'CorticalFFTdata');

%% HEAD MAPS
%Creates HeadMaps of 2Hz Activity relative to the power in the Delta Band
%(1-3Hz)
[ z,Jetmap, relamp2hz ] = RelDelta2HzHeadMap( CorticalFFTdata );