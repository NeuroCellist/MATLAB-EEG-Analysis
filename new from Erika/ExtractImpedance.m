
function [impedance] = ExtractImpedance(vhdrfile)

% filename = 'captain02_da-da.vhdr';
fid = fopen(vhdrfile);
i = 1;
while(~feof(fid));   % go line by line until the end of the file (feof) is reached.
    i = i+1;   % increment line number
    line{i} = fgetl(fid);  % read "line"
    if (strfind(line{i},('Impedance [kOhm]')));
                impedance_start=i;      % returns line number if a match is found
    end
    
end
fclose(fid);
% dlmread(filename,...)

y = 1;
for x = 1:34
    if x ~=2
    impedance{y} =  (line{impedance_start+x}(14:end));
    y = y+1;
    end
end