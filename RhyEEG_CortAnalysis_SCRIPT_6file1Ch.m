%This is a Script that calls (in order) the code for the default RhyEEG
%Missing Pulse Study Cortical Frequency Analysis.  The only thing that
%needs to be changes is line 10 or 11 (the vhdr filename that you want to work
%with and its containing folder, respectivly).

clear all
close all
clc

%% (1) Define File to be used
vhdrName = ('S1_Rand_1.vhdr');
vhdrName2 = ('S1_Rand_2.vhdr');
vhdrName3 = ('S1_Rand_3.vhdr');
vhdrName4 = ('S1_Rand_4.vhdr');
vhdrName5 = ('S1_Rand_5.vhdr');
vhdrName6 = ('S1_Rand_6.vhdr');


ContainingPath = '/Users/charleswasserman/Dropbox (MDL)/ASDMusic/_DATA/EEG/201701';
Threshold = 10000;
ArtifactThreshold = 150;
%% (2) Calls Preprocessing Code and returnes basic filtered Data with new Channels from StimTrak  %%
[ filteredEEGdata, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName, ContainingPath);
[ filteredEEGdata2, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName2, ContainingPath);
[ filteredEEGdata3, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName3, ContainingPath);
[ filteredEEGdata4, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName4, ContainingPath);
[ filteredEEGdata5, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName5, ContainingPath);
[ filteredEEGdata6, Fs ] = BrainVision1Ch_RhyEEG_Preprocess(vhdrName6, ContainingPath);

