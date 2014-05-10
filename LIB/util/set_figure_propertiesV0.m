function [output_args] = set_figure_propertiesV0(SIM,F,XLABEL,YLABEL,X,Y,FSZ,STITLE)

% get initial times:
DI = datenum(SIM.ANALYZE_DATE_I);
DE = datenum(SIM.ANALYZE_DATE_F);
% datetick(gca,'keeplimits');
% xlim([DI DE]);

legh_ = []; legt_ = {};
legt_ = F.TS_DESCRIPTION;
%legt_{nsets+1} = 'Observed';

xlabel(XLABEL);
ylabel(YLABEL);

LEG = legend(legh_, legt_,7,'Location','SouthEast');

legend boxoff;
grid on;

title(STITLE,'FontSize',FSZ,'FontName','Times New Roman','Interpreter','none');

YLIM=get(gca,'ylim');
XLIM=get(gca,'xlim');

end

