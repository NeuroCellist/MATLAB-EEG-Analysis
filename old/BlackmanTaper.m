function [ TaperArtifactedEpochData ] = BlackmanTaper( ArtifactedEpochData )
% BLACKMANTAPER multiplies each epoch with a blackmann window of the same
% durration to reduce spectral leakage of the fft

trials =size(ArtifactedEpochData,3);
channels = size(ArtifactedEpochData,2);
durration = size(ArtifactedEpochData,1);
taper = blackman(durration);
TaperArtifactedEpochData = zeros(durration,channels,trials);
for k = 1:channels
    if k ~= channels
        for i = 1:trials
           TaperArtifactedEpochData(:,k,i) = (ArtifactedEpochData(:,k,i).*taper);
        end
    else
        TaperArtifactedEpochData(:,k,i) = ArtifactedEpochData(:,k,i);
    end
end


end

