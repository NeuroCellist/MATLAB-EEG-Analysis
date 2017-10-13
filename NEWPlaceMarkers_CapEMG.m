function [ filteredEEGdata ] = NEWPlaceMarkers_CapEMG( filteredEEGdata, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Threshold = (.5.* max(filteredEEGdata(:,33)));
StimTrak = filteredEEGdata(:,33);

[Markers] = StimTrak_Markers(StimTrak, Threshold, Fs);
filteredEEGdata(:,38) = Markers;

[CortMarkers] = StimTrak_Markers16s(StimTrak, Threshold, Fs);
filteredEEGdata(:,39) = CortMarkers;

[Cort8Markers] = StimTrak_Markers8s(StimTrak, Threshold, Fs);
filteredEEGdata(:,40) = Cort8Markers;

[Cort4Markers] = StimTrak_Markers4s(StimTrak, Threshold, Fs);
filteredEEGdata(:,41) = Cort4Markers;
end