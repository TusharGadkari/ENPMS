function [] = A3a_boxmat(INI)
%{

Compute annual, monthly from .MATLAB file
and boxplot, files to DATAPOST/output/figures/boxplot
Creates a .TeX file in the latex folder: boxplot.tex,
a subsection of boxplots.
Makes an ascii file of the station, coords, statistics for GIS

%}
    %add search path
% address = java.net.InetAddress.getLocalHost();
% if (regexp(char(address), 'ENP-PC'))
%     %pathdir     = 'C:/MODELS/DHIMODEL/';
%     matdir =  'C:/MODELS/MATLAB/';
%     path(path,[matdir 'mbin']);
%     path(path,[matdir 'scripts/common']);
%     scriptdir   = [matdir 'postproc/'];
%     path(path,[scriptdir 'util']);
%     datadir = [scriptdir 'data/'];
%     %workdir = [matdir 'NPS_SCRIPTS/rjf/scripts/annplot/'];
%     %path(path,[matdir 'NPS_SCRIPTS/rjf/scripts/common']);
%     outputdir = 'C:/MODELS/REPORTS/DATAPOST/output/';
%     %path(path,workdir);
% else
%     pathdir     = 'E:/APPS/MODELS/DHIMODEL/';
%     matdir =  'E:/APPS/MODELS/MATLAB/';
%     workdir = 'E:/APPS/working/rjf/scripts/evap/';
%     path(path,workdir);
%     path(path,[matdir 'HOBS/common']);
%     path(path, 'E:/APPS/DHI_2011/MATLAB/mbin');
%     
%     pathdir     = 'F:/MODELS/';
%     matdir =  [pathdir 'MATLAB/'];
%     analysisdir = [pathdir 'REPORTS/DATAPOST/'];
%     outputdir = [pathdir 'REPORTS/DATAPOST/output/'];
%     workdir = analysisdir
%     indir =  [workdir 'input/'];
%     outdir = [workdir 'output/'];
%     ResultDirHome = [pathdir 'Result/'];
% %     ResultDirHome = ['F:/MODELS/Result/'];
%     scriptdir   = [matdir 'postproc/'];
%     datadir = [scriptdir 'data/'];
% %     path(path, 'F:/APPS/DHI_2011/MATLAB/mbin');
%     path(path,[matdir 'scripts/common/']);
%     path(path,scriptdir);
%     path(path,[scriptdir,'util/']);
%     path(path,[scriptdir,'latex/']);
% 
% end

% set default values

% % run = 'Z1Z1cZ1d';
% % TS.startdate = [1987,1,1,0,0,0];  %start  on this date
% % TS.enddate = [2005,12,31,0,0,0];
run = INI.ANALYSIS_TAG;
TS.startdate = INI.ANALYZE_DATE_I;  %start  on this date
TS.enddate = INI.ANALYZE_DATE_F;
% % INI.SELECTED_STATION_LIST = [datadir '/selected_station_list-ALLculled.txt'];

rundir = [INI.ANALYSIS_DIR '/' run '/'];
figdir = [rundir 'figures/boxplot/'];
if ~exist(figdir,'file'),      mkdir(figdir), end  %Create a figures dir in output
    %LaTeX output
% % latexfile = [rundir 'latex/boxplot.tex'];
% % fidTEX = openlatex(latexfile);
% % page3=1;
    % GIS file
printgis = [rundir 'statgis.asc'];
fidgis = fopen(char(printgis),'w');
    % The matlab file and selected station list
DATAMATLABFILE = [rundir run '_TIMESERIES_DATA.MATLAB'];
DATA = load('-mat', DATAMATLABFILE);

% INI.SELECTED_STATIONS = get_station_list(INI.SELECTED_STATION_LIST);
SELECTED_STATION_LIST = INI.SELECTED_STATION_LIST;
% SELECTED_STATION_LIST = [INI.ANALYSIS_DIR '/selected_station_list.txt'];

infile = SELECTED_STATION_LIST;
if (exist(char(SELECTED_STATION_LIST))~=2)
    infile = INI.SELECTED_STATION_LIST; 
