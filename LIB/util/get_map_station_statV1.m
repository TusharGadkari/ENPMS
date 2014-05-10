function [MAP_STATION_STAT] = get_map_station_statV1(MAP_ALL_DATA,STATIONS_LIST)
%rjf; deleted args SIM and F, not used
% changed keys() to the selected station list

i = 1;
%%%for M = keys(MAP_ALL_DATA)
for M = STATIONS_LIST
    try
        STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
        STATION_NAME(i) = M;
        K = keys(STATION.TS_NAN);
%rjf; deleted args SIM and F, not used
        STATION_STAT(i) = get_stat_stationV1(STATION);
        if ~isempty(STATION_STAT(i).PE)
            MAP_KEY(i) = M;
            MAP_VALUE(i) = {STATION_STAT(i)};
            i = i + 1;
        end
    catch
        fprintf('...get_map_station_stat: No mapped data for %s, skipped\n', char(M));
    end
        
end

MAP_STATION_STAT = containers.Map(MAP_KEY, MAP_VALUE);

end

