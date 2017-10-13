function [ Start_Points Stop_Points ] = NEWSegmentation4s_1Ch( filteredEEGdata,Threshold, Fs, PreStim, PostStim)
%Segmentation for Cortical Time-Domain Frequecy Analysis (chops segments of 16sec durration (4times of the 4sec rhythym sequence)
%   Detailed explanation goes here

if nargin <3
    PreStim = .05;
    PostStim = 4;
    Fs = 5000;
    
    display('Using Default Fs, PreStim and PostStim Timings')
elseif nargin<4
    PreStim = .05;
    PostStim = 4;
    display('Using Default PreStim and PostStim Timings')
end
% this loads in data matrix called filteredEEGdata.  Column 3 = 1, where
% stimulus is thought to turn on. There is jitter in this estimation.
sec2pt = 1/Fs;

[index v] = find(filteredEEGdata(:,6) == 1);
clear d
for x = 1:length(index)
    for y = 1:2
        if index(x)+(PostStim/sec2pt)<=length(filteredEEGdata)
            d(:,x,y) = filteredEEGdata(index(x)-(PreStim/sec2pt):index(x)+(PostStim/sec2pt),y);
        end
    end
end

%figure;
%plot(d(:,:, 32));



% step 2: find where the stimulus actually begins.
indexNEW = [];
for x = 1:size(d,2)
    x;
    %stimmatrix = abs(d(:,x,2));   %take the absolute value
    stimmatrix = d(:,x,2);   %take the absolute value
    [index2]  =  RhyEEGlocalmax(stimmatrix);  % find the local max
    [index3] = find(stimmatrix(index2)>Threshold);  %take the first local max point that meets that criterion, and then set this to zero.
    indexNEW(x) = (index(x)-(0.020/sec2pt))+index2(index3(1))-1; % reset the start of the stimulus by taking the first point that meets the criterion
    
end

for i = 1:length(indexNEW);
    if (indexNEW(i)+(PostStim/sec2pt))<=length(filteredEEGdata);
        Start_Points(i) = indexNEW(i);
        Stop_Points(i) = (indexNEW(i)+(PostStim/sec2pt)-1);
    end
end

end

