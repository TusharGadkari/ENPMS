function [] = plot_timeseries_accumulated_v2(STATION,INI)
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 8/2011)
%  -changed conversion factor from cfs->af/yr to cfs->kaf/day,
%   also changed y-axis label and plot title
%----------------------------------------
    fprintf('\n\tAcc plot: %s',  char(STATION.NAME))

    %rjf;  HARDCODE%%%%%%%%%%%%%%%%%%%%%%%%%
%     FIGURE_FILE = strcat(F.FIGURES_DIR,'/',F.TITLE,'-ACCUMULATED');
%%%FIGURE_FILE is the filename of the figure to be saved, png, pdf, bmp
%%%FIGURE_FILE = strcat(F.FIGURES_DIR,'/A3_TS_',F.TITLE,'-ACCUMULATED');

%conversion from cfs to ac-feet/year = 723.97
%CFS_AC_FTANNUM = 723.97;

%conversion from cfs to kaf/day
CFS_KAFDY = 0.001982;

%create time series:
TS = STATION.TIMESERIES;
TV = STATION.TIMEVECTOR;
% NAME = STATION.NAME;
% X = STATION.X_UTM;
% Y = STATION.Y_UTM;
%YLABEL = 'Cumulative discharge, ac-ft';
% XLABEL = F.XLABEL;
% F.TITLE = strcat(F.TITLE,'_ACCUMULATED');

n = length(TS(1,:));
N(1) = {'Observed'};
N(2:n) = INI.MODEL_RUN_DESC(1:n-1);
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
    %ACCUMULATED_ACFT = ACCUMULATED * CFS_AC_FTANNUM;
    ACCUMULATED_ACFT = ACCUMULATED * CFS_KAFDY;
    TTS = timeseries(ACCUMULATED_ACFT,TV_STR);
    TTS.name = char(N(i));
    %TTS.TimeInfo.Format = 'mm/dd/yy';
    TTS.TimeInfo.Format = 'mm/yy';
    TSC = addts(TSC,TTS);
end

NAMES =  gettimeseriesnames(TSC);

    set(gcf, 'PaperUnits', 'inches');
    %set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0,0,8,3]);
    set(gcf, 'Renderer', 'OpenGL');
    set(gcf, 'Color', 'w');
    fig = clf;
    fh = figure(fig);
    f=[800,300];
    set(fh,'units','points','position',[750,100,f(1),f(2)]);
    
CO = {'r', 'k', 'g', 'b', 'm', 'b', 'k', 'g', 'c', 'm', 'k', 'g', 'b', 'm', 'b'};
LS = {'none','-','-','-','-','-.','-.','-.','-.','-.',':','--','-','-','-','-.','-.'};
M = {'s','none','none','none','none','none','none','none','none','none','none','none','none','none','none'};
MSZ = [ 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
LW = [ 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3];
    
    for i = 1:n
        NTS = NAMES(i);
%%%        H = plot_figureV0(H, TSC.(NTS), F, i);
%this is from plot_figure
        TS = TSC.(NTS);
        TS.TimeInfo.Format = 'mm/yy';
        FS = 14;
        set(gca,'FontSize',FS,'FontName','times');
        set(gca,'linewidth',LW(i)); 
        F = plot(TS,'LineWidth',LW(i), 'Linestyle', char(LS(i)), 'Color',char(CO(i)), 'Marker',char(M(i)), 'MarkerSize',MSZ(i),'LineWidth',LW(i));
        hold on
    end
    
title(STATION.NAME,'FontSize',14,'FontName','Times New Roman','Interpreter','none');
    
ylabel('Cumulative discharge, Kaf');

     xlabel('');
xlim([0,length(TS.Time)-1]);

% %     FSZ = 12;% fontsize
% %     %s_title = strcat({'Cumulative discharge, ac-ft '}, F.TITLE,{', [X,Y]=['}, num2str(X),{', '}, num2str(Y), '] m');
% %     s_title = strcat({'Cumulative discharge, Kaf, '}, F.TITLE,{', [X,Y]=['}, num2str(X),{', '}, num2str(Y), '] m');
% %     set_figure_propertiesV0(SIM,F,XLABEL,YLABEL,X,Y,FSZ,s_title);
    
plotfile = strcat(INI.FIGURES_DIR_TS,'/',STATION.NAME,'-acc');
    print('-dpng',char(plotfile),'-r300')
    % % saveas(gcf,char(FIGURE_FILE),'bmp');
    % % save2pdf(char(FIGURE_FILE),gcf,600);
%    print_figureV0(FIGURE_FILE);
    
    hold off
%end

end

