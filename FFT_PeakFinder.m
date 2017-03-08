function [ peaks, vals ] = FFT_PeakFinder( Y, f,ThresholdPercentage )
%StimTrak Markers
%   expects a single vertical vector of StimTrak data.  Looks for the sound
%   onsets and marks each onset as a one and all other data points as 0.
%   outputs this vertical vectornewt = f(1:length(newy));

maxamp = max(Y);
if nargin <3
    Threshold = maxamp*.05;
    display('Using Default Threshold of 5% of max amplitude')
else
    Threshold = maxamp*ThresholdPercentage;
end
peaks=zeros(length(Y),1);
vals = NaN(30,1);
i=1;
p=1;
while i <= length(Y)
    if Y(i)<Threshold
        peaks(i) = NaN;
    elseif Y(i)>Threshold
        peaks(i) = 1;
        vals(p) = f(i);
        p=p+1;
    end
%     if peaks(i,1)== 1
%         i=i+(Fs*.245);
%     else
        i=i+1;
%     end
end
Mlength = length(peaks);

if Mlength<length(Y)
    diff = (length(Y) - Mlength);
    peaks = [peaks; zeros(diff,1)];
elseif Mlength>length(Y)
    peaks = peaks(1:length(Y));
end
vals(isnan(vals))=[];

end

