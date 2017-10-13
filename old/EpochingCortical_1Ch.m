function [ CorticalEpochData ] = EpochingCortical_1Ch( filteredEEGdata, Pre, Post, Fs )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin <4

   Fs = 5000;
   
   display('Using Default Fs = 5000')
end



Trials=length(Pre);
for c = 1:2
for i = 1:Trials
StimEpoch(:,c,i) = filteredEEGdata(Pre(i):Post(i),c);
 
end
end
%timeaxis = linspace(-10, (Fs*15.99), length(StimEpoch(:,1)));

%plot(timeaxis, StimEpoch)
%soundsc(StimEpoch(:,1),Fs)

%plot(timeaxis, StimEpoch(:,24,500))
CorticalEpochData = StimEpoch;
end