end

INI.SELECTED_STATIONS = get_station_list(infile);

STATIONS_LIST = INI.SELECTED_STATIONS.list.stat;

%STATIONS_LIST = {'NP205'};

% The no. of runs from matlab file plus observed 
%if isKey(DATA.MAP_ALL_DATA,char(L(1))
L = DATA.MAP_ALL_DATA.keys;
numTS = length(DATA.MAP_ALL_DATA(char(L(1))).RUN) + 1;

% %   %Header line for GIS
fprintf (fidgis,'Station,X,Y');
for indx = 1:numTS - 1
% %     %TODO: RMSE1,RMSE2, etc
    hline=[',RMSE' num2str(indx) ',NS' num2str(indx) ',BIAS' num2str(indx)];
    %fprintf (fidgis,',RMSE,NS,BIAS');
    fprintf (fidgis,hline);
end
fprintf (fidgis,'\n');

    % Compute total number of days for vector,  year and month
TS = nummthyr(TS);
       %start and length of timeseries in matlab file
mapstarttime=DATA.MAP_ALL_DATA(char(L(1))).TIMEVECTOR(1);
mapendtime=DATA.MAP_ALL_DATA(char(L(1))).TIMEVECTOR(end);
TS.dfsstartdatetime=mapstarttime;
TS.DfsTime = mapendtime-mapstarttime;

for M = STATIONS_LIST
    fprintf('Station: %s',char(M));
    try
        DATASTATION = DATA.MAP_ALL_DATA(char(M));
    catch
        fprintf(' Not Found Skipping \n');
        continue;
    end
    try
        %NESS20OL has -1e-35 for x and y as cells?
        %fprintf (fidgis,'%s,%7.1f,%8.1f', char(M), DATASTATION.X_UTM, DATASTATION.Y_UTM);
        % Run ids come from matlab file, the last one is the observed
        % data
        gse = DATASTATION.Z_GRID;
        DATASTATION.RUN(numTS) = {'Observed'};
        %create the desired observed timeseries
        TSS(numTS).ValueVector =  TSmerge(DATASTATION.TIMESERIES(:,numTS), TS.dlength, datenum(TS.startdate), datenum(TS.enddate), TS.dfsstartdatetime, TS.DfsTime+TS.dfsstartdatetime);
        % compute the year and month averages
        OUT(numTS) = mthyrV2(TS, TSS(numTS).ValueVector);
        % min max for plotting
        minval(numTS) = min(min(OUT(numTS).permthave));
        maxval(numTS) = max(max(OUT(numTS).permthave));
        % the legend (plotted as text, boxplot legend is no good)
        legnd{numTS} = char(M);
        legnd{numTS+1} = [datestr(TS.startdate),' to ',datestr(TS.enddate)];
        
        for cntTS = 1:numTS-1
            TSS(cntTS).ValueVector =  TSmerge(DATASTATION.TIMESERIES(:,cntTS), TS.dlength, datenum(TS.startdate), datenum(TS.enddate), TS.dfsstartdatetime, TS.DfsTime+TS.dfsstartdatetime);
            legnd(cntTS) =strcat(DATASTATION.RUN(cntTS));
            % compute the year and month averages
            OUT(cntTS) = mthyrV2(TS, TSS(cntTS).ValueVector);
            % Statistics
            STT(cntTS) = computestatsV1(TSS(numTS).ValueVector, TSS(cntTS).ValueVector);
            % min max for plotting
            minval(cntTS) = min(min(OUT(cntTS).permthave));
            maxval(cntTS) = max(max(OUT(cntTS).permthave));
            %
            fprintf (fidgis,',%f,%f,%f', STT(cntTS).RMSE, STT(cntTS).NS, STT(cntTS).BIAS);
        end
        fprintf (fidgis,'\n');
        minvl = min(minval);
        maxvl = max(maxval);
        %do the boxplot and print
        plotfile = strcat(figdir, M, '.png');
        plotboxcomb(INI,OUT, numTS, minvl, maxvl, legnd, plotfile,STT,gse,DATASTATION);
    catch
        fprintf('... Exception in A3_boxmat(), station:\n\t %s\n', char(M));
    end
% %     page3 = addtolatex(plotfile,page3, fidTEX);
% %     pause(0.01)
end



% % closelatex(fidTEX);
    fclose(fidgis);


fprintf('--- All Done\n');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = plotboxcomb(INI,OUT, numTS,minvl, maxvl, legnd, plotfile,STT,gse,STATION)
        
    fprintf(' - Plotting\n');

    set(gcf, 'PaperUnits', 'inches');
    %set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0,0,8,3]);
    set(gcf, 'Renderer', 'OpenGL');
    set(gcf, 'Color', 'w');
    %wysiwyg()
    fig = clf;
    fh = figure(fig);
    %SEE sfigure.m    set(0, 'CurrentFigure', fh);
