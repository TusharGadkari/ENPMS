function [MAP_COMPUTED] = combine_computed_v2(MOLUZ,M11,MSHE,OL,M3DSZQ,M3DSZ,DATE_I,DATE_F)

%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% This function combines all data in the containers into one container.
% Assumes daily data.
%
% BUGS:
% We aren't sure what happens when there is a duplicate key between containers(ie M11 and MSHE containers both have 'S331').
%  (we should probably put a checksum or something in for this)
%
% COMMENTS:
% keb: why are fprintf statements commented out? don't understand what this is supposed to do...
%
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 7/2011)
%  -changed input args from (M11, MSHE, DATE_I, DATE_F) to (MOLUZ, M11, MSHE, DFS2, DFS3, DATE_I, DATE_F)
%  -added functionality to work with dfs2 and dfs3 containers
%  -added try statements so script wouldn't crash if handed '0' instead of a container
%  -changed calculation of sz variable to look in all arrays for max number of model runs, therefore can handle empty containers

% changes introduced to v2: (keb 10/2011)
% -moved initialization of some variables to later in the script
% -removed lines: NAME(i) = KEY; % 2011-10-26 keb - removed because not used later in this routine
% -added some comments
% -changed name of TIMESERIES to TIMESERIES_DATA to avoid confusion with DATA_COMPUTED(i).TIMESERIES
%----------------------------------------

%get sz, which is number of alternatives we are combining (really this
%should be the same for all arrays or else i think this might function
%incorrectly) this also gets the correct size if we are requesting only one
%datatype but haven't specified which one...  keb
sz = max([length(MOLUZ),length(M11),length(MSHE),length(OL),length(M3DSZQ),length(M3DSZ)]);

DATE_I_NUM = datenum(DATE_I);
DATE_F_NUM = datenum(DATE_F);
N_DAYS = DATE_F_NUM - DATE_I_NUM + 1;
TIMEVECTOR = linspace(DATE_I_NUM,DATE_F_NUM,DATE_F_NUM - DATE_I_NUM + 1);
KEYS_STRINGS = {};

% iterate through all model runs and filetypes and get all keys
for i = 1:sz
  try
    K = keys(MOLUZ{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
  try
    K = keys(M11{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
  try
    K = keys(MSHE{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
  try
    K = keys(OL{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
  try
    K = keys(M3DSZQ{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
  try
    K = keys(M3DSZ{i});
    KEYS_STRINGS = [KEYS_STRINGS, K];
  end
end

if length(KEYS_STRINGS) == 0
  fprintf('\nERROR in combine_computed - NO KEYS FOUND FOR COMPUTED DATA\n');
  return;
end

% pull out unique keys for sizing of destination array
NAME_KEYS = unique(KEYS_STRINGS);

ii = 1; %initialize key index since we are iterating through key by name

% iterate through each unique key name
for KEY = NAME_KEYS
    % initialize destination array for # of model runs(+1 for observed data)
    % this will hold data for one station
    TIMESERIES_DATA(1:sz+1,1:N_DAYS) = NaN;

    % and iterate through each of the model runs
    for i = 1:sz

        % initialize array to hold data structure for one key and model run
        TSMERGE(1:N_DAYS) = NaN;
        
        % for each filetype,
        %  copy data for KEY and model run(i) into DATA_TMP 
        %    (contains TIMESERIES,TIMEVECTOR,NAME,DFSTYPE,etc...)
        %  copy key name into NAME(i)
        %  use ts_merge to trim timeseries down to just the dates we want
        %    to analyze (actually probably to expand to greater timeseries,
        %    fill blanks with NaNs
        % NOTE: this assumes that there are no keys common to any of the
        % files, otherwise the timeseries from the first will be overwritten
        try
            DATA_TMP = MOLUZ{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        try
            DATA_TMP = M11{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        try
            DATA_TMP = MSHE{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        try
            DATA_TMP = OL{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        try
            DATA_TMP = M3DSZQ{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        try
            DATA_TMP = M3DSZ{i}(char(KEY));
            TSMERGE = ts_mergeV0(DATA_TMP,DATE_I,DATE_F);
        catch
            %fprintf('... Exception for:\n %s\n', char(KEY));
        end
        
        TIMESERIES_DATA(i,1:N_DAYS) = TSMERGE;
    end % loop over model runs
    
    NAME_MAP(ii) = KEY;

    DATA_COMPUTED(ii).NAME       = KEY;
    DATA_COMPUTED(ii).TIMESERIES = TIMESERIES_DATA;
    DATA_COMPUTED(ii).DFSTYPE    = DATA_TMP.DFSTYPE;
    DATA_COMPUTED(ii).UNIT       = DATA_TMP.UNIT;
    DATA_COMPUTED(ii).TIMEVECTOR = TIMEVECTOR;

    M(ii) = {DATA_COMPUTED(ii)};

    ii = ii + 1; % increment key index
end % loop over keys

fprintf('... combine_computed: Placing computed values in container.\n');
MAP_COMPUTED = containers.Map(NAME_MAP, M);

end
