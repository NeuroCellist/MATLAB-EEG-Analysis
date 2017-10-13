function [ trimedEEGdata ] = EEGTrim64( filteredEEGdata, Fs )
%EEGTrim64 Automaticall trims the recording file to only include the
%listening portion of the trial (before the cue tone)
Threshold = (.5.* max(filteredEEGdata(:,33)));
StimTrak = filteredEEGdata(:,33);

[Markers] = StimTrak_Markers(StimTrak, Threshold, Fs);
durration = ((Fs*34)-1);
index = find(Markers);
stop = round((index(65)-100),-1);

trimedEEGdata = filteredEEGdata((stop-durration):stop,:);
end

