figure;
CHANNELS = [1:33];
name = 'captain03_click';
avgpath = 'C:\Users\SkoeLab\DATA\pol1\';
addpath([cd, '\programFiles\']);  % location of all of the subfunctions that will be called to process the data
figpath = 'C:\Users\SkoeLab\Data\Figures\';

default = 'Captain03_da';

prompt={'Enter file to plot'};
name= 'File to plot';
numlines=1;
defaultanswer={'Captain01_clk'};

answer=inputdlg(prompt,name,numlines,defaultanswer);


name = char(answer{1});
for x = 1:length(CHANNELS)
channel = CHANNELS(x);
subplot(6,6,x);
quickplot([avgpath,  name, '_pol1_', num2str(channel), '.avg'])
title(num2str(channel));
xlim([0 12]);
end


hgsave([figpath, name, '_timedomain.fig']);

% quickFFT(file, pad, start, stop, plotFFT, plotstart, plotstop, electrode, saveFFT, FFTname)