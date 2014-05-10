function [MAP_DATA_ALL] = add_observed(INI,MAP_COMPUTED,DATA)

%{
    added run info to map
%}
fprintf('... Add observed\n');

for i = 1:length(DATA.STATION)
    NAME(i) = DATA.STATION(i).NAME;
    STATION(i) = {DATA.STATION(i)};
end

MAP_OBSERVED = containers.Map(NAME,STATION);

K = keys(MAP_COMPUTED);
ii = 1;

%sz_key=length(K);

for k = K
    %  try
    %ZCOORD = MAP_ELEVATIONS(char(k));
    % %         ZCOORD.Z_GRID = INI.MAPXLS.MSHE(char(k)).gridgse;
    % %         ZCOORD.Z_SURVEY = INI.MAPXLS.MSHE(char(k)).dfegse;
    % %
    % %      catch
    % %          ZCOORD.Z_GRID = 0;
    % %          ZCOORD.Z_SURVEY = 0;
    % %      end
    % %     fprintf('... Station: %s\n', char(k));
    DATA_COMP_TMP = MAP_COMPUTED(char(k));
    sz = length(DATA_COMP_TMP.TIMESERIES(:,1));
    i_obs = sz;
    TIMESERIES = MAP_COMPUTED(char(k)).TIMESERIES;
    %sz_ts = length(TIMESERIES(1,:));
    %    DATA_ALL(ii).DATATYPE = '';
    DATA_ALL(ii).DFSTYPE = MAP_COMPUTED(char(k)).DFSTYPE;
    %     DATA_ALL(ii).X_UTM = NaN;
    %     DATA_ALL(ii).Y_UTM = NaN;
    %     DATA_ALL(ii).Z_GRID = {-1.0e-35};
    %     DATA_ALL(ii).Z_SURVEY = {-1.0e-35};
    DATA_ALL(ii).UNIT = MAP_COMPUTED(char(k)).UNIT;
    DATA_ALL(ii).RUN = MAP_COMPUTED(char(k)).RUN;
    try
        if isKey(MAP_OBSERVED,char(k))
            DATA_OBS_TMP = MAP_OBSERVED(char(k));
            TIMESERIES_TMP = DATA_OBS_TMP.DOBSERVED;
            TIMEVECTOR_OBS = DATA_OBS_TMP.TIMEVECTOR;
            TIMESERIES_OBS = extract_period_ts(TIMESERIES_TMP, TIMEVECTOR_OBS,INI.ANALYZE_DATE_I,INI.ANALYZE_DATE_F);
            TIMESERIES(i_obs,:) = TIMESERIES_OBS;
            if (DATA_OBS_TMP.DATATYPE)
                DATA_ALL(ii).DATATYPE = DATA_OBS_TMP.DATATYPE;
            else
                DATA_ALL(ii).DATATYPE = '';
            end
            if (DATA_OBS_TMP.X_UTM)
                DATA_ALL(ii).X_UTM = DATA_OBS_TMP.X_UTM;
            else
                DATA_ALL(ii).X_UTM = {-1.0e-35};
            end
            if (DATA_OBS_TMP.Y_UTM)
                DATA_ALL(ii).Y_UTM = DATA_OBS_TMP.Y_UTM;
            else
                DATA_ALL(ii).Y_UTM = {-1.0e-35};
            end
            try
                DATA_ALL(ii).Z_GRID = cell2mat(INI.MAPXLS.MSHE(char(k)).gridgse);
            catch
                DATA_ALL(ii).Z_GRID = -1.0e-35;
            end
            try
                DATA_ALL(ii).Z_SURVEY = cell2mat(INI.MAPXLS.MSHE(char(k)).dfegse);
            catch
                DATA_ALL(ii).Z_SURVEY = -1.0e-35;
            end
        else
            fprintf('... MISSING OBSERVED DATA for station: %s\n', char(k));
            
        end
        
        DATA_ALL(ii).TIMESERIES = TIMESERIES'; % transpose to vertical
        DATA_ALL(ii).TIMEVECTOR = DATA_COMP_TMP.TIMEVECTOR'; % transpose to vertical
        DATA_ALL(ii).NAME = k;
        MAP_KEY(ii) = k;
        MAP_VALUE(ii) = {DATA_ALL(ii)};
        ii = ii + 1;
        %end
        
        MAP_DATA_ALL = containers.Map(MAP_KEY, MAP_VALUE);
    catch
        fprintf('... Exception in: add_observed() for station: %s\n', char(k));
    end
    
end
end

