chnames = {'Fp1' 'Fz' 'F3' 'F7' 'FT9' 'FC5' 'FC1' 'C3' 'T7' 'TP9' 'CP5' 'CP1' 'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'TP10' 'CP6' 'CP2' 'Cz' 'C4' 'T8' 'FT10' 'FC6' 'FC2' 'F4' 'F8' 'Fp2' 'StimTrak' 'Left Hand EMG' 'Right Hand EMG' 'Left Foot EMG' 'Right Foot EMG'};

%% Artifact Data
[ ArtifactedEpochData, PercArtifact ] = EpochArtifactRej_maxsubmin( CorticalEpochData, 100 );
%% Select specific electrodes
% ArtifactedEpochData=ArtifactedEpochData(:,[1 10],:); %Just Fp1 and TP9
% ArtifactedEpochData=ArtifactedEpochData(:,[20 21 26],:); %Just T8, P8, and TP10
% ArtifactedEpochData=ArtifactedEpochData(:,21,:); %Just TP10
% ArtifactedEpochData=ArtifactedEpochData(:,26,:); %Just T8
% ArtifactedEpochData=ArtifactedEpochData(:,24,:); %Just Cz
StimData=ArtifactedEpochData(:,33,:); %Just Stim

%% Avg over electrodes
data3(:,:)=nanmean(ArtifactedEpochData,2);
%% resample and refilter data w/ more constrained low pass
% lowpass = 6; %in Hz
% highpass = 1.5; %in Hz
% 
% [b,a] = butter(3, lowpass/(125/2),'low');
% [b1,a1] = butter(3, highpass/(125/2),'high');

for i = 1:size(ArtifactedEpochData,3)
    data2(:,i) = resample(ArtifactedEpochData(:,i),1,200);
%     data(:,i) = filter(b,a,data2(:,i)); % or use filtfilt
%     data(:,i) = filter(b1,a1,data(:,i)); % or use filtfilt
    
end
data=data2;
clear data2 data3
%% Seperate data back into each of the 8 trials of 6 epochs each.
d1= reshape(data(:,3:6),[],1);
d2= reshape(data(:,9:12),[],1);
d3= reshape(data(:,15:18),[],1);
d4= reshape(data(:,21:24),[],1);
d5= reshape(data(:,27:30),[],1);
d6= reshape(data(:,33:36),[],1);
if size(data,2) > 36
    d7= reshape(data(:,39:42),[],1);
    d8= reshape(data(:,45:48),[],1);
end
%% OR
d1= reshape(data(:,1:6),[],1);
d2= reshape(data(:,7:12),[],1);
d3= reshape(data(:,13:18),[],1);
d4= reshape(data(:,19:24),[],1);
d5= reshape(data(:,25:30),[],1);
d6= reshape(data(:,31:36),[],1);
if size(data,2) > 36
    d7= reshape(data(:,37:42),[],1);
    d8= reshape(data(:,43:48),[],1);
end

%%
CzData= cat(2, d1,d2,d3,d4,d5,d6,d7,d8);
CzData = nanmean(CzData,2);
%%
StimData= cat(2, d1,d2,d3,d4,d5,d6,d7,d8);
StimData = nanmean(StimData,2);
%%
% avgd1= nanmean(data(:,3:6),2);
% avgd2= nanmean(data(:,[3:6 9:12]),2);
% avgd3= nanmean(data(:,[3:6 9:12 15:18]),2);
% avgd4= nanmean(data(:,[3:6 9:12 15:18 21:24]),2);
% avgd5= nanmean(data(:,[3:6 9:12 15:18 21:24 27:30]),2);
% avgd6= nanmean(data(:,[3:6 9:12 15:18 21:24 27:30 33:36]),2);
% avgd7= nanmean(data(:,[3:6 9:12 15:18 21:24 27:30 33:36 39:42]),2);
% avgd8= nanmean(data(:,[3:6 9:12 15:18 21:24 27:30 33:36 39:42 45:48]),2);

%%
f = 0:1/125:24;
f= f(1:3000);
% Plot Series of 6 trials
L=tukeywin(size(d1,1));

figure(1)
subplot(2,4,1)
% plot(f,(d1.*L));
plot(f,(d1));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,2)
% plot(f,(d2.*L));
plot(f,(d2));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,3)
% plot(f,(d3.*L));
plot(f,(d3));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,4)
% plot(f,(d4.*L));
plot(f,(d4));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,5)
% plot(f,(d5.*L));
plot(f,(d5));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,6)
% plot(f,(d6.*L));
plot(f,(d6));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,7)
% plot(f,(d7.*L));
plot(f,(d7));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
subplot(2,4,8)
% plot(f,(d8.*L));
plot(f,(d8));

xlabel('Time(sec)')
xlim([0 16])
xticks(0:16)
grid on
%% Plot trial average
if size(data,2) > 36
    alltrials = cat(2,d1,d2,d3,d4,d5,d6,d7,d8);
else
    alltrials = cat(2,d1,d2,d3,d4,d5,d6);
end
avgalltrials = nanmean(alltrials,2);
f = 0:1/125:24;
f= f(1:3000);
L=tukeywin(size(avgalltrials,1));
windavg = (avgalltrials.*L);
% plot(f,windavg)
plot(f,avgalltrials)
xlabel('Time(sec)')
xlim([0 24])
xticks(0:24)
% ylim([-10 10])
grid on

%% Plot long trial