function [] = print_figureV1(FIGURE_FILE)

% NumTicks = 14; 
% L = get(gca,'XLim'); 
% set(gca,'XTick',linspace(L(1),L(2),NumTicks)); 

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6,6]);
set(gcf, 'PaperPositionMode', 'manual');
%v2 change paperposition
set(gcf, 'PaperPosition', [0,0,6,6]);
set(gca, 'Position', get(gca, 'OuterPosition') - ...
    get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
set(gcf, 'Renderer', 'OpenGL');
print('-dpng',char(FIGURE_FILE),'-r300')
%%%saveas(gcf, char(FIGURE_FILE));

end  
