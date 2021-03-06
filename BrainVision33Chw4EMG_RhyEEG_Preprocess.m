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
EMGgain = 100;

%channel names vector for plotting
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};

% Filtering variables
highpass = 0.2; % in Hz
% lowpass = 900; %in Hz
EMGlowpass = 59; %in Hz
zerophaseshiftfilter = 0; % 1 = yes, in this case use filtfilt
notchcut = 60;  % setting for notch filter, if a notch is applied it is also notching out 1000 as well
notch  = 0;  % 1 = yes, all other values equal no.

%% (1). OPEN EEG file
[EEG, com] = pop_loadbv(path, hdrfile);

% determine sampling rate
rate = EEG.srate;
dsRatio = (rate/1000); %ratio by which data is downsampled using the decimate function (takes native Fs and turns it into 1000Hz)

% undo the gain that was applied.
EEGdata(1:33,:) = EEG.data(1:33,:)./gain;
EEGdata(34:37,:) = EEG.data(34:37,:)./EMGgain;

%% (2) Rerefference Data to a global avg
RefChan= zeros(1,size(EEGdata,2));
for r = 1:size(EEGdata,2)
    RefChan(r)= mean(EEGdata(1:32,r));
end
RefEEG=zeros(33,size(EEGdata,2));
for s=1:32
    RefEEG(s,:)=(EEGdata(s,:)-RefChan);
end
RefEEG(33:37,:)=(EEGdata(33:37,:));

%% (3) FILTER THE RAW EEG RECORDING %%%
if zerophaseshiftfilter ~=1
    [b,a] = butter(3, highpass/(rate/2),'high');
    EEGfiltered = filter(b,a,double(RefEEG(1:33,:)')); % or use filtfilt
    % phase shift
    %     [b,a] = butter(3, lowpass/(rate/2),'low');
    %     EEGfiltered = filter(b,a,EEGfiltered); % or use filtfilt
    for i= 1:33
        EEGfiltered2(:,i) =decimate(double(RefEEG(i,:)'),dsRatio);
    end
end

if zerophaseshiftfilter == 1
    [b,a] = butter(3, highpass/(rate/2),'high');
    EEGfiltered = filtfilt(b,a,double(RefEEG(1:33,:)')); % or use filtfilt  *zero
    %     [b,a] = butter(3, lowpass/(rate/2),'low');
    %     EEGfiltered = filtfilt(b,a,EEGfiltered); % or use filtfilt
    for i= 1:33
        EEGfiltered2(:,i) =decimate(double(RefEEG(i,:)'),dsRatio);
    end
end

filteredEEGdata=EEGfiltered2;
EMGdata1=RefEEG(34:37,:)';
clear i
%% (4) FILTER EMG THEN REMOVE BIAS AND FULL WAVE RECTIFY (Ch34-37)
for i=1:4
    EMGdata(:,i) = decimate(EMGdata1(:,i),dsRatio);
end
[b,a] = butter(3, EMGlowpass/(rate/2),'low');
EMGdata = filter(b,a,EMGdata); % or use filtfilt

for c = 1:size(EMGdata,1)
    ChanAvg = mean(EMGdata(c,:));
    unbiasedEMG=nan(size(1,size(EMGdata,2)));
    for s = 1:size(EMGdata,2)
        unbiasedEMG(1,s)=(EMGdata(c,s)-ChanAvg);
    end
    EMGdata(c,:)=abs(unbiasedEMG(1,:));
end

%% (5) REASSEMBLE DATA INTO OUPUT MATRIX AND APPLY NOTCH FILTER (OPTIONAL)
filteredEEGdata=cat(2, filteredEEGdata,EMGdata);
Fs = rate/dsRatio;

if notch ==1
    Wo = notchcut/(rate/2);  BW = Wo/35;
    [d,c] = iirnotch(Wo,BW);
    filteredEEGdata = filter(d,c,filteredEEGdata); % or use filtfilt
end
end

