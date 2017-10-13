clear all
CHANNELS = [1:33];
load plotinfo



prompt={'Enter file to plot'};
name= 'File to plot';
numlines=1;
defaultanswer={'Captain03_da'};

answer=inputdlg(prompt,name,numlines,defaultanswer);

name = char(answer{1});


avgpath = 'C:\Users\SkoeLab\DATA\add\';
figpath = 'C:\Users\SkoeLab\DATA\Figures';
vhdrpath = 'C:\Users\SkoeLab\Data\';
addpath([cd, '\programFiles\']);  % location of all of the subfunctions that will be called to process the data

impedance = ExtractImpedance([vhdrpath, name, '.vhdr']);

figure;  % Timedomain
for x = 1:length(CHANNELS)
    channel = CHANNELS(x);
    axes ('position',[posx(x) posy(x) .1 .1]);
    f = openavg([avgpath,  name, '_add', num2str(channel), '.avg']);
    xaxis = linspace(f.xmin, f.xmax, f.pnts);
    
    imp = num2str(impedance{x});
    if imp>5
        plot(xaxis, f.signal, 'r');
    else
        plot(xaxis, f.signal, 'k');
    end

    title([Electrode{x} '--' impedance{x}], 'Interpreter', 'None');
    xlim([-40 170]);
    if x~=1
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
        xlabel('')
        ylabel('')
    end
    
end
hgsave([figpath, name, '_timedomain.fig']);

figure %frequency domain
for x = 1:length(CHANNELS)
    
    channel = CHANNELS(x);
    axes ('position',[posx(x) posy(x) .1 .1]);
    [FFTdata]= quickFFTscaled([avgpath,  name, '_add', num2str(channel), '.avg'], 1, 50, 150, 0, 0, 1200, 'all', 0', '');
    FFTmatrix(:,x) = FFTdata.Brain;
    imp = num2str(impedance{x});
    if imp>5
        plot(FFTdata.xaxis, FFTdata.Brain, 'r');
    else
        plot(FFTdata.xaxis, FFTdata.Brain, 'k');
    end
    hold on;
    title([Electrode{x} '--' impedance{x}], 'Interpreter', 'None');
    xlim([0 1200])
    if x ==1
        xlabel('Frequency (Hz)')
        ylabel('Microvolts')
        
    end
    if x~=1
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
        xlabel('')
        ylabel('')
    end
    
end

hgsave([figpath, name, '_freqdomain.fig']);

electrode2avg = [1:1:33];
Avg = mean(FFTmatrix(:,electrode2avg),2);

figure %Avg Frequency
plot(FFTdata.xaxis, Avg, 'k');
xlim([0 1200])


