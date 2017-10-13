% RhyEEG Group Data Processing
clear all
clc
%% Creates Name variables to Read in Data (set for loop iteration value to # of subjects)
% numSub = 16;
% subIDs = cell(numSub,1);
Conditions = {'ISO', 'Comp1', 'Comp2', 'Rand'};
subIDs = {'Sum1701';'Sum1702';'Sum1703';'Sum1704'};

newMPdata = {};
newMPdata.fs = 1000;
newMPdata.numSub = size(subIDs,1);
newMPdata.Conditions = Conditions;

newMPdata_PLV = {};
newMPdata_PLV.fs = 1000;
newMPdata_PLV.numSub = size(subIDs,1);
newMPdata_PLV.Conditions = Conditions;
% for s = 2:numSub+1
%     if size(num2str(s),2) == 2
%         subIDs{s-1} = ['S17' num2str(s)];
%     else
%         subIDs{s-1} = ['S170' num2str(s)];
%     end
% end

clear s numSub Conditions
%% Sets Up MPdata cell structure
newMPdata.SubFFTData_Evoked{1,1} = 'SubjectID';
newMPdata.SubFFTData_Evoked{2,1} = 'ISO_EEG';
newMPdata.SubFFTData_Evoked{3,1} = 'MP1_EEG';
newMPdata.SubFFTData_Evoked{4,1} = 'MP2_EEG';
newMPdata.SubFFTData_Evoked{5,1} = 'Rand_EEG';
%

%
newMPdata.GrpEvokedFFT = [];

%% Sets Up MPdata cell structure for time-series data
newMPdata.SubData_Evoked{1,1} = 'SubjectID';
newMPdata.SubData_Evoked{2,1} = 'ISO_EEG';
newMPdata.SubData_Evoked{3,1} = 'MP1_EEG';
newMPdata.SubData_Evoked{4,1} = 'MP2_EEG';
newMPdata.SubData_Evoked{5,1} = 'Rand_EEG';


%% Read In Individual Subject Data
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/'))

for s = 1: size(subIDs,1)
    SubID = subIDs{s};
    newMPdata.SubData_Evoked{1,s+1} = SubID;
    newMPdata.SubFFTData_Evoked{1,s+1} = SubID;
    %     newMPdata.SubFFTData_Induced{1,s+1} = SubID;
    for c = 1:4
        Cond = newMPdata.Conditions{c};
        FileName = [SubID '_' Cond '.mat'];
        load(FileName)
        [ArtifactedEpochData, PercArtifact] = EpochArtifactRej_maxsubmin(CorticalEpochData, 100);
        newMPdata.SubData_Evoked{(c+1),(s+1)} = ArtifactedEpochData;
        
        clear CorticalEpochData ArtifactedEpochData PercArtifact
    end
    clear c
    for c = 1:4
        Cond = newMPdata.Conditions{c};
        FileName = [SubID '_' Cond '_EvokedFFT.mat'];
        load(FileName)
        newMPdata.SubFFTData_Evoked{(c+1),(s+1)} = EvokedFFTdata;
        clear EvokedFFTdata
    end
    clear c
end
%% Save Group and AvgGroup FFT data
for c = 1:4
    newMPdata.GrpEvokedFFT{c,1} = newMPdata.Conditions{c};
    newMPdata_PLV.GrpEvokedFFT{c,1} = newMPdata.Conditions{c};
    
    %     newMPdata.GrpInducedFFT{c,1} = newMPdata.Conditions{c};
    newMPdata.GrpEvokedFFT{c,2} = cat(3,newMPdata.SubFFTData_Evoked{c+1,2:end});
    %     newMPdata.GrpInducedFFT{c,2} = cat(3,newMPdata.SubFFTData_Induced{c+1,2:end});
    newMPdata.GrpEvokedFFT{c,3} = nanmean(newMPdata.GrpEvokedFFT{c,2},3);
    newMPdata_PLV.GrpEvokedFFT{c,2} = nanmean(newMPdata.GrpEvokedFFT{c,2},3);
    
end
clear c s SubID FileName Cond newMPdata.SubFFTData_Induced newMPdata.SubFFTData_Evoked

%% Sets Up MPdata cell structure for Artifact Rejected time-series data
newMPdata_PLV.SubData_Evoked_AR{1,1} = 'SubjectID';
newMPdata_PLV.SubData_Evoked_AR{2,1} = 'ISO_EEG';
newMPdata_PLV.SubData_Evoked_AR{3,1} = 'MP1_EEG';
newMPdata_PLV.SubData_Evoked_AR{4,1} = 'MP2_EEG';
newMPdata_PLV.SubData_Evoked_AR{5,1} = 'Rand_EEG';

newMPdata_PLV.ARperc{1,1} = 'SubjectID';
newMPdata_PLV.ARperc{2,1} = 'ISO Condition';
newMPdata_PLV.ARperc{3,1} = 'MP1 Condition';
newMPdata_PLV.ARperc{4,1} = 'MP2 Condition';
newMPdata_PLV.ARperc{5,1} = 'Rand Condition';
% newMPdata.GrpAvgTimeSeries = [];

%% Run AR on Individual Subject Data
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/'))
Conditions = {'ISO', 'Comp1', 'Comp2', 'Rand'};
subIDs = {'Sum1701';'Sum1702';'Sum1703';'Sum1704'};
for s = 1: size(subIDs,1)
    SubID = subIDs{s};
    newMPdata_PLV.SubData_Evoked_AR{1,s+1} = SubID;
    newMPdata_PLV.ARperc{1,s+1} = SubID;
    
    for c = 1:4
        [ArtifactedEpochData, PercArtifact] = EpochArtifactRej_maxsubmin(newMPdata.SubData_Evoked{(c+1),(s+1)}, 100);
        newMPdata_PLV.SubData_Evoked_AR{(c+1),(s+1)} = ArtifactedEpochData;
        newMPdata_PLV.ARperc{(c+1),(s+1)} = PercArtifact;
        
        
        clear  ArtifactedEpochData PercArtifact
    end
    clear c s SubID
    
end
%% Create Grp AR  and PLV Data
for c = 1:4
    newMPdata_PLV.SubData_GrpEvoked{c,1} = newMPdata.Conditions{c};
    newMPdata_PLV.SubData_GrpPLV{c,1} = newMPdata.Conditions{c};
    newMPdata_PLV.SubData_cPCA{c,1} = newMPdata.Conditions{c};
    
    newMPdata_PLV.SubData_GrpEvoked{c,2} = cat(3,newMPdata.SubData_Evoked_AR{c+1,2:end});
    [newMPdata_PLV.SubData_cPCA{c,1}, newMPdata_PLV.SubData_GrpPLV{c,1}, newMPdata_PLV.cpcaF]=RhyEEG_cpca(newMPdata.GrpEvokedFFT{c,2},newMPdata_PLV.fs);
end
clear c s SubID FileName Cond newMPdata.SubFFTData_Induced newMPdata.SubFFTData_Evoked

%%  TESTING w/ WAVELETS

%NOTE  Doing wavelet on cPCA timedomain output is valid in terms of phase
%sorting

newMPdata.grpISO = nanmean(newMPdata.SubData_GrpEvoked{1,2},3);
newMPdata.grpMP1 = nanmean(newMPdata.SubData_GrpEvoked{2,2},3);
% MP2 = nanmean(newMPdata.SubData_GrpEvoked{3,2},3); %NO!
newMPdata.grpRand = nanmean(newMPdata.SubData_GrpEvoked{4,2},3);

%%  Plotting cPCA PLV by Condition
f=newMPdata.cpcaF;
subplot(2,2,1) %ISO
plot(f,newMPdata.SubData_GrpPLV{1,1})
xlim([0.5 10])
subplot(2,2,2) %MP1
plot(f,newMPdata.SubData_GrpPLV{2,1})
xlim([0.5 10])
subplot(2,2,3) %MP2
plot(f,newMPdata.SubData_GrpPLV{3,1})
xlim([0.5 10])
subplot(2,2,4) %Rand
plot(f,newMPdata.SubData_GrpPLV{4,1})
xlim([0.5 10])
%%  FINAL GROUP PLOT (Full Cap)
%ISO
NEWGroup_CorticalFFT_PLOT( newMPdata.GrpEvokedFFT{1,2}, newMPdata.fs )
%Comp1
NEWGroup_CorticalFFT_PLOT( newMPdata.GrpEvokedFFT{2,2}, newMPdata.fs )
%Comp2
NEWGroup_CorticalFFT_PLOT( newMPdata.GrpEvokedFFT{3,2}, newMPdata.fs )
%Rand
NEWGroup_CorticalFFT_PLOT( newMPdata.GrpEvokedFFT{4,2}, newMPdata.fs )

%% Group Plot (best 3 electrodes avg per subject)
%ISO
[top5chans,chans4Rand] = FULLCorticalFFT_Avg5PLOT( newMPdata.GrpEvokedFFT{1,2}, newMPdata.fs)
%Comp1
[top5chans] = FULLCorticalFFT_Avg5PLOT( newMPdata.GrpEvokedFFT{2,2}, newMPdata.fs)
[top5chans] = FULLCorticalFFT_Avg5PLOT_rand( newMPdata.GrpEvokedFFT{2,2}, newMPdata.fs,chans4Rand)

%Comp2
[top5chans] = FULLCorticalFFT_Avg5PLOT( newMPdata.GrpEvokedFFT{3,2}, newMPdata.fs)
%Rand
[top5chans] = FULLCorticalFFT_Avg5PLOT_rand( newMPdata.GrpEvokedFFT{4,2}, newMPdata.fs,chans4Rand)

%% FINAL GROUP PLOT W/ Nazoradan Binning Procedure
Group_CorticalFFT_PLOT_Syl( ISO_N7_FFTData, newMPdata.fs)
%% Final Cortical PLotting (All Subjects, Group Avg, and StimTrak; One Electrode ONLY)
FULLCorticalFFT_1ChPLOT( Comp1_N7_FFTData, 'P8', newMPdata.fs)

%% Single Subject, one cond and one elctrode Pressentation Plots
EEGTapDEMO_1ChPLOT( S1706_ISO_FFT, 'Fp1', S1706_ISO_Tap, newMPdata.fs )
%% Relative Delta Power Head Maps
%Creates HeadMaps of 2Hz Activity relative to the power in the Delta Band
%(1-3Hz)

[z,Jetmap] = RelDelta2HzHeadMap(Comp1_N7_FFTData);
