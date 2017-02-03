function [epochSTIM epochSTIMcorrected startSTIM_index rate newzero]  = extractSTIM(path, hdrfile, Trigger1, prestim, poststim, threshold, channel)
%extracts stimulus using triggers at the anchors
%epochSTIM = all epochs using the original triggers to set time zero
%epochSTIMcorrected = epochs based on stim start as time zero.
%startSTIM_index = point within the epoch that marks where the stimulus
%newzero = point with the recording that marks the start of the stimulus;
%starts.

if nargin<7
    channel = 32;  % if channel # isn't provided, it assumes it is the second channel
end
%% (1). OPEN EEG file

[EEG, com] = pop_loadbv(path, hdrfile, [], channel);  %only open up the stim channel.


%% determine sampling rate
rate = EEG.srate;
secperpoint = 1000/rate;

pre = prestim/secperpoint;

post = poststim/secperpoint;

%set filter settings
zerophaseshiftfilter = 1;
highpassSTIM = 0.1;  % to aid in detecting the stimulus, little filtering is applied.
lowpassSTIM = 1000;
notch = 0;  % no notch filter is applied.

% No artifact rejetion in applied
artifact_rejSTIM = 100000000000000000;  % basically it keeps everything.

%assuming perfect presentation rate the number of points between sounds
%should be as follows. This code is currently not operational.
presentationrate = 1;
pts = (1/presentationrate);
correct_errandtriggers  = 0;

% CORRECTING THE GAIN APPLIED BY THE PRE-AMP;
EEG.data = EEG.data;


%% (2) FILTER THE RAW RECORDING BEFORE EPOCHING %%%
if zerophaseshiftfilter ~=1
    [b,a] = butter(3, highpassSTIM/(rate/2),'high');
    EEGfilteredSTIM = filter(b,a,EEG.data'); % or use filtfilt
    % phase shift
    [b,a] = butter(3, lowpassSTIM/(rate/2),'low');
    EEGfilteredSTIM = filter(b,a,EEGfilteredSTIM); % or use filtfilt
end

if zerophaseshiftfilter == 1
    [b,a] = butter(3, highpassSTIM/(rate/2),'high');
    EEGfilteredSTIM = filtfilt(b,a,double(EEG.data')); % or use filtfilt  *zero
    
    [b,a] = butter(3, lowpassSTIM/(rate/2),'low');
    
    EEGfilteredSTIM = filtfilt(b,a,EEGfilteredSTIM); % or use filtfilt
end

if notch == 1
    wo = notchcut/(rate/2);
    bw = wo/35;
    [b,a] = iirnotch(wo,bw);
    EEGfilteredSTIM = filter(b,a,EEGfilteredSTIM);
end


%% (3) THORW OUT ERRAND TRIGGER  (find errant triggers or big jumps between trials)
if correct_errandtriggers == 1
    emcSTIM = 1;  %This code steps through all events independent of trigger number
    for x = 1:length(EEG.event);
        onsetTRIGGER(emcSTIM) = EEG.event(x).latency;  %if a match, store the onset latency
        emcSTIM = emcSTIM+1;
    end
    
    d0 = diff(onsetTRIGGER);
    [v earlyTrigger]= find(d0<(pts-(pts*.20)));  %find events that are either >=20% earlier than anticipated.
    [v lateTrigger]= find(d0>(pts+(pts*0.20)));  %find events that are either >=20% later than anticipated.
    eventstoremove = sort([earlyTrigger lateTrigger]);
    eventstoremove = eventstoremove+1;  % remove the sound that was presented at a big discrepancy from the previous sound.
else
    eventstoremove = 0;
end

%% 4A: Find all events that match your trigger value
emcSTIM = 1;  %This code steps through all events (trials and determines whether it matches the trigger you are looking for
removedSTIM = 0;
for x = 1:length(EEG.event);
    if strmatch(EEG.event(x).type, Trigger1);
        if ~isempty(intersect(x, eventstoremove))
            removed1 = removed1+1;
        else
            onsetTRIGGER(emcSTIM) = EEG.event(x).latency;  %if a match, store the onset latency
            emcSTIM = emcSTIM+1;
        end
    end
end


% plot(EEGfilteredSTIM)

%% 4B: Artifact rejection for trigger
% now go through each trial identified above and remove those with values
% greater than the reject criterion

rejectSTIM = 0; % a counter of how many trials have been rejected
for x = 1:emcSTIM-1;
    
    if (onsetTRIGGER(x))>length(EEGfilteredSTIM)
        break
    elseif (onsetTRIGGER(x)+post)>length(EEGfilteredSTIM)
        break
    elseif (onsetTRIGGER(x)-pre)<0
        break
    else
        
        epochSTIM(:,x) = EEGfilteredSTIM(onsetTRIGGER(x)-pre:onsetTRIGGER(x)+post);
        
        if max(abs(detrend(epochSTIM(:,x), 'constant')))>artifact_rejSTIM  % detrend first
            onsetTRIGGER(x) = 0;  % set onset to zero so that we can later exclude
            rejectSTIM = rejectSTIM+1; % a counter of how many have been rejected
        end
    end
end

onsetTRIGGER(onsetTRIGGER == 0)=[];  %remove rejected trials from available pool



%% 4C:  Detrend and average for trigger
clear epoch
for x = 1:length(onsetTRIGGER);
    if (onsetTRIGGER(x))>length(EEGfilteredSTIM)
        break
    elseif (onsetTRIGGER(x)+post)>length(EEGfilteredSTIM)
        break
    elseif (onsetTRIGGER(x)-pre)<0
        
    else
        epochSTIM(:,x) = detrend(EEGfilteredSTIM(onsetTRIGGER(x)-pre:onsetTRIGGER(x)+post), 'linear');
        
    end
end

plot(EEGfilteredSTIM(1:1000000));
%% Now cycle through each STIMULUS recording and find the point at which the stimulus begins
blanktrigger = 0;  %keeps track of how many triggers there are with no stimulus associated with it; i.e. where the stimulus recording doesn't appear to have a stimulus tied to that trigger. added to accomodate Austin Data.
for x = 1:size(epochSTIM,2);
    
    d = (abs(diff(epochSTIM(:,x))));  % find the point by point voltage change)
    if ~isempty((d>=threshold));%only keep the first point that satisfies this criteria as it is most likely to mark the onset of the stim.
        start_candidates = find(d>=threshold);
    end
    if ~isempty(start_candidates)
        startSTIM_index(x) = start_candidates(1);
    else
        blanktrigger = blanktrigger+1;
    end
end


y = 1;




for x = 1:length(startSTIM_index);
    
    
    if (onsetTRIGGER(x))+startSTIM_index(x)>=length(EEGfilteredSTIM) % if the start point exceeds lenghth of file
        
%         break
    elseif (onsetTRIGGER(x)+startSTIM_index(x)+post)>=length(EEGfilteredSTIM) % if stoppoint exceed length of file.
        
%         break
    else
                
        if pre - startSTIM_index(x) > (0.003*rate); % if the sound onset is too far (> 3 seconds) from the trigger exclude
         

        else
            newzero(y) = onsetTRIGGER(x)+startSTIM_index(x)-pre; %the "pre" component is necessary, don't remove. It accounts for the fact that the epoch contains prestim.
            
            epochSTIMcorrected(:,y) = (EEGfilteredSTIM(newzero(y)-pre:newzero(y)+post));
            y = y+1;
        end
    end
end


return



