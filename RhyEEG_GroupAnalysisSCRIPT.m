% RhyEEG Group Data Processing
clear all
clc
%% Reads in FFT Data (set for loop iteration value to # of subjects)
numSub = 10;
subIDs = cell(numSub,1);
Conditions = {'ISO', 'Comp1', 'Comp2', 'Rand'};
RhyEEGData = {};
for s = 1:numSub
    if size(num2str(s),2) == 2
   subIDs{s} = ['S17' num2str(s)]; 
    else
        subIDs{s} = ['S170' num2str(s)]; 
    end
end
clear s
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/'))
FileName = {};
FileName = [subID '_' Condition '.mat'];
%%
load(FileName)
FileName{1} = CorticalEpochData;
clear CorticalEpochData

%% Concatenating Subjects into a single condition variable
ISO_N7_FFTData = cat(3, ISO_N7_FFTData,ISO8);
Comp1_N7_FFTData = cat(3, Comp1_N7_FFTData,C18);
Comp2_N7_FFTData = cat(3, Comp2_N7_FFTData,C28);
%Rand_N7_FFTData = cat(3, Rand_2p4,Rand_2p6,Rand_2p7);

%%  FINAL GROUP PLOT
Fs=2000;
NEWGroup_CorticalFFT_PLOT( Comp2_N7_FFTData, Fs )

%% FINAL GROUP PLOT W/ Nazoradan Binning Procedure
Group_CorticalFFT_PLOT_Syl( ISO_N7_FFTData, 2000)
%% Final Cortical PLotting (All Subjects, Group Avg, and StimTrak; One Electrode ONLY)
FULLCorticalFFT_1ChPLOT( Comp1_N7_FFTData, 'P8', 2000)

%% Single Subject, one cond and one elctrode Pressentation Plots
EEGTapDEMO_1ChPLOT( S1706_ISO_FFT, 'Fp1', S1706_ISO_Tap, 2000 )
%% Relative Delta Power Head Maps
%Creates HeadMaps of 2Hz Activity relative to the power in the Delta Band
%(1-3Hz)

[z,Jetmap] = RelDelta2HzHeadMap(Comp1_N7_FFTData);
