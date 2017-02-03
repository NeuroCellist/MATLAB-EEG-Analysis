% RhyEEG Group Data Processing
clear all
clc
%% Reads in FFT Data (repeat as needed)
cd('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/N10/Cortical Data/ISO')
load('s1_ISO_CortData.mat')
s1_ISO_CortData = CorticalEpochData;
clear CorticalEpochData

%% Concatenating Subjects into a single condition variable
ISO_PilotN3_FFTData = cat(3, ISO_2p4,ISO_2p6,ISO_2p7);
Comp1_PilotN3_FFTData = cat(3, Comp1_2p4,Comp1_2p6,Comp1_2p7);
Comp2_PilotN3_FFTData = cat(3, Comp2_2p4,Comp2_2p6,Comp2_2p7);
Rand_PilotN3_FFTData = cat(3, Rand_2p4,Rand_2p6,Rand_2p7);

%%  FINAL GROUP PLOT
NEWGroup_CorticalFFT_PLOT( Rand_PilotN3_FFTData, 5000 )

%% FINAL GROUP PLOT W/ Nazoradan Binning Procedure
Group_CorticalFFT_PLOT_Syl( Comp1_PilotN3_FFTData, 5000)
%% Final Cortical PLotting (All Subjects, Group Avg, and StimTrak; Cz ONLY)
FULLCorticalFFT_CzPLOT( ISNR_Comp1, 5000)
%% Same, but with Fp1 ONLY
FULLCorticalFFT_Fp1PLOT( ISNR_Comp2, 5000)
%% Final Group Plot with Nazoradan Normalization

Group_CorticalCapFFT_SylviePLOT( ISNR_Comp2, 5000 );
%% Relative Delta Power Head Maps
%Creates HeadMaps of 2Hz Activity relative to the power in the Delta Band
%(1-3Hz)

[z,Jetmap] = RelDelta2HzHeadMap(Rand_PilotN3_FFTData);
