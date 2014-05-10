function [output_arg] = generate_latex_areasV1(AREA,LIST_STATIONS,MAP_STATION_STAT,FPE,FTS,FFF, SIM,F)

FTS_TXT = [FTS '.txt'];
FTS_TEX = [FTS '.tex'];
FPE_TXT = [FPE '.txt'];
FPE_TEX = [FPE '.tex'];



%rjf; split up the lates files
generate_area_figures_timeseriesV1(AREA, LIST_STATIONS,FFF,F,SIM);

%rjf; TODO
%generate_area_figures_exceedanceV1(AREA, LIST_STATIONS,FFF,F,SIM);
%generate_area_figures_structuresV1(AREA, LIST_STATIONS,FFF,F,SIM);


%rjf; the next section is to do the statistics table
% needs to be put in a separate file
%DELETED see V1
return




i = 1;                 
for L = LIST_STATIONS
     try
        M = MAP_STATION_STAT(char(L));
        sz = length(M.PE(:,1));
        C(i:i+sz-1) = M.MODELRUN(1:sz);
        N(i:i+sz-1) = L;
        NDATA(i:i+sz-1,1:9) = M.STAT;
        PE(i:i+sz-1,1:9) = M.PE(1:sz,1:9);
        i = i+sz;
     catch
         disp(L);
         %rjf; ERROR this is a hack to avoid PE=NaN and undefined NDATA
         NDATA(i:i+sz-1,1:9) = 0;
         PE(i:i+sz-1,1:9) = 0;
     end
end

for i = 1:length(SIM.MODEL_ALL_RUNS)
    MAP_KEY(i) = SIM.MODEL_ALL_RUNS(i);
    MAP_VALUE(i) = SIM.MODEL_RUN_DESC(i);
end
MAP_DESCR = containers.Map(MAP_KEY, MAP_VALUE);

fidTXT = fopen(FTS_TXT,'w');
fidTEX = fopen(FTS_TEX,'w');
print_table_stat_headerV0(fidTEX,AREA,F);
STEND = '\\';
N_TMP = '';

% MAP_LATEX_NAMES = get_latex_names;

for i = 1:length(C)
    if NDATA(i,1)
        D = MAP_DESCR(char(C(i)));
        if ~strcmp(N(i),N_TMP)
            RN = strrep(N(i), '_', '\_');
            NTEX=['\textbf{' char(RN) '}'];
            N_TMP = N(i);
            if i > 1
                STEND =  '\\\\ \pagebreak[3] ';
            end
        else
            NTEX = '';
            STEND =  '\\\nopagebreak';
        end
        fprintf(F.FILEIDTXT,'STAT: %10s %20s %8d %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),NDATA(i,:));
        fprintf(fidTXT,'%10s %20s %8d %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),NDATA(i,:));
 %%%       fprintf(1,'%10s %20s %8d %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),NDATA(i,:));
        fprintf(fidTEX,'%s\n',STEND);
        fprintf(fidTEX,'%10s & %20s & %8d & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f',NTEX,char(D),NDATA(i,:));
    end
end
fprintf(fidTEX,'%s\n','\\')';
print_table_stat_endV0(fidTEX,AREA);
%PRINT TABLE FOOTER
fclose(fidTXT);
fclose(fidTEX);

fidTXT = fopen(FPE_TXT,'w');
fidTEXT = fopen(FPE_TEX,'w');
print_table_PE_headerV0(fidTEX,AREA,F);
STEND = '\\';
N_TMP = '';
for i = 1:length(C)
    if ~isnan(PE(i,:))
        D = MAP_DESCR(char(C(i)));
        if ~strcmp(N(i),N_TMP)
            RN = strrep(N(i), '_', '\_');
            NTEX=['\textbf{' char(RN) '}'];
            N_TMP = N(i);
            if i > 1
                STEND =  '\\\\ \pagebreak[3] '; %STEND =  '\\\\'
            end
        else
            NTEX = '';
            STEND =  '\\\nopagebreak'; %STEND =  '\\'
        end
        D = MAP_DESCR(char(C(i)));
        fprintf(F.FILEIDTXT,'PE:   %10s %20s %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),PE(i,:));
        fprintf(fidTXT,'%10s %20s %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),PE(i,:));
   %%%     fprintf(1,'%10s %20s %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',char(N(i)),char(D),PE(i,:));
        fprintf(fidTEX,'%s\n',STEND);
        fprintf(fidTEX,'%10s & %20s & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f',NTEX,char(D),PE(i,:));
    end
end
fprintf(fidTEX,'%s\n','\\');
print_table_PE_endV0(fidTEX,AREA);
%fprintf(fidTEX,'%s\n','\clearpage');
fclose(fidTXT);
fclose(fidTEX);


end

