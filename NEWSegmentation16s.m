function [ Start_Points Stop_Points ] = NEWSegmentation16s( filteredEEGdata, Fs, PreStim, PostStim)
%Segmentation for Cortical Time-Domain Frequecy Analysis (chops segments of 16sec durration (4times of the 4sec rhythym sequence)
%   Detailed explanation goes here

if nargin <2
   PreStim = .01;
   PostStim = 15.99;
   Fs = 5000;
   
   display('Using Default Fs, PreStim and PostStim Timings')
elseif nargin<3
   PreStim = .01;
   PostStim = 15.99;
      display('Using Default PreStim and PostStim Timings')
end

%path = path_to_matFile;



[index value]=find(filteredEEGdata(:,35)==1);

dataLength=length(filteredEEGdata);

Start_Points = (index - (PreStim*Fs));
Stop_Points = (index + ((PostStim*Fs)-1));

[postindex vals1] = find(Stop_Points > dataLength);
Start_Points(postindex) = [];
Stop_Points(postindex) = [];

end

