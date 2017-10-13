function [ MPMagData ] = EEGFFT_Classifier( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
MPMagData={};
GrpAbs2HzMag = NaN(4,16);
GrpRel2HzMag = NaN(4,16);
GrpAbs1HzMag = NaN(4,16);
GrpRel1HzMag = NaN(4,16);
range1hz = 28:36;
range2hz = 60:68;
t=1/32:1/32:6;
for s = 2:17
    for c = 2:5
        %absolute power magnitudes for 1 & 2 Hz
        currdata = data{c,s}(1:192,:);
        avgCurrdata = nanmean(currdata,2);
        GrpAbs2HzMag(c-1,s-1) = max(avgCurrdata(range2hz));
        GrpAbs1HzMag(c-1,s-1) = max(avgCurrdata(range1hz));
        
        % Relative delta power mag/max of .25-3Hz
        for chan = 1:32
            chanmax = max(currdata(8:96,chan));
            NormedCurrData(:,chan) = (currdata(:,chan)./chanmax);
            clear chanmax
        end
        avgNormedCurrData = nanmean(NormedCurrData,2);
        GrpRel2HzMag(c-1,s-1) = max(avgNormedCurrData(range2hz));
        GrpRel1HzMag(c-1,s-1) = max(avgNormedCurrData(range1hz));
        
    end
end
MPMagData.GrpAbs2HzMag = GrpAbs2HzMag;
MPMagData.GrpRel2HzMag = GrpRel2HzMag;
MPMagData.GrpAbs1HzMag = GrpAbs1HzMag;
MPMagData.GrpRel1HzMag = GrpRel1HzMag;
end

