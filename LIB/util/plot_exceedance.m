function [] = plot_exceedance(STATION,INI)

% % strDI = datestr(INI.ANALYZE_DATE_I,2);
% % strDF = datestr(INI.ANALYZE_DATE_F,2);

F.XLABEL = ''; % this provides a horizontal label
F.CO = {'r', 'k', 'g', 'b', 'm', 'b', 'k', 'g', 'c', 'm', 'k', 'g', 'b', 'm', 'b'};
F.LS = {'none','-','-','-','-','-.','-.','-.','-.','-.',':','--','-','-','-','-.','-.'};
F.M = {'s','none','none','none','none','none','none','none','none','none','none','none','none','none','none'};
F.MSZ = [ 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
F.LW = [ 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3];
F.TS_DESCRIPTION = {'Observed'};  %description of observed data
F.TITLE = STATION.NAME;
F.YLABEL = strcat(STATION.DFSTYPE, ', ', STATION.UNIT);

%rjf; ERROR TS_NAN not defined %%%%%%%%%%%%%%%%%
%Gets defined in A2
%for structures still get error so do the try/catch
try
    MAP_NAN = STATION.TS_NAN;
catch
	fprintf('...TS_NAN not defined in plot_exceedance, skipping\n');
    return;
end

MAP_KEYS = keys(MAP_NAN);
N = length(MAP_KEYS);

NAME = STATION.NAME;
X = STATION.X_UTM;
Y = STATION.Y_UTM;
YLABEL = F.YLABEL;
XLABEL = F.XLABEL;

    set(gcf, 'PaperUnits', 'inches');
    %set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0,0,8,3]);
    set(gcf, 'Renderer', 'OpenGL');
    set(gcf, 'Color', 'w');
    fig = clf;
    fh = figure(fig);
% Screen size and position
% f=[400,150];
% set(fh,'units','points','position',[750,100,f(1),f(2)]);
i = 1;

% plot observed as the first item
DMATRIX = MAP_NAN(char(MAP_KEYS(1))).TS;
%DM_HEADER = MAP_NAN(char(MAP_KEYS(1))).TS_HEADER;

%NPOINTS = NaN;
%PRINT_IF_OBSERVED = 0;

if isempty(DMATRIX) ; return; end
    
if ~isempty(DMATRIX)
    XM = DMATRIX(:,8);
    YM = DMATRIX(:,6);
    %NPOINTS = length(DMATRIX(:,1));
    %PRINT_IF_OBSERVED = 1;
    H = plot(XM, YM,'LineWidth',F.LW(1), 'Linestyle', char(F.LS(1)), ...
        'Color',char(F.CO(1)), 'Marker',char(F.M(1)), 'MarkerSize',...
        F.MSZ(1),'LineWidth',F.LW(1));
    hold on
end
i = 2;


 NSS(1) = {'Observed'};
 NSS(2:N+1) = INI.MODEL_RUN_DESC(1:N);
%  for ii = 2:N+1 % add model runs
%      MK = NSS(ii);
for MK = MAP_KEYS % why is this not used
    DM_HEADER = MAP_NAN(char(MK)).TS_HEADER; % why is this not used
     DMATRIX = MAP_NAN(char(MK)).TS;
     if ~isempty(DMATRIX)
         XM = DMATRIX(:,8);
         YM = DMATRIX(:,5);
         H = plot(XM, YM,'LineWidth',F.LW(i), 'Linestyle', char(F.LS(i)), ...
             'Color',char(F.CO(i)), 'Marker',char(F.M(i)), 'MarkerSize',...
             F.MSZ(i),'LineWidth',F.LW(i));
     end
     i = i + 1;
 end

    
 nn = length(MAP_KEYS)+1;
 NN(1) = {'Observed'};
 NN(2:nn) = INI.MODEL_RUN_DESC(1:nn-1);
 legt = NN;
 set(get(gca,'YLabel'),'String',YLABEL,'FontName','times','FontSize',14);
 
 legend(legt,7,'Location','SouthWest');
 
 legend boxoff;
 grid on;
 s_title = strcat({'Station '},char(STATION.NAME));
 title(s_title,'FontSize',14,'FontName','times','Interpreter','none');
 
 try
     STATION.Z_GRID = cell2mat(INI.MAPXLS.MSHE(char(STATION.NAME)).gridgse);
 catch
     STATION.Z_GRID = -1.0e-35;
 end
 
 if (STATION.Z_GRID > -1.0e-035)
     %string_ground_level = strcat({'GSE: grid = '}, char(sprintf('%.1f',STATION.Z_GRID)), {' ft'});
     string_ground_level = '';
     add_ground_levelV0(0,0.15,STATION.Z_GRID,[188/256 143/256 143/256],2,'--',12,string_ground_level);
 end
 
 plotfile = strcat(INI.FIGURES_DIR_EXC,'/',STATION.NAME);
 print('-dpng',char(plotfile),'-r300')
 
 hold off
 
end

