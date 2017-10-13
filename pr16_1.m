% pr16_1.p
%cwt analysis using Convolution and Correlation with a mexican hat wavelet
%(MHW)

clear;
msg = ('Plz. wait and MAXAMIZE COLOR PLOTS!')
N=2048;   % # OF POINTS
maxlag=N/2; %used to zoom in on the correct part of C

C= zeros(128,2*N-1); %initialize convolution array
CC = zeros(128,2*maxlag+1); %initialize correlation array

figure(1)
%input signal with m from 0 - 1
for n = 1:N
    m=(n-1)/(N-1);
    tg(n)=m;
    g(n) = sin(40*pi*m)*exp(-100*pi*(m-0.2)^2)+(sin(40*pi*m)+22*cos(160*pi*m))*exp(-50*pi*(m-0.5)^2)+2*sin(160*pi*m)*exp(-100*pi*(m-0.8)^2);
end;

%Mexican Hat; a symetrical real function
w=1/8;        % NOTE: standard deviation parameter w =1/8
index = 1;


Voices = 16;
Octaves = 8;

for k = 0:(Voices*Octaves);  %use 8 octaves and 16 voices per octave (8*16=128)
    s=2^(-k/Voices);      % 16 voices per octave
    
    for n=1:N
        %creates MHW from -.5 to .5
        m=(n-1)/(N-1)-1/2;    %time parameter
        if (k==0)
            tmh(n)=m;  %time axis for plot
        end;
        mh(n)=2*pi*(1/sqrt(s*w))*(1-2*pi*(m/(s*w))^2)*exp(-pi*(m/(s*w))^2);
    end;
    
    if (k==0)     %plot wavelet example
        
        subplot(2,1,1), plot(tmh,mh,'k'); axis('tight')
        ylabel('Amplitude');
        title('Mexican Hat')
    end;
    
    % save inverted scales
    scale(index)=1/s;
    
    %convolution of the wavelet and the signal
    C(index,:)=conv(g,mh);
    % Correlate the wavelet and signal
    CC(index,:)=xcorr(g,mh,maxlag);
    
    index=index+1;
end;

%Plot the Results

subplot(2,1,2), plot(tg,g,'r'); axis('tight')
xlabel('Time');
ylabel('Amplitude');
title('Original Signal Containing 20Hz and 80Hz components (red)');

figure(2)
pcolor(C(:,maxlag:5:2*N-maxlag).^2);
xlabel('Time');
ylabel('1/Scale#');
ttl=['Convolution based scalogram NOTE: Maxinma of the cwt are around the 1/scale #(70) and (38). Ratio = ' num2str(scale(70)/scale(38))];
title(ttl);

figure(3)
pcolor(CC(:,1:5:2*maxlag+1).^2);
xlabel('Time');
ylabel('1/Scale#');
ttl=['Correlation based scalogram NOTE: Maxinma of the cwt are around the scale #(70) and (38). Ratio = ' num2str(scale(70)/scale(38))];
title(ttl);

% close figure(1) figure(2)