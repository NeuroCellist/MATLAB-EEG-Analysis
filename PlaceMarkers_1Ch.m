function [ filteredEEGdata ] = PlaceMarkers_1Ch( filteredEEGdata, Threshold, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin <2
   Threshold = 700;
   display('Using Default Threshold = 700')
end

StimTrak = filteredEEGdata(:,2);

[Markers] = StimTrak_Markers(StimTrak, Threshold);
filteredEEGdata(:,3) = Markers;

[CortMarkers] = StimTrak_Markers16s(StimTrak, Threshold, Fs);
filteredEEGdata(:,4) = CortMarkers;

[Cort8Markers] = StimTrak_Markers8s(StimTrak, Threshold, Fs);
filteredEEGdata(:,5) = Cort8Markers;

[Cort4Markers] = StimTrak_Markers4s(StimTrak, Threshold, Fs);
filteredEEGdata(:,6) = Cort4Markers;
end