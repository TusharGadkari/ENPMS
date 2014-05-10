function [output_args] = generate_area_figures_timeseriesV2(AREA,LIST_STATIONS,FFF,F,SIM,fidTEX)
%rjf; V1 works as a standalone, creates entire latex file
%rjf; from generate_area_figuresV1, just do timeseries




RAREA = strrep(AREA, '_', '\_');

ROW1 =[' \begin{figure}[!ht] \begin{center}'];
%TODO: HARDWIRE
%subdomainplot = ['E:/APPS/postproc/latex/figs-station_groups/' char(RAREA) '.png']; %keb 2011-10-12 changed to relative path
subdomainplot = ['/maps/' char(RAREA) '.png'];
if exist([F.FIGURES_DIR subdomainplot],'file')
    ROW3 = [' \includegraphics[width=6in]{' F.FIGURES_RELATIVE_DIR subdomainplot '}']; %changed from 4in to 6in 2012/1/4 keb
else
    ROW3 =[' \includegraphics[width=4in]{../figures/blank.jpg}'];
end
ROW4 =[' \caption[Subdomain in the vicinity of ' char(RAREA) ']{Subdomain in the vicinity of ' char(RAREA) '}'];
ROW4a =['\label{fig:' char(RAREA) '-TS}'];
ROW4b =[' \end{center}'];
ROW5 =[' \end{figure}'];

fprintf(fidTEX,'%s\n',ROW1);
fprintf(fidTEX,'%s\n',ROW3);
fprintf(fidTEX,'%s\n',ROW4);
fprintf(fidTEX,'%s\n',ROW4a);
fprintf(fidTEX,'%s\n',ROW4b);
fprintf(fidTEX,'%s\n',ROW5);

%fprintf(fidTEX,'%s\n','\clearpage');
row2 =['\subsubsection{Timeseries}'];
fprintf(fidTEX,'%s\n\n',row2);
fprintf (fidTEX,'Timeseries for area %s\n',char(AREA));

fprintf ('...Timeseries for area %s\n',char(AREA));
page3 = 0;
done =0;	%check if the page
            %has no more figures (if there is only 1 or2)
for FIGURE = LIST_STATIONS
	RFIGURE = strrep(FIGURE, '_', '\_');    
	FILE_TS = [F.FIGURES_DIR '/timeseries/' char(FIGURE) '.png'];
	FILE_RELATIVE_TS = [F.FIGURES_RELATIVE_DIR '/timeseries/' char(FIGURE) '.png'];

    if exist(FILE_TS,'file')
        plotfile = FILE_RELATIVE_TS;
    else
        plotfile = '../figures/blank.png';
    end
    page3=page3+1;
       
        
    if page3 > 3
            ROW5 =[' \end{center}'];
            ROW6 =[' \end{figure}'];
         fprintf(fidTEX,'%s\n',ROW5);
        fprintf(fidTEX,'%s\n',ROW6);
           fprintf(fidTEX,'%s\n','\clearpage');
            page3 = 1;
            done =1;
    end
    if page3 == 1
            ROW1 =[' \begin{figure}[!H] \begin{center}'];
        fprintf(fidTEX,'%s\n',ROW1);
    end
        ROW3 =[' \includegraphics[width=6.5in]{' plotfile '}'];
        ROW4 =[' \caption[Timeseries at ' char(RFIGURE) ']{}'];
        ROW4a =['\label{fig:' char(FIGURE) '-TS}'];
        %ROW7 =[' \vskip -12pt'];

        fprintf(fidTEX,'%s\n',ROW3);
        fprintf(fidTEX,'%s\n',ROW4);
        fprintf(fidTEX,'%s\n',ROW4a);
        %fprintf(fidTEX,'%s\n',ROW7);

    
end
if (done == 1)
	ROW5 =[' \end{center}'];
    ROW6 =[' \end{figure}'];
    fprintf(fidTEX,'%s\n',ROW5);
    fprintf(fidTEX,'%s\n',ROW6);
    fprintf(fidTEX,'%s\n','\clearpage');
end
end
