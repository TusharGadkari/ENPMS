function [] = A3_create_figures_timeseries( INI )
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% this function is after load computed_timeseries, it requires the computed
% and observed to be loaded in a map
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 7/7/2011)
%  -calling make_figures_station_v1 (instead of v0) which calls plot_timeseries_v2
%   (instead of v1) and plot_timeseries_accumulated_v1 (instead of v0)
%----------------------------------------
format compact;
fprintf('\n Beginning A3_create_figures_timeseries: %s \n',datestr(now));

FILEDATA = INI.FILESAVE_TS;
fprintf('... Loading Computed and observed data:\n\t %s\n', char(FILEDATA));
load(FILEDATA, '-mat');

% only do the selected stations
STATIONS_LIST = INI.SELECTED_STATIONS.list.stat;

i = 1;
for M = STATIONS_LIST
%    pause(0.01)
    fprintf('...%d processing station plot: %s', i, char(M))
     try
        STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
       %  make_figures_station_v1(STATION,INI,F,PLOT_FIGURES);
        make_figures_station(STATION,INI);
       %from make_figures_station
    plot_timeseries(STATION,INI); % comment to plot only accumulated
    if strcmp(STATION.DFSTYPE,'Discharge')
        plot_timeseries_accumulated(STATION,INI);
    end
        fprintf('\n')
     catch
         fprintf(' --> missing timeseries data (skipping plot)\n')
     end
    i = i + 1;
end

end


