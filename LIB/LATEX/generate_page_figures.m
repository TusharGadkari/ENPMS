function [] = generate_page_figures(AREA,LIST_STATIONS,MAP_ALL_DATA,INI,fidTEX)
%021812 - changed to INI, and do TS, box, exceed plots on one page
%rjf; V1 works as a standalone, creates entire latex file
%rjf; from generate_area_figuresV1, just do timeseries

% % RAREA = strrep(AREA, '_', '\_');

% % ROW1 =[' \begin{figure}[!ht] \begin{center}'];
% % %TODO: HARDWIRE
% % %subdomainplot = ['E:/APPS/postproc/latex/figs-station_groups/' char(RAREA) '.png']; %keb 2011-10-12 changed to relative path
% % subdomainplot = ['/maps/' char(RAREA) '.png'];
% % if exist([F.FIGURES_DIR subdomainplot],'file')
% %     ROW3 = [' \includegraphics[width=6in]{' F.FIGURES_RELATIVE_DIR subdomainplot '}']; %changed from 4in to 6in 2012/1/4 keb
% % else
% %     ROW3 =[' \includegraphics[width=4in]{../figures/blank.jpg}'];
% % end
% % ROW4 =[' \caption[Subdomain in the vicinity of ' char(RAREA) ']{Subdomain in the vicinity of ' char(RAREA) '}'];
% % ROW4a =['\label{fig:' char(RAREA) '-TS}'];
% % ROW4b =[' \end{center}'];
% % ROW5 =[' \end{figure}'];
% %
% % fprintf(fidTEX,'%s\n',ROW1);
% % fprintf(fidTEX,'%s\n',ROW3);
% % fprintf(fidTEX,'%s\n',ROW4);
% % fprintf(fidTEX,'%s\n',ROW4a);
% % fprintf(fidTEX,'%s\n',ROW4b);
% % fprintf(fidTEX,'%s\n',ROW5);

% row2 =['\subsubsection{Timeseries}'];
% fprintf(fidTEX,'%s\n\n',row2);
% fprintf (fidTEX,'Timeseries for area %s\n',char(AREA));

fprintf ('...Timeseries for area %s\n',char(AREA));
page3 = 0;
done =0;	%check if the page
%has no more figures (if there is only 1 or2)


for FIGURE = LIST_STATIONS
    try
        STATION = MAP_ALL_DATA(char(FIGURE));  %get a tmp structure, modify values
        strcmp(STATION.DFSTYPE,'Discharge');
        fprintf ('...latex processing figure: %s \n', char(FIGURE));
    catch
        fprintf ('...Errors in generating latex map key not existing \n')
        continue;
    end
    if strcmp(STATION.DFSTYPE,'Discharge')
        RFIGURE = strrep(FIGURE, '_', '\_');
        FILE_TS = [INI.FIGURES_DIR '/timeseries/' char(FIGURE) '.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/timeseries/' char(FIGURE) '.png'];
        
        if exist(FILE_TS,'file')
            plotfileA = FILE_RELATIVE_TS;
        else
            plotfileA = '../figures/blank.png';
        end
        
        FILE_TS = [INI.FIGURES_DIR '/timeseries/' char(FIGURE) '-acc.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/timeseries/' char(FIGURE) '-acc.png'];
        
        if exist(FILE_TS,'file')
            plotfileB = FILE_RELATIVE_TS;
        else
            plotfileB = '../figures/blank.png';
        end
        
        FILE_TS = [INI.FIGURES_DIR '/exceedance/' char(FIGURE) '.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/exceedance/' char(FIGURE) '.png'];
        
        if exist(FILE_TS,'file')
            plotfileC = FILE_RELATIVE_TS;
        else
            plotfileC = '../figures/blank.png';
        end
        
    else
        RFIGURE = strrep(FIGURE, '_', '\_');
        FILE_TS = [INI.FIGURES_DIR '/timeseries/' char(FIGURE) '.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/timeseries/' char(FIGURE) '.png'];
        
        if exist(FILE_TS,'file')
            plotfileA = FILE_RELATIVE_TS;
        else
            plotfileA = '../figures/blank.png';
        end
        
        FILE_TS = [INI.FIGURES_DIR '/exceedance/' char(FIGURE) '.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/exceedance/' char(FIGURE) '.png'];
        
        if exist(FILE_TS,'file')
            plotfileB = FILE_RELATIVE_TS;
        else
            plotfileB = '../figures/blank.png';
        end
        
        FILE_TS = [INI.FIGURES_DIR '/boxplot/' char(FIGURE) '.png'];
        FILE_RELATIVE_TS = [INI.FIGURES_RELATIVE_DIR '/boxplot/' char(FIGURE) '.png'];
        
        if exist(FILE_TS,'file')
            plotfileC = FILE_RELATIVE_TS;
        else
            plotfileC = '../figures/blank.png';
        end
        
    end
    
    ROW1 =['\begin{figure}[!H] \begin{center}'];
    fprintf(fidTEX,'%s\n',ROW1);
    rfig = strrep(RFIGURE, '\_', '');
    ROW9=['\currentpdfbookmark{' char(RFIGURE) '}{' char(rfig) 'name}'];
    fprintf(fidTEX,'%s\n',ROW9);
    
    if ~strcmp(plotfileA,'../figures/blank.png')
        ROW2 =['\subfigure{'];
        fprintf(fidTEX,'%s\n',ROW2);
        ROW3 =[' \includegraphics[width=8.0in]{' plotfileA '}'];
        ROW4 =['}'];
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
    end
    
    if ~strcmp(plotfileB,'../figures/blank.png')
        ROW2 =['\subfigure{'];
        fprintf(fidTEX,'%s\n',ROW2);
        ROW3 =[' \includegraphics[width=8.0in]{' plotfileB '}'];
        ROW4 =['}'];
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
    end
    
    if ~strcmp(plotfileC,'../figures/blank.png')
        ROW2 =['\subfigure{'];
        fprintf(fidTEX,'%s\n',ROW2);
        ROW3 =[' \includegraphics[width=8.0in]{' plotfileC '}'];
        ROW4 =['}'];
        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
    end
    
    ROW5 =[' \caption[Station ' char(RFIGURE) ']{Station ' char(RFIGURE) '}'];
    ROW6 =['\label{fig:' char(FIGURE) 'all}'];
    fprintf(fidTEX,'%s\n',ROW5);
    
    fprintf(fidTEX,'%s\n',ROW6);
    ROW7 =[' \end{center}'];
    ROW8 =[' \end{figure}'];
    fprintf(fidTEX,'%s\n',ROW7);
    fprintf(fidTEX,'%s\n',ROW8);
    
    fprintf(fidTEX,'%s\n','\clearpage');
end
% % if (done == 1)
% % 	ROW5 =[' \end{center}'];
% %     ROW6 =[' \end{figure}'];
% %     fprintf(fidTEX,'%s\n',ROW5);
% %     fprintf(fidTEX,'%s\n',ROW6);
fprintf(fidTEX,'%s\n','\clearpage');
% % end
end
