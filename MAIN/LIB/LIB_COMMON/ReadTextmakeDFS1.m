function [TS] = ReadTextmakeDFS0(TS)

%{
Read text file with format date value
%}
fid = fopen(TS.textFile);

dataASCII = textscan(fid, '%s %f');
sd = datenum(dataASCII{:,1});
dataASCII{:,2} =dataASCII{:,2} * 25.4;
TS.ValueVector =  TSmerge(dataASCII{:,2}, TS.dlength, datenum(TS.startdate), datenum(TS.enddate), sd(1), sd(end));

%I=strfind(TS.ValueASCII,'null')
I = isnan(TS.ValueVector);
TS.ValueVector(I) = -1.0e-035;

if (exist(TS.DFS0file,'file') == 2)
        fprintf('... DFS0 file exists, replacing: %s\n', char(TS.DFS0file));
        delete (char(TS.DFS0file));
else
        fprintf('... Creating DFS0file %s\n', char(TS.DFS0file));
end
OutputDFS0(TS)



end