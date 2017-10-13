function [dt,Units] = getDurationandUnits(Ts)
% This function returns the sampling interval and a format string
% for plotting the wavelet coherence in time and frequency.
% The Units string is only for plotting.

tsformat = Ts.Format;
% Use first character of format string to determine correct
% duration object method.

if strcmpi(tsformat,'hh:mm:ss') || strcmpi(tsformat,'dd:hh:mm:ss') ...
        || strcmpi(tsformat,'mm:ss') || strcmpi(tsformat,'hh:mm')
    % Convert to Hours,Minutes,Seconds
    [h,m,s] = hms(Ts);
    % Find the biggest unit
    timeidx = find([h m s],1,'first');
    switch timeidx
        case 1
            if h>=24
                tsformat = 'd';
            else
                tsformat = 'h';
            end
        case 2
            tsformat = 'm';
        case 3
            tsformat = 's';
        
    end
else
    tsformat = tsformat(1);
    
end

% Using the same time units as engunits. Units in engunits are
% not localized.
% time_units = {'secs','mins','hrs','days','years'};
switch tsformat
    case 's'
        dt = seconds(Ts);
        Units = 'secs';
    case 'm'
        dt = minutes(Ts);
        Units = 'mins';
    case 'h'
        dt = hours(Ts);
        Units = 'hrs';
    case 'd'
        dt = days(Ts);
        Units = 'days';
    case 'y'
        dt = years(Ts);
        Units = 'years';
end