ndarCorticalEpochData=[];
for i = 1:size(CorticalEpochData,3)
    if i ==1
        ndarCorticalEpochData = CorticalEpochData(:,:,i);
    end
    ndarCorticalEpochData = cat(1,ndarCorticalEpochData, CorticalEpochData(:,:,i));
end