%     f=[800,300];
%     set(fh,'units','points','position',[750,100,f(1),f(2)]);
    %movegui(fh,'northeast');
    fontSize=14;
    set(gca, 'FontSize', fontSize)
    
colorts = ['k', 'g', 'b', 'm', 'b', 'k', 'g', 'c', 'm', 'k', 'g', 'b', 'm', 'b'];
%     colorts= ['r', 'b', 'g', 'k', 'm', 'c'];
    wdth = 0.12;
%     wid = width * ones(1,length(pos));
    pos = [0.15 0.3 0.45 0.6 0.75 0.9];

%     cntTS = 1;
%     positionMTH = 1+pos(cntTS):1:12+pos(cntTS);
%     boxMTH = boxplot(OUT(cntTS).permthave,'colors',colorts(cntTS),'notch','off','positions',positionMTH,'width',wdth,'labels',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
%     hold on
    
    for cntTS = 1:numTS-2
        positionMTH = 1+pos(cntTS):1:12+pos(cntTS);    % Define position for 12 Month boxplots
        boxMTH = boxplot(OUT(cntTS).permthave,'colors',colorts(cntTS),'notch','off','positions',positionMTH,'width',wdth,'labels',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});   
        set(gca,'XTickLabel',{' '})  % Erase xlabels   
        hold on  % Keep the fig for overlap   
    end
    cntTS = cntTS + 1;
    positionMTH = 1+pos(cntTS):1:12+pos(cntTS);
    boxMTH = boxplot(OUT(cntTS).permthave,'colors',colorts(cntTS),'notch','off','positions',positionMTH,'width',wdth,'labels',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});

%    hold off
    aymin = minvl - 0.1*(maxvl-minvl);
    aymax = maxvl + 0.1*(maxvl-minvl);
        %check for min=0 and max=0
    if ((aymax-aymin)>0) ylim([aymin aymax]); end

    set(findobj(gca,'Type','text'),'FontSize',fontSize)
ylabel(strcat(STATION.DFSTYPE, ', ', STATION.UNIT));

    
 if (gse > -1.0e-035)
     %string_ground_level = strcat({'GSE: grid = '}, char(sprintf('%.1f',gse)), {' ft'});
     string_ground_level = '';
     add_ground_levelV0(1.3,0.13,gse,[188/256 143/256 143/256],2,'--',12,string_ground_level);
 end

    axlim = axis(gca);

    ylg=axlim(3);
    ylgincr=0.055*(aymax-aymin);
    xlg=0.75*(axlim(2)-axlim(1));
    %for cnt = numTS-1:-1:1
    %    ylg=ylg + ylgincr;
            %legend
%        text(xlg,ylg,legnd(cnt),'Color',colorts(cnt));
    %end
    text(xlg,ylg + ylgincr,legnd(numTS+1),'Color','k','FontSize',10);
%    text(xlg,ylg + 2*ylgincr,legnd(numTS),'Color','k','FontSize',14,'Interpreter','none');

% %     xaf=axlim(1)+0.75;
% %     xincr =1.00;
% %     yincr = 0.05*(aymax-aymin);
% %     %ypos = aymax -0.2;
% %     ypos = aymax - yincr*1.1;
    
