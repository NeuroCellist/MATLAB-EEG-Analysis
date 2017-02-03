function [ ArtifactedGrpEpochData, PercArtifact ] =Group_AR( EpochData, ArtifactThreshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
trials =size(EpochData,3);
channels = size(EpochData,2);

for k = 1:channels
    if k ~= 32
        for i = 1:trials
            if max(abs(EpochData(:,k,i)))>ArtifactThreshold
                EpochData(:,k,i) = NaN;
            end
        end
    end
end
ArtifactedGrpEpochData = EpochData;

for q = 1:channels
    %assumes that first timepoint is representative of entire trial
nanTrials(q)=sum(isnan(ArtifactedGrpEpochData(1,q,:)));
end
TotalNan = sum(nanTrials);
PercArtifact=(TotalNan/(trials*channels))*100;

%ArtifactedEpochData = mean(ArtifactedEpochData,3);
%ArtifactedGrpEpochData = nanmean(ArtifactedEpochData,3);
end

