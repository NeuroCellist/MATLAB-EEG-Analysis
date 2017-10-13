function [ TapTrialCode, TapTrialMag ] = EMGFFT_Classifier( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
TapTrialCode = NaN(1,size(data,2),size(data,3),6);
TapTrialMag = NaN(1,size(data,2),size(data,3),6);
freqs = [28:45 60:68];

for s = 1:size(data,2)
    for c = 1:size(data,3)
        for t = 1:size(data,4)
%             locs=STpeakfinder(SavedEMG_avgFFT(:,s,c,t));
            locs=STpeakfinder(data(:,s,c,t));
            
            if max(ismember(locs,freqs)) == 1
                tapFreq = ismember(locs,freqs);
                tapFreq = locs(tapFreq ==1);
                if length(tapFreq) > 1
                    tapFreq = max(tapFreq);
                end
                tapFreq
                if 36 < tapFreq && tapFreq < 45
                    TapTrialCode(1,s,c,t) = 1.25;
                    
                elseif tapFreq > 45
                    TapTrialCode(1,s,c,t) = 2;
                    
                elseif tapFreq < 36
                    TapTrialCode(1,s,c,t) = 1;
                end
                
                TapTrialMag(1,s,c,t) = real(abs(data(tapFreq,s,c,t)));
                
            else
                TapTrialCode(1,s,c,t) = NaN;
                TapTrialMag(1,s,c,t) = NaN;
            end
        end
    end
end

end