xaf = xlg;
ypos = ylg + 1.1*(2 * ylgincr);
yincr = ylgincr;
xincr =0.80;
% Statistics
%     text(xaf,ypos,'RMSE ','Color','k');
%     text(xaf,ypos+yincr,'Bias ','Color','k');
%     text(xaf,ypos+2*yincr,'NS ','Color','k');
%     xaf = xaf + xincr;
%     for cntTS = 1:numTS-1
%         text(xaf,ypos,num2str(STT(cntTS).RMSE,'%6.2f'),'Color',colorts(cntTS));
%         text(xaf,ypos+yincr,num2str(STT(cntTS).BIAS,'%6.2f'),'Color',colorts(cntTS));
%         text(xaf,ypos+2*yincr,num2str(STT(cntTS).NS,'%6.2f'),'Color',colorts(cntTS));
%         xaf = xaf +xincr;
%     end
%  nn = length(INI.MODEL_RUN_DESC)+1;
%  NN(1) = {'Observed'};
%  NN(2:nn) = INI.MODEL_RUN_DESC(1:nn-1);
%  legt = NN;
%  legend(legt,7,'Location','SouthEast');
%  legend boxoff;

     % Number of points
        % The last model run is used, no checks if run lengths are different
    xaf1=axlim(1)+0.15;
    ypos1 = aymin +  yincr * 1.1;
    text(xaf1,ypos1,['No. Points: ' num2str(STT(numTS-1).ALLpoints,'%6d')],'Color','k','FontSize',8);
    text(xaf1,ypos1+yincr,['No. NaN: ' num2str(STT(numTS-1).NANpoints,'%6d')],'Color','k','FontSize',8);
        % remove outliers
    hout = findobj(gca,'tag','Outliers');
    for out_cnt = 1 : length(hout)
         set(hout(out_cnt), 'Visible', 'off')
    end
    title(STATION.NAME,'FontSize',12,'FontName','Times New Roman','Interpreter','none');
grid on
hold off
    print('-dpng',char(plotfile),'-r300')
    %imwrite(gca,char(plotfile),'png')
    %export_fig  char(plotfile)   -native
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % function [fidTEX ] = openlatex(latexfile)
% % 
% %     fprintf('... TeXing\n');
% %     fidTEX = fopen(latexfile,'w');
% % 
% % 	row2 ='\subsection{ Box plots }';
% % 	fprintf(fidTEX,'%s\n\n',row2);
% % end
% % %%%%%%%%%%%%%%%%%%%
% % function [ ] = closelatex(fidTEX)
% %     fprintf('... closing TeXing\n');
% %     ROW5 =[' \end{center}'];
% %     ROW6 =[' \end{figure}'];
% %     fprintf(fidTEX,'%s\n',ROW5);
% %     fprintf(fidTEX,'%s\n',ROW6);
% %     fclose(fidTEX);
% % end
% % %%%%%%%%%%%%%%%%%%%
% % function [page3 ] = addtolatex(pltfile, page3,fidTEX)
% % plotfile = char(pltfile);
% % 
% %     if page3 == 1
% %             ROW1 =[' \begin{figure}[!H] \begin{center}'];
% %         fprintf(fidTEX,'%s\n',ROW1);
% %     end
% % 
% %     if page3 > 3
% %             ROW5 =[' \end{center}'];
% %             ROW6 =[' \end{figure}'];
% %          fprintf(fidTEX,'%s\n',ROW5);
% %         fprintf(fidTEX,'%s\n',ROW6);
% %            fprintf(fidTEX,'%s\n','\clearpage');
% %             ROW1 =[' \begin{figure}[!H] \begin{center}'];
% %         fprintf(fidTEX,'%s\n',ROW1);
% %         ROW3 =[' \includegraphics[width=6.5in]{' plotfile '}'];
% %         fprintf(fidTEX,'%s\n',ROW3);
% %             page3 = 2;
% %     else
% %             page3=page3+1;
% %         ROW3 =[' \includegraphics[width=6.5in]{' plotfile '}'];
% % 
% %         fprintf(fidTEX,'%s\n',ROW3);
% % 
% %       end
% % 
% % end

