function [] = plot_timeseries(STATION,INI)
%{
---------------------------------------------
% FUNCTION DESCRIPTION:
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
021812 -v4- changed SIM to INI
        many style changes
% changes introduced to v2:  (keb 8/2011)
%  -script would exit prematurely if a STATION.X_UTM or Y was 
%   not found in the MAP_ALL_DATA container. now using try-catch.
%----------------------------------------
%}


TS = STATION.TIMESERIES;
TV = STATION.TIMEVECTOR;
n = length(TS(1,:));
% Legend putting OBSERVED as the first column, so that the legends matches;
N(1) = {'Observed'};
N(2:n) = INI.MODEL_RUN_DESC(1:n-1);

TV_STR = datestr(TV,2);
TSC = tscollection(TV_STR);
TMP = [];
TMP(:,1) = TS(:,length(TS(1,:)));
TMP(:,2:length(TS(1,:))) = TS(:,1:length(TS(1,:))-1);
TS = TMP;

for i = 1:n % add only the first n-1 series, the nth series is observed
    % find min and max for plotting
         minval(i) = min(min(TS(:,i)));
         maxval(i) = max(max(TS(:,i)));

TTS = timeseries(TS(:,i),TV_STR);
    TTS.name = char(N(i));
    TTS.TimeInfo.Format = 'mm/yy';
    TSC = addts(TSC,TTS);
end

NAMES =  gettimeseriesnames(TSC);

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0,0,8,3]);
set(gcf, 'Renderer', 'OpenGL');
set(gcf, 'Color', 'w');
fig = clf;
fh = figure(fig);
% Screen size and position
% f=[400,150];
% set(fh,'units','points','position',[750,100,f(1),f(2)]);
    
CO = {'r', 'k', 'g', 'b', 'm', 'b', 'k', 'g', 'c', 'm', 'k', 'g', 'b', 'm', 'b'};
LS = {'none','-','-','-','-','-.','-.','-.','-.','-.',':','--','-','-','-','-.','-.'};
M = {'s','none','none','none','none','none','none','none','none','none','none','none','none','none','none'};
MSZ = [ 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
LW = [ 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3];
for i = 1:n

        %NTS = NAMES(i);
% % %        H = plot_figureV0(H, TSC.(NTS), F, i);
% % % this is from plot_figure
        %TS = TSC.(NTS);
        TS = TSC.(NAMES(i));
        
       
        TS.TimeInfo.Format = 'mm/yy';
        FS = 14;
        set(gca,'FontSize',FS,'FontName','times');
        set(gca,'linewidth',LW(i)); 
        F = plot(TS,'LineWidth',LW(i), 'Linestyle', char(LS(i)), 'Color',char(CO(i)), 'Marker',char(M(i)), 'MarkerSize',MSZ(i),'LineWidth',LW(i));
        hold on
end

%NOTE:  TTS  TS are now identical



TSss.startdate = INI.ANALYZE_DATE_I;
TSss.enddate = INI.ANALYZE_DATE_F;
STS = nummthyr(TSss);
%HARDCODE:
tickspacing = 2;
xint = tickspacing*(STS.cumtotyrdays(end) / length(STS.yrs));
xtl=STS.yrs(1:tickspacing:length(STS.yrs));

xlabel('');
xlim([0,STS.cumtotyrdays(end)]);
set(gca,'XTick',(1:xint:STS.cumtotyrdays(end)))
set(gca,'XTickLabel',xtl)

ylabel(strcat(STATION.DFSTYPE, ', ', STATION.UNIT));
minvl = min(minval);
maxvl = max(maxval);
aymin = minvl - 0.1*(maxvl-minvl);
aymax = maxvl + 0.15*(maxvl-minvl);
ylim([aymin aymax]);

% % legh = [];
% % legt = N;
% % LEG = legend(legh, legt,7,'Location','SouthEast');
% % legend boxoff;

grid on;
if (STATION.Z_GRID > -1.0e-035)
    string_ground_level = strcat({'GSE: grid = '}, char(sprintf('%.1f',STATION.Z_GRID)), {' ft'});
    add_ground_levelV0(0,0.9,STATION.Z_GRID,[188/256 143/256 143/256],2,'--',12,string_ground_level);
end

plotfile = strcat(INI.FIGURES_DIR_TS,'/',STATION.NAME);
print('-dpng',char(plotfile),'-r300')
hold off

end


