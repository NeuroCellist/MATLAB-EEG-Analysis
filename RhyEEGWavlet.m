function [] = RhyEEGWavlet(x, Fs)
x = resample(x,1,100);
newFs=Fs*(1/100);
[a freqs times] =  cwt_RhyEEG(x,seconds(1/newFs),'amor','VoicesPerOctave', 12);   %USE ME

time=seconds(times);


hold on
cwt_RhyEEG(x,seconds(1/newFs),'amor','VoicesPerOctave',12);   %USE ME

hold off
end