function [ ArtifactedEpochData, PercArtifact ] = EpochArtifactRej_nar( EpochData, ArtifactThreshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
trials =size(EpochData,3);
channels = size(EpochData,2);

for k = 1:channels
    if k ~= channels
        for i = 1:trials
            if max(abs(EpochData(:,k,i)))>ArtifactThreshold
                EpochData(:,k,i) = NaN;
            end
        end
    end
end
ArtifactedEpochData = EpochData;

for q = 1:(channels - 1)
    %assumes that first timepoint is representative of entire trial
nanTrials(q)=sum(isnan(ArtifactedEpochData(1,q,:)));
end
TotalNan = sum(nanTrials);
PercArtifact=(TotalNan/(trials*(channels-1)))*100;

%ArtifactedEpochData = mean(ArtifactedEpochData,3);
%ArtifactedEpochData = nanmean(ArtifactedEpochData,3);
end

