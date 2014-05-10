function [MAP_DATA_ALL] = add_observedV0(MAP_COMPUTED,DATA,...
    ANALYZE_DATE_I,ANALYZE_DATE_F,MAP_ELEVATIONS)

%load('station_coordinates_400.mat');

for i = 1:length(DATA.STATION)
    NAME(i) = DATA.STATION(i).NAME;
    STATION(i) = {DATA.STATION(i)};  
end

MAP_OBSERVED = containers.Map(NAME,STATION);

K = keys(MAP_COMPUTED);
ii = 1;

sz_key=length(K);

for k = K
    try
    ZCOORD = MAP_ELEVATIONS(char(k));
    catch
        ZCOORD.Z_GRID = NaN;
        ZCOORD.Z_SURVEY = NaN;
    end
    DATA_COMP_TMP = MAP_COMPUTED(char(k));
    sz = length(DATA_COMP_TMP.TIMESERIES(:,1));
    i_obs = sz;
    TIMESERIES = MAP_COMPUTED(char(k)).TIMESERIES;
    sz_ts = length(TIMESERIES(1,:));
    DATA_ALL(ii).DATATYPE = '';
    DATA_ALL(ii).DFSTYPE = MAP_COMPUTED(char(k)).DFSTYPE;
    DATA_ALL(ii).X_UTM = NaN;
    DATA_ALL(ii).Y_UTM = NaN;
    DATA_ALL(ii).Z = NaN;
    DATA_ALL(ii).Z_GRID = NaN;
    DATA_ALL(ii).Z_SURF = NaN;
    DATA_ALL(ii).UNIT = MAP_COMPUTED(char(k)).UNIT;
    try
        DATA_OBS_TMP = MAP_OBSERVED(char(k));
        TIMESERIES_TMP = DATA_OBS_TMP.DOBSERVED;
        DATA_ALL(ii).DATATYPE = DATA_OBS_TMP.DATATYPE;
        TIMEVECTOR_OBS = DATA_OBS_TMP.TIMEVECTOR;
        TIMESERIES_OBS = extract_period_tsV0(TIMESERIES_TMP, TIMEVECTOR_OBS,ANALYZE_DATE_I,ANALYZE_DATE_F);
        TIMESERIES(i_obs,:) = TIMESERIES_OBS;
        DATA_ALL(ii).X_UTM = DATA_OBS_TMP.X_UTM;
        DATA_ALL(ii).Y_UTM = DATA_OBS_TMP.Y_UTM;
        DATA_ALL(ii).Z = NaN;
        DATA_ALL(ii).Z_GRID = ZCOORD.Z_GRID;
        DATA_ALL(ii).Z_SURVEY = ZCOORD.Z_SURVEY;
    catch
        fprintf('... MISSING OBSERVED DATA for station: %s\n', char(k));
    end
    DATA_ALL(ii).TIMESERIES = TIMESERIES'; % transpose to vertical
    DATA_ALL(ii).TIMEVECTOR = DATA_COMP_TMP.TIMEVECTOR'; % transpose to vertical
    DATA_ALL(ii).NAME = k;
    MAP_KEY(ii) = k;
    MAP_VALUE(ii) = {DATA_ALL(ii)};
    ii = ii + 1;
end

MAP_DATA_ALL = containers.Map(MAP_KEY, MAP_VALUE);

end
