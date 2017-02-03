function [ z,Jetmap, relamp2hz ] = RelDelta2HzHeadMap( FFTdata )
%RelDelta2HzHeadMap
% Function computed relative delta power (1-3Hz)in each of the subject (3rd dim of
% input matrix) and then averages that Relative power over the group.  This
% average 2Hz Relative Power from each electrode is then used to generate
% head maps.

%Removes the StimTrak channel
FFTData = FFTdata(:,1:32,:);

load ChanCords32v2
chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak'};
chan = size(FFTData,2);
sub = size(FFTData,3);
amp2hz= nan(chan,1,sub);
totDelta= nan(chan,1,sub);

for k = 1:sub
    for i = 1:chan
        amp2hz(i,1,k)=FFTData(64,i,k);
        totDelta(i,1,k)= nansum(FFTData(32:96,i,k));
    end
end
amp2hzAVG = nanmean(amp2hz,3);
totDeltaAVG = nanmean(totDelta,3);
relamp2hz = amp2hzAVG./totDeltaAVG;

[z,Jetmap]=eegheadplot(relamp2hz,chCord32,[],[],'cubic',[]);
figure;
imshow(z);
colormap(figure(gcf),Jetmap)
colorbar
title(['2Hz Relative amplitude to Delta Band (1-3Hz) n = ' num2str(sub)])
end

