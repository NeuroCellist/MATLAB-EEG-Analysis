function [ filteredEEGdata, Fs ] = BrainVision32Ch_RhyEEG_Preprocess(vhdrName, ContainingPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Needs the vhdr file name, and filepath that contains the 3 BrainVision Files (usually
%'C:\RhyEEG\Raw Recordings')

%% VARIABLES TO SET %%%%%%%%%%%%%%%%%

if nargin <2

   ContainingPath = 'C:\RhyEEG\Raw Recordings';
   
   display('Using Default Raw Data Folder "C:\RhyEEG\Raw Recordings"')
end
path = (ContainingPath);  %location of data file
hdrfile = (vhdrName); %file name, The code to open the file is finicky; it seems to require that the name end in numbers greater than 1


avgpath = path; %where output files get saved.

Trigger1 = 'S  1';
Trigger2 = 'S  1';
prestim = 50;  % in ms  (assumes a negative number, i.e. 10 = 10 ms before the trigger).
poststim = 250; %in ms
analysisend =200; % end of response window ss

gain = 1;  % Gain of the pre-amp. The waveform amplitudes are later scaled down by this factor. 

highpass = 0.1; % in Hz
lowpass = 2000; %in Hz

zerophaseshiftfilter = 0; % 1 = yes, in this case use filtfilt
correct_errandtriggers = 0;  %  1 = yes; otherwise all triggers that match the Trigger 1 and Trigger 2 values will be included. 
presentationrate = 1.9; %used to exclude trials that occur too close in sucession. 

artifact_rej = 100; %+/- x microvolts
binsize = 100;  %for subaveraging into smaller chunks, represents how many of each trigger to include

%channel names vector for plotting

chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};

%% variable values that sholdn't be changed, unless the recording setup changes 
stimulus_delay = -0.68;  % in ms  (somewhere between 0.65 and 0.68);  The stimulus preceeds the trigger by -0.68 ms. 
tubedelay = 0.8; % in ms
numbertubes = 1;
invertwaveform = 0;  % if 1 then the waveform will be flipped in polarity, if a number other than 1, no correction is applied. 
notchcut = 60;  % setting for notch filter, if a notch is applied it is also notching out 1000 as well
notch  = 1;  % 1 = yes, all other values equal no. 
if invertwaveform == 1
    invert = -1;
elseif invertwaveform~=1
       invert = 1;
end
numtrials = 'all'; %non functional. 
% numtrials = '1000';
   


%  LINE BELOW:  C = vector of channel numbers that are to be read into
%  matlab
fftAVG = [];

for c = 1:32;
%% (1). OPEN EEG file
[EEG, com] = pop_loadbv(path, hdrfile, [], c );
%% determine sampling rate
rate = EEG.srate;
secperpoint = 1000/rate;
pre = prestim/secperpoint;
post = poststim/secperpoint;
correction = 0;  % if there is jitter between the even and odd trials that needs to be accounted for, the value should be represented in ms
totaltubes = tubedelay*numbertubes;
totaldelay = totaltubes+stimulus_delay;

%assuming perfect presentation rate the number of points between sounds
%should be as follows
pts = (1/presentationrate)*rate;

% undo the gain that was applied. 
EEG.data = EEG.data./gain;

%% (2) FILTER THE RAW RECORDING %%% 
if zerophaseshiftfilter ~=1
[b,a] = butter(3, highpass/(rate/2),'high'); 
EEGfiltered = filter(b,a,double(EEG.data')); % or use filtfilt 
% phase shift
[b,a] = butter(3, lowpass/(rate/2),'low'); 
EEGfiltered = filter(b,a,EEGfiltered); % or use filtfilt 
end

if zerophaseshiftfilter == 1
    [b,a] = butter(3, highpass/(rate/2),'high'); 
     EEGfiltered = filtfilt(b,a,double(EEG.data')); % or use filtfilt  *zero
    [b,a] = butter(3, lowpass/(rate/2),'low'); 
    EEGfiltered = filtfilt(b,a,EEGfiltered); % or use filtfilt 
end

filteredEEGdata(:,c)=EEGfiltered;
end

Fs = rate;

end

