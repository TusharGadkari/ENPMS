function [output_args] = make_figures_stat_excV0(STATION,SIM,F)

F.TITLE = STATION.NAME;
F.YLABEL = strcat(STATION.DFSTYPE, ', ', STATION.UNIT);
F.XLABEL = 'Exceedance Probability';
plot_exceedanceV0(STATION,SIM,F);

end

