function [output_args] = plot_exceedanceV0(STATION,SIM,F)

strDI = datestr(SIM.ANALYZE_DATE_I,2);
strDF = datestr(SIM.ANALYZE_DATE_F,2);


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

H = clf;
i = 1;

% plot observed as the first item
DMATRIX = MAP_NAN(char(MAP_KEYS(1))).TS;
DM_HEADER = MAP_NAN(char(MAP_KEYS(1))).TS_HEADER;

NPOINTS = NaN;
PRINT_IF_OBSERVED = 0;

if ~isempty(DMATRIX)
    XM = DMATRIX(:,8);
    YM = DMATRIX(:,6);
    NPOINTS = length(DMATRIX(:,1));
    PRINT_IF_OBSERVED = 1;
    H = plot(XM, YM,'LineWidth',F.LW(1), 'Linestyle', char(F.LS(1)), ...
        'Color',char(F.CO(1)), 'Marker',char(F.M(1)), 'MarkerSize',...
        F.MSZ(1),'LineWidth',F.LW(1));
    hold on
end
i = 2;

for MK = MAP_KEYS
    DM_HEADER = MAP_NAN(char(MK)).TS_HEADER;
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

%rjf; TODO:
% if there are more than one computed series
% the legend expects the entries, but the plots are not generated
% generates: Warning: Ignoring extra legend entries.

if PRINT_IF_OBSERVED
    
    legh_ = []; legt_ = {};
    legt_ = F.TS_DESCRIPTION;
    %legt_{nsets+1} = 'Observed';
    
    set(get(gca,'XLabel'),'String',XLABEL,'FontName','times','FontSize',12)
    set(get(gca,'YLabel'),'String',YLABEL,'FontName','times','FontSize',12);
    
    %%%LEG = legend(legh_, legt_,7,'Location','NorthEast');
    legend(legt_,7,'Location','NorthEast');
    
    legend boxoff;
    grid on;
    
    zsg = num2str(STATION.Z_GRID,4);
    zss = num2str(STATION.Z_SURVEY,4);
    zsd = num2str(STATION.Z_SURVEY-STATION.Z_GRID,2);
    
    string_ground_level = strcat('Ground Level: grid=', zsg, ' ft, survey=', zss, ' ft, diff=', zsd, ' ft');
    
%     hline(STATION.Z_GRID,'g',string_ground_level);
    add_ground_levelV0(0,0.05,STATION.Z_SURVEY,[0 0.5 0],3,'-',12,string_ground_level);
    
    s_title = strcat({'Station '},F.TITLE,{', period:'}, ...
        strDI,{'-'},strDF,{', observed='}, num2str(NPOINTS));
    title(s_title,'FontSize',12,'FontName','Times New Roman','Interpreter','none');
    set(gca,'FontSize',12,'FontName','times');
    
    %rjf;  HARDCODE%%%%%%%%%%%%%%%%%%%%%%%%%
    FIGURE_FILE = strcat(F.FIGURES_DIR,'/',F.TITLE);
%%%    FIGURE_FILE = strcat(F.FIGURES_DIR,'/A4_PE_',F.TITLE);
    % saveas(gcf,char(FIGURE_FILE),'bmp');
    % save2pdf(char(FIGURE_FILE),gcf,600);
    % saveas(gcf,char(FIGURE_FILE),'png');
%   print('-dpng',char(FIGURE_FILE),'-r300');
%     saveas(gcf, char(FIGURE_FILE));
print_figureV0(FIGURE_FILE);
end
hold off

end

