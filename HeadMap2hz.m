function  HeadMap2hz( FFTData )
%Creates HeadMaps of 2Hz Activity 
FFTData = cat(2,FFTData(:,1:25),FFTData(:,27:31));
mag2hz= nan(30,1);
load ChanCords

for i = 1:30
mag2hz(i,1)=FFTData(64,i);
end
eegplot(mag2hz,chCord,[],[],'cubic',[]);
end

