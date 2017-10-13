
clear all
close all
addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/MATLAB Analysis code'));
clc
%% (1) Define File to be used
tic
subID = {'F1702'};
% subID = {'S1702';'S1703'; 'S1704'; 'S1705'; 'S1706'; 'S1707'; 'S1708'; 'S1709'; 'S1710'; 'S1711'; 'S1712'; 'S1713'; 'S1714'; 'S1715'; 'S1716'; 'S1717'};
Condition = {'Comp1'; 'Comp2'; 'ISO'; 'Rand'};
%  Condition = {'ISO'};
TapKey=nan(8,4,3);
%%
for s = 1:size(subID,1)
    for c = 1:size(Condition,1)
        %%
        tapNames = cell(8,1);
        
        for i = 1:8
            tapNames{i} = [subID{s} '_' Condition{c} '_' num2str(i) '_taps.mat'];
        end
        tappingPath = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/In-EEG-Tapping/' subID{s}];
        clear i
        clc
        addpath(tappingPath);
        addpath(genpath('/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Tapping/matlab code/CircStat2012a'));
        audioFs=44100;
        TappingData = zeros( length(tapNames),1764000);
        trials = length(tapNames);
        
        for u = 1:length(tapNames)
            load(tapNames{u})
            TappingData(u,:) = tappingdata(2,1:1764000);
            clear tappingdata
        end
        TappingData=TappingData(:,(size(TappingData,2)-(4*audioFs))+1:end);
        timepoints = max(sum(TappingData(:,:),2));
        
        MetronomeTimes=[0.5 1 1.5 2 2.5 3 3.5 4.0];
        TapTimes=nan(length(tapNames),max(sum(TappingData(:,:)')));
        for u = 1:length(tapNames)
            numTaps=sum(TappingData(u,:));
            TapTimes(u,1:numTaps)=round((find(TappingData(u,:))./audioFs),4);
        end
        
        RePhase = nan(trials, timepoints);
        
        MetroTapDiff = nan(trials, timepoints);
        for t = 1:trials
            numTaps=sum(TappingData(t,:));
            for tp = 1:timepoints
                if isreal(TappingData(t,tp))==1
                    tap = TapTimes(t,tp);
                    
                    [co, index] = min(abs(MetronomeTimes-tap));
                    relMet=MetronomeTimes(index);
                    MetroTapDiff(t,tp) = tap - relMet;
                    phi = ((2 * pi) * (MetroTapDiff(t,tp) / .5)); % Fix?
                    
                    RePhase(t,tp) = phi;
                else
                end
                clear tap co index relMet
            end
        end
        clear t
        
        for t = 1:trials
            subplot(2,4,t)
            TrialPhase = RePhase(t,:);
            TrialPhase = TrialPhase(find(~isnan(TrialPhase)));
            circ_plot(TrialPhase', 'hist', '', [0:20:360], 1, 1);
            title(['Trial #' num2str(t)])
            TapKey(t,c,1) = circ_mean(TrialPhase');
            TapKey(t,c,2) = (circ_mean(TrialPhase')*(180/pi));
            if TapKey(t,c,2) > 90 || TapKey(t,c,2) <-90
                TapKey(t,c,3) = -1;
            else
                TapKey(t,c,3) = 1;
            end
            clear TrialPhase
        end
        
        path2 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/figs'];
        cd(path2);
        set(gcf, 'Position', get(0, 'Screensize'));
        savefig([subID{s} '_' Condition{c} '_InEEG_TappingPhase']);
        close all
        %%
        colors = {'b','g','o','r','y','p','g','b'};
        Metronome = zeros(1,176400);
        Metronome(1)=1;
        Metronome((MetronomeTimes.*audioFs))=1;
        figure
        for i=1:size(TappingData,1)
            hold on
            plot(TappingData(i,:),colors{i})
        end
        plot(Metronome,'k','linewidth', 2)
        
        hold off
        set(gcf, 'Position', get(0, 'Screensize'));
        savefig([subID{s} '_' Condition{c} '_InEEG_Tapping']);
        close all
    end
    path1 = ['/Users/charleswasserman/Dropbox (MDL)/rhyEeg/Data/' subID{s} '/mat files'];
    cd(path1);
    save([subID{s} '_inEEG_TappingKey'],'TapKey');
end