function [output_args] = make_figures_stationV0(STATION,SIM,F,PLOT_FIGURES)

F.TITLE = STATION.NAME;
F.YLABEL = strcat(STATION.DFSTYPE, ', ', STATION.UNIT);

plot_timeseriesV1(STATION,SIM,F,PLOT_FIGURES); % comment to plot only accumulated
if strcmp(STATION.DFSTYPE,'Discharge')
    plot_timeseries_accumulatedV0(STATION,SIM,F,PLOT_FIGURES);
end

end

