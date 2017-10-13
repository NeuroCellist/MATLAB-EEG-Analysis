function [ EMGdata ] = EMGTrim64( filteredEMGdata, Fs )
%EEGTrim64 Automaticall trims the recording file to only include the
%listening portion of the trial (before the cue tone)
StimTrak = filteredEMGdata(:,1);
Threshold = (.5.* max(StimTrak));

[Markers] = StimTrak_Markers(StimTrak, Threshold);
durration = ((Fs*4)-1);
index = find(Markers);
start = round((index(66)-100),-1);

trimedEMGdata = filteredEMGdata(start:(start+durration),:);
EMGdata = trimedEMGdata;
% Removing bias, performing full wave rectification, and hanning taper
window = kaiser(Fs*4);
for c = 2:size(trimedEMGdata,2)
    ChanAvg = mean(trimedEMGdata(:,c));
    EMGdata(:,c) = (EMGdata(:,c)-ChanAvg);
    %EMGdata(:,c) = abs(EMGdata(:,c));
    EMGdata(:,c) = (window.*EMGdata(:,c));
end
end

