function [ output_args ] = A2_generate_timeseries_stat(INI)
%---------------------------------------------
%{
 FUNCTION DESCRIPTION:

this function is after load computed_timeseries, it requires the computed
and observed to be loaded in a map

BUGS:
COMMENTS:
----------------------------------------
REVISION HISTORY:

changes introduced to v2:  (rjf 12/2011)
calling get_station_statV1 

changes introduced to v1:  (keb 7/2011)
 -script would exit prematurely if a STATION name from STATIONS_LIST
  was not found in the MAP_ALL_DATA container. modified script to 'try'
  to find station and just issue message if not found
%}
%----------------------------------------
fprintf('\n Beginning A2_generate_timeseries_stat: %s \n',datestr(now));
format compact

% load the file with elevation data
%fprintf('... Loading elevations:\n %s\n', char(INI.FILE_ELEVATION));
%rjf; not needed?
%%%load(INI.FILE_ELEVATION,'-mat');

%load the file with observed and computed data
%%%FILEDATA = [INI.ANALYSIS_DIR_TAG '/' INI.ANALYSIS_TAG '_TIMESERIES_DATA.MATLAB'];
FILEDATA = INI.FILESAVE_TS;
fprintf('--- Loading Computed and observed data:\n\t %s\n', char(FILEDATA));
load(FILEDATA, '-mat');

%setup the file where data will be saved as a structure which can be loaded
%in MATLAB subsequently.
%%%FILESAVE = [INI.ANALYSIS_DIR_TAG '/' INI.ANALYSIS_TAG '_TIMESERIES_STAT.MATLAB'];
FILESAVE = INI.FILESAVE_STAT;
%fprintf('\n... Computed and observed stat data will be saved in file: %s\n', char(FILESAVE))


% to select a list of station either use the line below. For selected
% stations rerun the entire script sequence A0, A1,...
STATIONS_LIST = INI.SELECTED_STATIONS.list.stat;
%do it with the map
%keys(INI.SELECTED_STATIONS.MAP)

% this processes the statistics of all stations from the MIKE SHE and MIKE
% 11 dfs0 result files. 

i = 1;
for M = STATIONS_LIST
   try
      STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
      try
        TS_NAN_STR = remove_nanV1(STATION,INI); % remove pairs that have NaN
        fprintf('\n...%d processing station stats: %s', i, char(STATION.NAME));
        STATION.TS_NAN = TS_NAN_STR;
        STATION = get_station_statV1(STATION); % make all station stats;
        try
            STATION.Z_GRID = cell2mat(INI.MAPXLS.MSHE(char(k)).gridgse);
        catch
            STATION.Z_GRID = -1.0e-35;
        end
        MAP_ALL_DATA(char(M)) = STATION; % modify the value for this key
      catch
        fprintf('\n...%d No observations, skipping station: %s', i, char(STATION.NAME));
      end
   catch
      fprintf('\n...%d\t Cannot find %s in MAP_ALL_DATA container', i, char(M));
   end
   i = i + 1;
end

fprintf('\n--- Saving data in file: %s\n', char(FILESAVE))
save(FILESAVE,'MAP_ALL_DATA','-v7.3');

end

