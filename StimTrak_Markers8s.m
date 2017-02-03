function [ Markers ] = StimTrak_Markers8s( StimTrak, Threshold, Fs )
%StimTrak Markers
%   expects a single vertical vector of StimTrak data.  Looks for the sound
%   onsets and marks each onset as a one and all other data points as 0.
%   outputs this vertical vector
% Version 16s finds the first onset and then skips 15.95sec of data in
% order to chop data into every 4 cycles of the rhythym sequence

if nargin <2

   Fs = 5000;
   Threshold = 700;
   display('Using Default Fs = 5000 and Threshold = 700')
elseif nargin<3
    Fs = 5000;
    display('Using Default Fs = 5000')
end

StimTrak(:,2) = StimTrak(:,1);
STlength = length(StimTrak(:,2));


i=1;
while i <= STlength
    if StimTrak(i,2)<Threshold
        Markers(i,1) = 0;
    elseif StimTrak(i,2)>Threshold
        Markers(i,1) = 1;
    end
    if Markers(i,1)== 1
        i=i+(Fs*7.99);
    else 
        i=i+1;
    end
end
Mlength = length(Markers);

if Mlength<STlength
    diff = (STlength - Mlength);
    Markers = [Markers; zeros(diff,1)];
elseif Mlength>STlength
    Markers = Markers(1:STlength);
end
end

