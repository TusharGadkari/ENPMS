function [output_args] = make_figures_station_v1(STATION,SIM,F,PLOT_FIGURES)
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 8/2011)
%  -calling plot_timeseries_v2 (instead of v1) which had bug
%  -calling plot_timeseries_accumulated_v1 (instead of v0) which has
%  updated units for flow
%----------------------------------------

F.TITLE = STATION.NAME;
F.YLABEL = strcat(STATION.DFSTYPE, ', ', STATION.UNIT);

plot_timeseries_v2(STATION,SIM,F,PLOT_FIGURES); % comment to plot only accumulated
if strcmp(STATION.DFSTYPE,'Discharge')
    plot_timeseries_accumulated_v1(STATION,SIM,F,PLOT_FIGURES);
end

end

