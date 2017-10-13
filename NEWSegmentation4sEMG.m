function [ Start_Points Stop_Points ] = NEWSegmentation4sEMG( filteredEEGdata, Fs, PreStim, PostStim)
%Segmentation for Cortical Time-Domain Frequecy Analysis (chops segments of 16sec durration (4times of the 4sec rhythym sequence)
%   Detailed explanation goes here

if nargin <2
    PreStim = .05;
    PostStim = 4;
    Fs = 25000;
    
    display('Using Default Fs, PreStim and PostStim Timings')
elseif nargin<3
    PreStim = .05;
    PostStim = 4;
    display('Using Default PreStim and PostStim Timings')
end
% this loads in data matrix called filteredEEGdata.  Column 3 = 1, where
% stimulus is thought to turn on. There is jitter in this estimation.
sec2pt = 1/Fs;
PreTime=(PreStim*Fs);
PostTime=(PostStim*Fs);
epochdur = ((PreStim+PostStim)*Fs);

[index v] = find(filteredEEGdata(:,41) == 1);
clear d
d=zeros(epochdur+5,length(index),37);

for x = 1:length(index)
    for y = 1:37
        if (index(x)+PostTime)<=length(filteredEEGdata)

            dSize=size(filteredEEGdata(index(x)-(PreTime):index(x)+(PostTime),y),1);
            d(1:dSize,x,y) = filteredEEGdata(index(x)-(PreTime):index(x)+(PostTime),y);
        end
    end
end

%figure;
%plot(d(:,:, 32));

d=d(1:epochdur,:,:);

% step 2: find where the stimulus actually begins.
indexNEW = NaN(size(d,2),1);
Threshold = (.25.* max(filteredEEGdata(:,33)));
clear x
for x = 1:size(d,2)-1
    x;
    %stimmatrix = abs(d(:,x,2));   %take the absolute value
    stimmatrix = d(:,x,33);   %take the absolute value
    [index2]  =  RhyEEGlocalmax(stimmatrix);  % find the local max
    [index3] = find(stimmatrix(index2)>Threshold);  %take the first local max point that meets that criterion, and then set this to zero.
    indexNEW(x) = (index(x)-(0.020*Fs))+(index2(index3(1))-1); % reset the start of the stimulus by taking the first point that meets the criterion
    
end

for i = 1:length(indexNEW);
    if (indexNEW(i)+(PostStim/sec2pt))<=length(filteredEEGdata);
        Start_Points(i) = indexNEW(i);
        Stop_Points(i) = (indexNEW(i)+(PostTime));
    end
end

end

