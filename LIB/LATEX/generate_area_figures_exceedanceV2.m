function [output_args] = generate_area_figures_exceedanceV2(AREA,LIST_STATIONS,FFF,F,SIM,fidTEX)
%rjf; ---figuresV1 works as a standalone, creates entire latex file
%rjf; from generate_area_figuresV1, just do exceedance

fprintf(fidTEX,'%s\n','\clearpage');
row2 =['\subsubsection{Exceedance}'];
fprintf(fidTEX,'%s\n\n',row2);

        fprintf ('...Exceedance for area %s\n',char(AREA));

page3=0;
for FIGURE = LIST_STATIONS
	RFIGURE = strrep(FIGURE, '_', '\_');    
	FILE_TS = [F.FIGURES_DIR '/exceedance/' char(FIGURE) '.png'];
	FILE_RELATIVE_TS = [F.FIGURES_RELATIVE_DIR '/exceedance/' char(FIGURE) '.png'];
   
    if exist(FILE_TS,'file')
        %PRINT exceedance
		%%%for st = 1:length(SIM.SELECTED_STATIONS.list.stat)
    	%%%	if strcmp(SIM.SELECTED_STATIONS.list.stat(st), FIGURE)
        %%%		page = SIM.SELECTED_STATIONS.list.page{st};
        %%%    end
        %%%end
     
        page3=page3+1;
        %fprintf ('page3 %d\n',page3);
        
        if page3 > 3
            fprintf(fidTEX,'%s\n','\clearpage');
            page3 = 1;
        end
        ROW1 =[' \begin{figure}[!h] \begin{center}'];
        ROW3 =[' \includegraphics[width=6.5in]{' FILE_RELATIVE_TS '}'];
        ROW4 =[' \caption[Probability exceedance at ' char(RFIGURE) ']{Probability exceedance at ' char(RFIGURE) '}'];
        ROW4a =['\label{fig:' char(FIGURE) '-EXC}'];
        ROW5 =[' \end{center}'];
        ROW6 =[' \end{figure}'];
        
        fprintf(fidTEX,'\n\n');
        fprintf(fidTEX,'%s\n',ROW1);
        fprintf(fidTEX,'%s\n',ROW3);
        %fprintf(fidTEX,'%s\n',ROW4);
        fprintf(fidTEX,'%s\n',ROW4a);
        fprintf(fidTEX,'%s\n',ROW5);
        fprintf(fidTEX,'%s\n',ROW6);
        
    end
end
end
