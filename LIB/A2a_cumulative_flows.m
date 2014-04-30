function [ output_args ] = A2a_cumulative_flows(INI)

fprintf('\n Beginning A2a_cumulative_flows: %s \n',datestr(now));
format compact

% load the file with elevation data
%fprintf('... Loading elevations:\n %s\n', char(INI.FILE_ELEVATION));
%rjf; not needed?
%%%load(INI.FILE_ELEVATION,'-mat');

%load the file with observed and computed data
%%%FILEDATA = [INI.ANALYSIS_DIR_TAG '/' INI.ANALYSIS_TAG '_TIMESERIES_DATA.MATLAB'];
FILEDATA = INI.FILESAVE_STAT;
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
% sumarize data and save in STATIN structure
for M = STATIONS_LIST
    try
        STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values
        STATION = summarize_YM(STATION,INI);
        MAP_ALL_DATA(char(M)) = STATION; % modify the map by adding STATION
    catch
        fprintf('\n...%d\t Cannot find %s in MAP_ALL_DATA container', i, char(M));
    end
    i = i + 1;
end

write_QYM(MAP_ALL_DATA,INI,STATIONS_LIST);

fprintf('\n--- Saving data in file: %s\n', char(FILESAVE))
save(FILESAVE,'MAP_ALL_DATA','-v7.3');

end

