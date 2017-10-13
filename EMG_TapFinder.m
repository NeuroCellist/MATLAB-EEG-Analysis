function [ Taps, Locs, t ] = EMG_TapFinder( Y,Fs )
%StimTrak Markers
%   expects a single vertical vector of EMG data.  Looks for the sound
%   onsets and marks each onset as a one and all other data points as 0.
%   outputs this vertical vectornewt = f(1:length(newy));
trials = nan(size(Y,2),1);
peaks = nan(500,size(Y,2));
for c = 1 : size(Y,2)
    if c == 1
        found = STpeakfinder(Y(:,c));
        peaks(1:size(found,1),c) = found;
        trials(c,1) = length(peaks(:,c));
    else
        found = peakfinder(Y(:,c));
        peaks(1:size(found,1),c) = found;
        trials(c,1) = length(peaks(:,c));
    end
end
cleandata = nan(max(trials), size(Y,2));
cleandata(1,:) = peaks(1,:);
t= 0:(1/Fs):4; t=t(1:end-1);
Taps = zeros(8000,5);
clear c
for c = 1 : size(Y,2)
    tapcount = 2; % skip 1 because it's been assigned
    LastTap = cleandata(tapcount - 1,c);
    for point = 2:trials(c)
        CurrTap = peaks(point,c);
        TapDiff = CurrTap - LastTap;
        if TapDiff >= .2*Fs % In Seconds
            cleandata(tapcount,c) = CurrTap;
            LastTap = CurrTap;
            tapcount = tapcount + 1;
        else
        end
    end    
end
for c = 1:size(Y,2)
    index = cleandata(:,c);
    indexsize = sum(~isnan(index));
    index=index(1:indexsize);
    Taps(index,c) = 1;
end
LocsPrime = cleandata/Fs;
maxTaps = max(sum(~isnan(LocsPrime(:,:))));
Locs = LocsPrime(1:maxTaps,:);
end

