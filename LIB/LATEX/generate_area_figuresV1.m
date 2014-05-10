function [output_arg] = generate_area_figuresV1(AREA,LIST_STATIONS,FFF,F)
%rjf; this file is OBSOLETE, broken into 3 separate files
% \begin{figure}[!h] \begin{center}
%   % Requires \usepackage{graphicx}
%   \includegraphics[width=4in]{MODEL_IMG/NP205.jpg}
%   \caption[Subdomain in the vicinity of NP205]{Subdomain in the vicinity of NP205} \label{fig:subdom_NP205}\end{center}
% \end{figure}
% 
% \textbf{MIKE SHE simulation:}
% 
% \begin{figure}[!h] \begin{center}
%   % Requires \usepackage{graphicx}
%   \includegraphics[width=6.5in]{MODEL_COMPUTED/FIGURES_MSHE_OPS/NP205.png}
%   \caption[Comparison computed and observed at NP205]{Comparison computed and observed NP205}\label{fig:NP205}
%   \end{center}
% \end{figure}

FFF_TXT = [FFF '.txt'];
FFF_TEX = [FFF '.tex']

fidTEX = fopen(FFF_TEX,'w');

RAREA = strrep(AREA, '_', '\_');

ROW1 =[' \begin{figure}[!h] \begin{center}'];
ROW2 =[' % Requires \usepackage{graphicx}'];
ROW3 =[' \includegraphics[width=4in]{MODEL_IMG/' char(AREA) '.jpg}'];
ROW4 =[' \caption[Subdomain in the vicinity of ' char(RAREA) ']{Subdomain in the vicinity of ' char(RAREA) '} \label{fig:' char(F.LABEL)  'subdom_NP205}\end{center}'];
ROW5 =[' \end{figure}'];

fprintf(fidTEX,'%s\n',ROW1);
fprintf(fidTEX,'%s\n',ROW2);
fprintf(fidTEX,'%s\n',ROW3);
fprintf(fidTEX,'%s\n',ROW4);
fprintf(fidTEX,'%s\n',ROW5);

cp = 1; %clear page setting
for FIGURE = LIST_STATIONS
RFIGURE = strrep(FIGURE, '_', '\_');    
FILE_PE = [F.FIGURES_DIR '\exceedance\' char(FIGURE) '.png'];
FILE_TS = [F.FIGURES_DIR '\timeseries\' char(FIGURE) '.png'];
FILE_ACC = [F.FIGURES_DIR '\flow\' char(FIGURE) '-ACCUMULATED' '.png'];
    
    if exist(FILE_TS,'file')
        %PRINT TIMESERIES

        ROW1 =[' \begin{figure}[!h] \begin{center}'];
        ROW2 =[' % Requires \usepackage{graphicx}'];
        ROW3 =[' \includegraphics[width=6.5in]{MATLAB/ANALYZE_SIM/' char(F.SIM_DIR) 'FIGURES/A3_TS_' char(FIGURE) '.png}'];
        ROW4 =[' \caption[Comparison computed and observed at ' char(RFIGURE) ']{Comparison computed and observed ' char(RFIGURE) '}\label{fig:' char(F.LABEL)  char(FIGURE) '-TS}'];
        ROW5 =[' \end{center}'];
        ROW6 =[' \end{figure}'];
        
        fprintf(fidTEX,'\n\n');
        fprintf(fidTEX,'%s\n',ROW1);
        fprintf(fidTEX,'%s\n',ROW2);
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
        fprintf(fidTEX,'%s\n',ROW5);
        fprintf(fidTEX,'%s\n',ROW6);
        cp = cp + 1;
    end
    
    %PRINT PE
    if exist(FILE_PE,'file')
        ROW1 =[' \begin{figure}[!h] \begin{center}'];
        ROW2 =[' % Requires \usepackage{graphicx}'];
        ROW3 =[' \includegraphics[width=6.5in]{MATLAB/ANALYZE_SIM/' char(F.SIM_DIR) 'FIGURES/A4_PE_' char(FIGURE) '.png}'];
        ROW4 =[' \caption[Probability exceedance at ' char(RFIGURE) ']{Probability exceedance at ' char(RFIGURE) '}\label{fig:' char(F.LABEL)  char(FIGURE) '-PE}'];
        ROW5 =[' \end{center}'];
        ROW6 =[' \end{figure}'];
        
        fprintf(fidTEX,'\n\n');
        fprintf(fidTEX,'%s\n',ROW1);
        fprintf(fidTEX,'%s\n',ROW2);
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
        fprintf(fidTEX,'%s\n',ROW5);
        fprintf(fidTEX,'%s\n',ROW6);
                cp = cp + 1;

    end
    %PRINT ACCUMULATED
    if exist(FILE_ACC,'file')
        ROW1 =[' \begin{figure}[!h] \begin{center}'];
        ROW2 =[' % Requires \usepackage{graphicx}'];
        ROW3 =[' \includegraphics[width=6.5in]{MATLAB/ANALYZE_SIM/' char(F.SIM_DIR) 'FIGURES/A3_TS_' char(FIGURE) '-ACCUMULATED' '.png}'];
        ROW4 =[' \caption[Accumulated discharges at ' char(RFIGURE) ']{Accumulated discharges at ' char(RFIGURE) '}\label{fig:' char(F.LABEL)  char(FIGURE) '-ACC}'];
        ROW5 =[' \end{center}'];
        ROW6 =[' \end{figure}'];
        
        fprintf(fidTEX,'\n\n');
        fprintf(fidTEX,'%s\n',ROW1);
        fprintf(fidTEX,'%s\n',ROW2);
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
        fprintf(fidTEX,'%s\n',ROW5);
        fprintf(fidTEX,'%s\n',ROW6);
                cp = cp + 1;

    end
    if cp > 10, fprintf(fidTEX,'%s\n','\clearpage'); cp = 0; end;
end

fclose(fidTEX);

end
