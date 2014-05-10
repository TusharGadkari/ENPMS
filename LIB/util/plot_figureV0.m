function [F] = plot_figureV0(H, TS, F, i)

TS.TimeInfo.Format = 'mm/dd/yy';
LW = F.LW(i);
LS = F.LS(i);
CO = F.CO(i);
M = F.M(i);
LW = F.LW(i);
MSZ = F.MSZ(i);
%keb%FS = 12;
FS = 20;

CF = get(gcf);
XA = get(gca);
F = get(H);
set(gca,'FontSize',FS,'FontName','times');

set(gca,'linewidth',LW); 
F = plot(TS,'LineWidth',LW, 'Linestyle', char(LS), 'Color',char(CO), 'Marker',char(M), 'MarkerSize',MSZ,'LineWidth',LW);
hold on
% F=plot(TS,'LineWidth', 1,'-bo','FontSize', 8)
end

