function [b, a, x] = nozFilter(binSz, std)

% binSz is units of frequency
% std   is also in units of frequency


x = -3.5*std:binSz:3.5*std;
a = 1;
b = -normpdf2(x, 0, std);


%then use coefficient outputs to run filtfilt on fft data
