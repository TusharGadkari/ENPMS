function [output_args] = plot_timeseriesV0(STATION,SIM,F,PLOT_FIGURES)

TS = STATION.TIMESERIES;
TV = STATION.TIMEVECTOR;
NAME = STATION.NAME;
X = STATION.X_UTM;
Y = STATION.Y_UTM;
YLABEL = F.YLABEL;
XLABEL = F.XLABEL;

n = length(TS(1,:));
N(1) = {'Observed'};
N(2:n) = SIM.MODEL_RUN_DESC(1:n-1);

TV_STR = datestr(TV,2);

TSC = tscollection(TV_STR);
% putting OBSERVED as the first column, so that the legends matches;
TMP = [];
TMP(:,1) = TS(:,length(TS(1,:)));
TMP(:,2:length(TS(1,:))) = TS(:,1:length(TS(1,:))-1);
TS = TMP;
%%%%%%%%%%

for i = 1:n % add only the first n-1 series, the nth series is observed
    TTS = timeseries(TS(:,i),TV_STR);
    TTS.name = char(N(i));
    TTS.TimeInfo.Format = 'mm/dd/yy';
    TSC = addts(TSC,TTS);
end

NAMES =  gettimeseriesnames(TSC);

if PLOT_FIGURES
    H = clf;
    
    for i = 1:n
        NTS = NAMES(i);
        H = plot_figureV0(H, TSC.(NTS), F, i);
    end
    
    if ~isempty(STATION.Z_SURVEY) & ~isnan(STATION.Z_SURVEY)
        ZGL = STATION.Z_SURVEY;
        add_ground_levelV0(0,0.95,ZGL,[0 0.5 0],3,'-',12,'Survey');
    end
    if ~isempty(STATION.Z_GRID) & ~isnan(STATION.Z_GRID)
        ZGL = STATION.Z_GRID;
        add_ground_levelV0(0,0.9,ZGL,[1 0 0],2,'--',12,'Grid');
    end
    
    FSZ = 20;% fontsize
    %keb%FSZ = 12;% fontsize
    
    s_title = strcat({'Time Series '}, F.TITLE,{', [X,Y]=['}, num2str(X),{', '}, num2str(Y), '] m');
    set_figure_propertiesV0(SIM,F,XLABEL,YLABEL,X,Y,FSZ,s_title);
    
    
    %rjf;  HARDCODE%%%%%%%%%%%%%%%%%%%%%%%%%
    FIGURE_FILE = strcat(F.FIGURES_DIR,'/',F.TITLE);
    
    
    % saveas(gcf,char(FIGURE_FILE),'bmp');
    % save2pdf(char(FIGURE_FILE),gcf,600);
    
    print_figureV0(FIGURE_FILE);
    hold off
end
end


