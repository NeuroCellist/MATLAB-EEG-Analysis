function [ filteredEEGdata, Fs ] = BrainVision33Chw4EMG_RhyEEG_Preprocess(vhdrName, ContainingPath)
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

% Gain Variables
gain = 1;  % Gain of the pre-amp. The waveform amplitudes are later scaled down by this factor. 
EMGgain = 50;

%channel names vector for plotting
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand' 'Right Hand' 'Left Foot' 'Right Foot'};

% Filtering variables
highpass = 0.1; % in Hz
lowpass = 2000; %in Hz
zerophaseshiftfilter = 0; % 1 = yes, in this case use filtfilt
notchcut = 60;  % setting for notch filter, if a notch is applied it is also notching out 1000 as well
notch  = 0;  % 1 = yes, all other values equal no. 

%% (1). OPEN EEG file
[EEG, com] = pop_loadbv(path, hdrfile);

% determine sampling rate
rate = EEG.srate;

% undo the gain that was applied. 
EEG.data(1:33,:) = EEG.data(1:33,:)./gain;
EEG.data(34:end,:) = EEG.data(34:end,:)./EMGgain;

%% (2) Rerefference Data to a global avg
RefChan= zeros(1,size(EEG.data,2));
for r = 1:size(EEG.data,2)
    RefChan(r)= mean(EEG.data(1:32,r));
end
RefEEG=zeros(37,size(EEG.data,2));
for s=1:32
   RefEEG(s,:)=(EEG.data(s,:)-RefChan); 
end
RefEEG(33:37,:)=(EEG.data(33:37,:)); 
%% (3) FILTER THE RAW RECORDING %%% 
if zerophaseshiftfilter ~=1
[b,a] = butter(3, highpass/(rate/2),'high'); 
EEGfiltered = filter(b,a,double(RefEEG')); % or use filtfilt 
% phase shift
[b,a] = butter(3, lowpass/(rate/2),'low'); 
EEGfiltered = filter(b,a,EEGfiltered); % or use filtfilt 
end

if zerophaseshiftfilter == 1
    [b,a] = butter(3, highpass/(rate/2),'high'); 
     EEGfiltered = filtfilt(b,a,double(RefEEG')); % or use filtfilt  *zero
    [b,a] = butter(3, lowpass/(rate/2),'low'); 
    EEGfiltered = filtfilt(b,a,EEGfiltered); % or use filtfilt 
end

if notch ==1
  Wo = notchcut/(rate/2);  BW = Wo/35;
[d,c] = iirnotch(Wo,BW);    
EEGfiltered = filter(d,c,EEGfiltered); % or use filtfilt 
end

filteredEEGdata=EEGfiltered;
Fs = rate;

end

