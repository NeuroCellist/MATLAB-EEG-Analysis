% Prepare to process data by setting the default paths and clearing all
% existing variables and closing any figures;
close all 
clear all
addpath([cd, '\programFiles\']);  % location of all of the subfunctions that will be called to process the data

% a pop-up window will appear prompting using to select vhdr. 
[hdrfile, path] = uigetfile('C:\Users\SkoeLab\DATA\*cl*.vhdr', 'Pick a CLICK file'); % loads up browse window where you can select the file to run.
avgpath = path; % save the output to the same folder as the input.
figpath =  path; % where figures are saved.

% List of triggers to process.  If using single polarity, select AltPol to be equal to 0.  
Trigger{1} = 'S  1';
AltPol = 0;  %1 = yes, 0 = no

%set epoching window, based on the stimulus onset (not the trigger onset).
prestim =  5;  % in ms (assumes a negative number, i.e. 10 = 10 ms before the stimulus).
poststim = 15; %in ms
analysisend =8; % end of response window.  Used to perform SNR calculations.
numtrials = 2000;  
CHANNELS = 1:33;  %set of channels to analyze.  If you wanted a subset you could dispaly as CHANNELS = [1 10 17];


%% DO NOT EDIT UNLESS YOU HAVE A REALLY GOOD REASON. 
zerophaseshiftfilter = 0;  %if 1 = zerophaseshift, if 0 = analog. 
highpass = 100; % in Hz x
lowpass = 1500; %in Hz

artifact_rej = 100; %in microvolts
binsize = 100;  %for subaveraging into smaller chunks, represents how many of each trigger to include

%% variable values that sholdn't be changed, unless the recording setup changes 
PyCorder = 0;  % If 1 then assumes Pycorder was used to make recorders, if 0 then Recorder. Pycorder does not take into account the 50x gain that was applied by the pre-am 
threshold = 10000;


stimchannel =34;
gain = 50;  %gain of each pre-amp;

stimulus_delay = 0;  % The extent of the stimulus delay is being automatically corrected for (added May 2015). Previously somewhere between between 0.65 and 0.68);  The stimulus preceeds the trigger by -0.68 ms. 
tubedelay = 0.8; % in ms
numbertubes = 1;
invertwaveform = 0;  % if 1 then the waveform will be flipped in polarity, if a number other than 1, no correction is applied. This is used when the laction of the references is moved.

notch  = 1;  % 1 = yes, all other values equal no. 
BVPreProcessing_StimTrak_Multi(path, hdrfile, avgpath,  AltPol,PyCorder, Trigger, threshold, prestim, poststim, analysisend, zerophaseshiftfilter, highpass, lowpass, artifact_rej,notch, CHANNELS, stimchannel, binsize, numtrials, figpath) 

