function [MAP_STATION_STAT] = get_map_station_stat_v2(MAP_ALL_DATA,STATIONS_LIST)
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (rjf)
%  deleted args SIM and F, not used
%  changed keys() to the selected station list
%
% changes introduced to v2:  (keb 8/2011)
%  -script would exit prematurely if a STATION name from STATIONS_LIST
%   was not found in the MAP_ALL_DATA container. modified script to 'try'
%   to find station and just issue message if not found
%  -modified to 'try' to make MAP_STATION_STAT container but return MAP_STATION_STAT=0
%   if it doesn't succeed (before it would just exit prematurely)
%----------------------------------------

i = 1;
%%%for M = keys(MAP_ALL_DATA)
for M = STATIONS_LIST
   try
      STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
      try
        %STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
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
   catch
      fprintf('...%d Cannot find %s in MAP_ALL_DATA container\n', i, char(M));
   end
        
end

try
  MAP_STATION_STAT = containers.Map(MAP_KEY, MAP_VALUE);
catch
  fprintf('...Cannot make MAP_STATION_STAT\n');
  MAP_STATION_STAT = 0
end

end

