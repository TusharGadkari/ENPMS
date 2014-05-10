function [output_args] = plot_timeseries_accumulatedV0(STATION,SIM,F,PLOT_FIGURES)

    %rjf;  HARDCODE%%%%%%%%%%%%%%%%%%%%%%%%%
    FIGURE_FILE = strcat(F.FIGURES_DIR,'/',F.TITLE,'-ACCUMULATED');
%%%FIGURE_FILE is the filename of the figure to be saved, png, pdf, bmp
%%%FIGURE_FILE = strcat(F.FIGURES_DIR,'/A3_TS_',F.TITLE,'-ACCUMULATED');

%conversion from cfs to ac-feet/year = 723.97
CFS_AC_FTANNUM = 723.97;

%create time series:
TS = STATION.TIMESERIES;
TV = STATION.TIMEVECTOR;
NAME = STATION.NAME;
X = STATION.X_UTM;
Y = STATION.Y_UTM;
YLABEL = 'Cumulative discharge, ac-ft';
XLABEL = F.XLABEL;
F.TITLE = strcat(F.TITLE,'_ACCUMULATED');

n = length(TS(1,:));
N(1) = {'Observed'};
N(2:n) = SIM.MODEL_RUN_DESC;
% putting OBSERVED as the first column, so that the legends matches;
TMP = [];
TMP(:,1) = TS(:,length(TS(1,:)));
TMP(:,2:length(TS(1,:))) = TS(:,1:length(TS(1,:))-1);
TS = TMP;
%%%%%%%%%%

TV_STR = datestr(TV,2);

TSC = tscollection(TV_STR);

for i = 1:n % add only the first n-1 series, the nth series is observed
    TS_NANS = TS(:,i);
    INAN = isnan(TS_NANS);
    TS_NANS(INAN) = 0;
    ACCUMULATED = cumsum(TS_NANS);
    ACCUMULATED_ACFT = ACCUMULATED * CFS_AC_FTANNUM;
    TTS = timeseries(ACCUMULATED_ACFT,TV_STR);
    TTS.name = char(N(i));
    TTS.TimeInfo.Format = 'mm/dd/yy';
    TSC = addts(TSC,TTS);
end

NAMES =  gettimeseriesnames(TSC);

if PLOT_FIGURES % plot if PLOT_FIGURES = 1;
    H = clf;
    
    for i = 1:n
        NTS = NAMES(i);
        H = plot_figureV0(H, TSC.(NTS), F, i);
    end
    
    FSZ = 12;% fontsize
    s_title = strcat({'Cumulative discharge, ac-ft '}, F.TITLE,{', [X,Y]=['}, num2str(X),{', '}, num2str(Y), '] m');
    set_figure_propertiesV0(SIM,F,XLABEL,YLABEL,X,Y,FSZ,s_title);
    
    % % saveas(gcf,char(FIGURE_FILE),'bmp');
    % % save2pdf(char(FIGURE_FILE),gcf,600);
    print_figureV0(FIGURE_FILE);
    
    hold off
end

end