subplot(3,2,1)
plot(filteredEEGdata(:,end),'DisplayName','filteredEEGdata(:,end)','YDataSource','filteredEEGdata(:,end)');figure(gcf)
subplot(3,2,2)
plot(filteredEEGdata2(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,3)
plot(filteredEEGdata3(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,4)
plot(filteredEEGdata4(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,5)
plot(filteredEEGdata5(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,6)
plot(filteredEEGdata6(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)

%% (2.5)OPTIONAL
%Trim files to eliminate extra pre and post recording data

%Start is determined individually for each recording in order to remove
%extra data before stim presentation began

%Stop is determined by finding the last tone onset in the StimTrak channel
%and adding 9sec (45000 samples) NOTE: if the recording was stopped too
%soon this point may not exist.

stop1 = 189300;
stop2 = 187300;
stop3 = 187400;
stop4 = 186800;
stop5 = 186100;
stop6 = 189600;

durration = 167499;

filteredEEGdata = filteredEEGdata((stop1-durration):stop1,:);
filteredEEGdata2 = filteredEEGdata2((stop2-durration):stop2,:);
filteredEEGdata3 = filteredEEGdata3((stop3-durration):stop3,:);
filteredEEGdata4 = filteredEEGdata4((stop4-durration):stop4,:);
filteredEEGdata5 = filteredEEGdata5((stop5-durration):stop5,:);
filteredEEGdata6 = filteredEEGdata6((stop6-durration):stop6,:);


subplot(3,2,1)
plot(filteredEEGdata(:,end),'DisplayName','filteredEEGdata(:,end)','YDataSource','filteredEEGdata(:,end)');figure(gcf)
subplot(3,2,2)
plot(filteredEEGdata2(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,3)
plot(filteredEEGdata3(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,4)
plot(filteredEEGdata4(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,5)
plot(filteredEEGdata5(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(3,2,6)
plot(filteredEEGdata6(:,end),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)

%% (3) EXTRACT STIMTRAK CHANNEL AND CREATE CHANNELS FOR FFR AND CORTICAL ANALYSIS MARKERS %%
%NOTE: Find threshold for StimTrak before running part 3 or the default of
%20,000 will be used.
[filteredEEGdata] = PlaceMarkers_1Ch(filteredEEGdata, Threshold, Fs);
[filteredEEGdata2] = PlaceMarkers_1Ch(filteredEEGdata2, Threshold, Fs);
[filteredEEGdata3] = PlaceMarkers_1Ch(filteredEEGdata3, Threshold, Fs);
[filteredEEGdata4] = PlaceMarkers_1Ch(filteredEEGdata4, Threshold, Fs);
[filteredEEGdata5] = PlaceMarkers_1Ch(filteredEEGdata5, Threshold, Fs);
[filteredEEGdata6] = PlaceMarkers_1Ch(filteredEEGdata6, Threshold, Fs);


StimCheck = zeros(1,6);
StimCheck(1,1) = sum(filteredEEGdata(:,3));
StimCheck(1,2) = sum(filteredEEGdata2(:,3));
StimCheck(1,3) = sum(filteredEEGdata3(:,3));
StimCheck(1,4) = sum(filteredEEGdata4(:,3));
StimCheck(1,5) = sum(filteredEEGdata5(:,3));
StimCheck(1,6) = sum(filteredEEGdata6(:,3));

StimCheck
%% StdAR Steam (4) Calls Code that defines Segmentation Points for Envelope Epoching
[ Pre, Post] = NEWSegmentation4s_1Ch( filteredEEGdata, Threshold, Fs);
[ Pre2, Post2] = NEWSegmentation4s_1Ch( filteredEEGdata2, Threshold, Fs);
[ Pre3, Post3] = NEWSegmentation4s_1Ch( filteredEEGdata3, Threshold, Fs);
[ Pre4, Post4] = NEWSegmentation4s_1Ch( filteredEEGdata4, Threshold, Fs);
[ Pre5, Post5] = NEWSegmentation4s_1Ch( filteredEEGdata5, Threshold, Fs);
[ Pre6, Post6] = NEWSegmentation4s_1Ch( filteredEEGdata6, Threshold, Fs);

%% StdAR Steam (5) Calls Code That Epochs Data and Outputs a multidimensional matrix
[ CorticalEpochData ] = EpochingCortical_1Ch( filteredEEGdata, Pre, Post, Fs);
[ CorticalEpochData2 ] = EpochingCortical_1Ch( filteredEEGdata2, Pre2, Post2, Fs);
[ CorticalEpochData3 ] = EpochingCortical_1Ch( filteredEEGdata3, Pre3, Post3, Fs);
[ CorticalEpochData4 ] = EpochingCortical_1Ch( filteredEEGdata4, Pre4, Post4, Fs);
[ CorticalEpochData5 ] = EpochingCortical_1Ch( filteredEEGdata5, Pre5, Post5, Fs);
[ CorticalEpochData6 ] = EpochingCortical_1Ch( filteredEEGdata6, Pre6, Post6, Fs);

%% StdAR Steam (5.1) Removes first 4sec epoch from each trial

CorticalEpochData = CorticalEpochData(:,:,2:8);
CorticalEpochData2 = CorticalEpochData2(:,:,2:8);
CorticalEpochData3 = CorticalEpochData3(:,:,2:8);
CorticalEpochData4 = CorticalEpochData4(:,:,2:8);
CorticalEpochData5 = CorticalEpochData5(:,:,2:8);
CorticalEpochData6 = CorticalEpochData6(:,:,2:8);

%% StdAR Steam (6.5 v1) Combine the nine recording sessions into one matrix for ploting
CorticalEpochData = cat(3,CorticalEpochData, CorticalEpochData2, CorticalEpochData3, CorticalEpochData4, CorticalEpochData5, CorticalEpochData6);

%% Save The Data
[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'CorticalEpochData');

%% StdAR Steam (7v1) Standard Artifact Rejection for Epoched Data (Cort ONLY)
[ArtifactedEpochData, PercCorticalArtifact] = EpochArtifactRej_nar( CorticalEpochData, ArtifactThreshold );

%%  Applies Window Tapering
[bTaperArtifactedEpochData] = BlackmanTaper(ArtifactedEpochData);
[hTaperArtifactedEpochData] = HanningTaper(ArtifactedEpochData);
%% (8) Calls Code to Perform FFT and Average per Electrode and plot response CORTICAL
[ bCorticalFFTdata ] = CortFFT_6Parts_1Ch( bTaperArtifactedEpochData, Fs );
[ hCorticalFFTdata ] = CortFFT_6Parts_1Ch( hTaperArtifactedEpochData, Fs );
[ CorticalFFTdata ] = CortFFT_6Parts_1Ch( ArtifactedEpochData, Fs );

%%
[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'CorticalFFTdata');


%% =============================
%% NDAR Stream(6.5 v1) Combine the nine recording sessions into one matrix for resampling then NDAR
ndarCorticalEpochData=[];
for i = 1:size(CorticalEpochData,3)
    if i ==1
        ndarCorticalEpochData = CorticalEpochData(:,:,i);
    end
    ndarCorticalEpochData = cat(1,ndarCorticalEpochData, CorticalEpochData(:,:,i));
end

[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'ndarCorticalEpochData');

%% NDAR Stream (7) Resampling from 5000Hz to 200Hz
ndarCorticalEpochData=[];
for i = 1:size(CorticalEpochData,3)
   ndarCorticalEpochData(:,:,i) = resample(CorticalEpochData(:,:,i),1,25);
end

NewFs=200;

%% NDAR Stream (8) Perform Non-Destructive Artifact Rejection procedure from Mourad et al., 2007
%ndarCleanEEG = AB_alg_window(ndarLoResEpochData,NewFs,ArtifactThreshold,'total');
ndarCleanEEG=[];
for i = 1:size(ndarCorticalEpochData,3)
ndarCleanEEG(:,:,i) = OriginalAB_alg_window(ndarCorticalEpochData(:,:,i),NewFs,150,'window');
end

%% (9) Calls Code to Perform FFT and Average per Electrode and plot response CORTICAL
[ ndarCorticalFFTdata ] = CortFFT_6Parts( ndarCleanEEG, NewFs );

%% =================================
%% (12) Analysis of Beta amplitude oscilations (wants data after ArtRej and Avging in 2D)

[ PercArtifact, BetaAmpOscCorticalFFTData] = AmpOscFFT(CorticalEpochData, 30, 13, Fs, 150, 3);
%%
[file1,path1] = uiputfile('*.mat','Save file');
cd(path1);
save(file1,'BetaAmpOscCorticalFFTData');
