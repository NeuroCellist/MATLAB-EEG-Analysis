function [z,map,ChanPos]=eegplot(mag,ch,unorm,ch_disp,method,color_res)
% [z,map]=eegplot(mag,ch,unorm,ch_disp,method,color_res)
% 
% Plots Topographic map from scattered data points on a head.
% Outputs
% z       -Interpolated Indexed image (397x392 matrix)
% map     -Colormap for z (slightly modified version of the 'jet' 
%          map
%
% Inputs
% mag     - Scattered original data values. Should be a row vector
%           (n x 1). The first value corresponds to the first channel selected,
%           and the last value to the last channel selected.
%           
% ch      -Channel coordinates from the image. To select channels interactively, 
%          set ch=[] ;. You can use the GINPUT function to get the cordinates of  
%          the channel from the 'brain2.jpg' image and use it in ch ie (3 channels): 
%          brain=imread('brain2.jpg');
%          imshow(brain)
%          [y x]=ginput(3);
%          ch=[x y]; 
%          
% unorm    -Optional. If left empty, will normalize the data for better display. 
%           If true (norm==1), will use the data as it is.
%          
% ch_disp -Optional.Displays the channels that you have selected (black).
% 
% method  -Type of interpolation to be used in GRIDADATA to interpolate the
%          pixel values. Options for interpolation methods are:
%          
%          'linear' Triangle-based linear interpolation 
% 
%          'cubic' Triangle-based cubic interpolation (default)
% 
%          'nearest' Nearest neighbor interpolation 
% 
%          'v4' MATLAB 4 griddata method (very slow- not recommended)
% 
% color_res - Set the color resolution in the colorbar. Maximum resolution
%                    is 256 (also default if left empty).
%                    
% ***Example 1
%
%
% load example_data
% load eegplotdat
% mag=exp(0.009.*[1:67]');
% eegplot(mag,ch,[],[],[],[]);
% figure;imshow(brain);
% 
% 
% ***Example 2 - Interactive
% 
% close all
% mag=rand(5,1);
% eegplot(mag,[],[],1,'nearest',[]);
load eegplotdat

if(isempty(ch)),
    disp('***Select Channel Values From Image-- Hit Return When Done***')
    figure;imshow(brain);
    nch=length(mag);
    str=['Select ',num2str(nch),' Electrodes from the 10/20 Electrode ',...
        'Position System (Maurer, 1999)'];
    title(str);
    [chy,chx]=ginput;
    close
    if(length(chx)~=length(mag))
        error('Number of channels selected does not match size of data input!!');
        return
    end
else
    chy=ch(:,1);
    chx=ch(:,2);
    if(length(chx)~=length(mag))
        error('Number of channels selected does not match size of data input!!');
        return
    end
end
disp('*** Wait...***')
chx=floor(chx);
chy=floor(chy);


if(isempty(color_res)),
    N=256;
elseif(color_res >255),
    N=256;
    disp('***Colorbar Resolution set to 255 values***');
else
    N=color_res;
end

I=zeros(397,392);


%Normalize Data 
if(isempty(unorm))
    if (min(mag(:)) <0),
        mag = (mag - min(mag(:)) ); 
    end
    mag= mag./(max(mag(:)));
    
end

mag=[mag ; zeros(1089,1)];

%Set Image values equal to input values
for i=1:length(chx),
    I(chx(i),chy(i))=mag(i);
end

cx=chx;cy=chy;
chx=[chx ; mx];
chy=[chy ; my];

x=[1:392]; 
y=[1:397];
[xx,yy] = meshgrid(x,y);

if(isempty(method)),
    z = griddata(chy,chx,mag,xx,yy,'cubic');
else
    z = griddata(chy,chx,mag,xx,yy,method);
end

%Save memory
clear chy chx mag xx yy x y brain str nch


%Adjust colorbar to include black background
ma=max(z(:));
mi=min(z(:));
step=(ma-mi)/(N-2);
black= mi + (-1)*step;
z(isnan(z))=black;

%Set Electrode sites equal to black
%if(~isempty(ch_disp)),
    for i=1:length(cx),
        z(cx(i),cy(i))=black;
        z(cx(i)+1,cy(i))=black;
        z(cx(i)-1,cy(i))=black;
        z(cx(i)-1,cy(i)-1)=black;
        z(cx(i),cy(i)-1)=black;
        z(cx(i)+1,cy(i)-1)=black;
        z(cx(i)-1,cy(i)+1)=black;
        z(cx(i),cy(i)+1)=black;
        z(cx(i)+1,cy(i)+1)=black;
    end
%end

%Display
figure;imshow(z);
map=colormap(jet(N));
map(1,:)=[0 0 0];
colormap(map)
colorbar

