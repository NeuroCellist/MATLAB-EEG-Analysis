function [ filteredEEGdata ] = NEWPlaceMarkers_Cap( filteredEEGdata, Threshold, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin <2
   Threshold = 700;
   display('Using Default Threshold = 700')
end

StimTrak = filteredEEGdata(:,33);

[Markers] = StimTrak_Markers(StimTrak, Threshold);
filteredEEGdata(:,34) = Markers;

[CortMarkers] = StimTrak_Markers16s(StimTrak, Threshold, Fs);
filteredEEGdata(:,35) = CortMarkers;

[Cort8Markers] = StimTrak_Markers8s(StimTrak, Threshold, Fs);
filteredEEGdata(:,36) = Cort8Markers;

[Cort4Markers] = StimTrak_Markers4s(StimTrak, Threshold, Fs);
filteredEEGdata(:,37) = Cort4Markers;
end