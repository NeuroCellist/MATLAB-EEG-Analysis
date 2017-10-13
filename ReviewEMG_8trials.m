% Plots EMG data for each trial (each row is a trial, and each column is a
% different EMG channel)
subplot(8,4,1)
plot(filteredEEGdata(:,34),'DisplayName','filteredEEGdata(:,end)','YDataSource','filteredEEGdata(:,end)');figure(gcf)
title('Left Hand EMG')
ylabel('Trial 1')
subplot(8,4,2)
plot(filteredEEGdata(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
title('Right Hand EMG')
subplot(8,4,3)
plot(filteredEEGdata(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
title('Left Foot EMG')
subplot(8,4,4)
plot(filteredEEGdata(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
title('Right Foot EMG')
subplot(8,4,5)
plot(filteredEEGdata2(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 2')
subplot(8,4,6)
plot(filteredEEGdata2(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,7)
plot(filteredEEGdata2(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,8)
plot(filteredEEGdata2(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,9)
plot(filteredEEGdata3(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 3')
subplot(8,4,10)
plot(filteredEEGdata3(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,11)
plot(filteredEEGdata3(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,12)
plot(filteredEEGdata3(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,13)
plot(filteredEEGdata4(:,34),'DisplayName','filteredEEGdata(:,end)','YDataSource','filteredEEGdata(:,end)');figure(gcf)
ylabel('Trial 4')
subplot(8,4,14)
plot(filteredEEGdata4(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,15)
plot(filteredEEGdata4(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,16)
plot(filteredEEGdata4(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,17)
plot(filteredEEGdata5(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 5')
subplot(8,4,18)
plot(filteredEEGdata5(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,19)
plot(filteredEEGdata5(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,20)
plot(filteredEEGdata5(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,21)
plot(filteredEEGdata6(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 6')
subplot(8,4,22)
plot(filteredEEGdata6(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,23)
plot(filteredEEGdata6(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,24)
plot(filteredEEGdata6(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,25)
plot(filteredEEGdata6(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 7')
subplot(8,4,26)
plot(filteredEEGdata6(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,27)
plot(filteredEEGdata6(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,28)
plot(filteredEEGdata6(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,29)
plot(filteredEEGdata6(:,34),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
ylabel('Trial 8')
subplot(8,4,30)
plot(filteredEEGdata6(:,35),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,31)
plot(filteredEEGdata6(:,36),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)
subplot(8,4,32)
plot(filteredEEGdata6(:,37),'DisplayName','filteredEEGdata2(:,end)','YDataSource','filteredEEGdata2(:,end)');figure(gcf)