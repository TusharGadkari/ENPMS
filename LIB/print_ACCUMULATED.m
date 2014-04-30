function [ output_args ] = print_ACCUMULATED(INI,P)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

FN = [INI.ANALYSIS_DIR_TAG '/DS_ACCUMULATED.txt']
FID = fopen(FN,'w');

%print header
fprintf(FID,'Cumulative discharges at the end of the simulation period\n');

%pring column header
fprintf(FID,'%20s','Station');
n = length(P.SRC);
for i = 1:n
    fprintf(FID,'\t%s', char(P.SRC(i)));
end
fprintf(FID,'\n');

[ni nj] = size(P.ACCUMULATED);
for i = 1:ni
    fprintf(FID,'%20s', char(P.NAME(i)));
    for j = 1:nj
        fprintf(FID,'\t%8.2f', P.ACCUMULATED(i,j));
    end
    fprintf(FID,'\n');
end

fclose(FID);

end

%printf(fidTXT,'%10s %20s %8d %8.2f %8.2f 
% %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),NDATA(i,:));