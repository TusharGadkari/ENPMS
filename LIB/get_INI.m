function [INI] = get_INI(INI) 

fprintf('... ANALYZING SIMULATIONS:\n');
for i = 1:length(INI.MODEL_SIMULATION_SET)
    A = INI.MODEL_SIMULATION_SET{1,i}{1,1};
    B = INI.MODEL_SIMULATION_SET{1,i}{1,2};
    C = INI.MODEL_SIMULATION_SET{1,i}{1,3};
    INI.MODEL_SIMULATION_SET{1,i}{1,1} = [A B '.she - Result Files'];
    fprintf('SIMULATION: %s LEGEND: %s\n', B, C);
end

INI.PATHDIR = INI.ROOT;
INI.MATDIR =  [INI.PATHDIR 'LIB/'];
INI.SCRIPTDIR   = [INI.PATHDIR 'DATA_LATEX/'];
INI.DATADIR = [INI.PATHDIR 'DATA_OBSERVATIONS/'];

INI.MAPXLS = readXLSmonpts(0,INI);
INI.CELL_DEF_FILE_DIR         = INI.DATADIR;
INI.CELL_DEF_FILE_SHEETNAME   = ['data'];
INI.CELL_DEF_FILE_NAME_OL    = {'cells2load-OL'};
INI.CELL_DEF_FILE_NAME_3DSZQ = {'cells2load-3DSZQ'};
INI.CELL_DEF_FILE_NAME_3DSZ  = {'cells2load-3DSZ'};

% Directory to store all analyses
INI.ANALYSIS_DIR = INI.ANALYSIS_PATH;
fprintf('Current directory, all analysis will be stored in: %s\n\n',INI.ANALYSIS_DIR);
INI.ANALYSIS_DIR_TAG = [INI.ANALYSIS_DIR '/' INI.ANALYSIS_TAG];  % postproc directory for postproc run (no edits needed here)
INI.DATA_DIR         = [INI.ANALYSIS_DIR_TAG '/data'];  % data dir in output for extracted matlab files
INI.FIGURES_DIR      = [INI.ANALYSIS_DIR_TAG '/figures'];  % figures dir in output
INI.FIGURES_DIR_TS   = [INI.ANALYSIS_DIR_TAG '/figures/timeseries'];
INI.FIGURES_DIR_EXC  = [INI.ANALYSIS_DIR_TAG '/figures/exceedance'];
INI.FIGURES_DIR_MAPS = [INI.ANALYSIS_DIR_TAG '/figures/maps'];
INI.FIGURES_RELATIVE_DIR = ['../figures']; % the relative path name to figs dir for includegraphics
INI.LATEX_DIR        = [INI.ANALYSIS_DIR_TAG '/latex'];
% The computed and observed timeseries data for the observation locations -
INI.FILESAVE_TS = [INI.ANALYSIS_DIR '/' INI.ANALYSIS_TAG  '/' INI.ANALYSIS_TAG '_TIMESERIES_DATA.MATLAB'];
% The computed and observed statistics data
INI.FILESAVE_STAT = [INI.ANALYSIS_DIR '/' INI.ANALYSIS_TAG  '/' INI.ANALYSIS_TAG   '_TIMESERIES_STAT.MATLAB'];

%---------------------------------------------------------------
% SET UP DIRECTORIES AND SUPPORTING FILES
%---------------------------------------------------------------
if ~exist(INI.ANALYSIS_DIR,'file'),     mkdir(INI.ANALYSIS_DIR), end  % Create analysis directory if it doesn't exist already
if ~exist(INI.ANALYSIS_DIR_TAG,'file'), mkdir(INI.ANALYSIS_DIR_TAG), end  % create postproc directory for postproc run (no edits needed here)
if ~exist(INI.DATA_DIR,'file'),         mkdir(INI.DATA_DIR), end %Create a data dir in output for extracted matlab files
if ~exist(INI.FIGURES_DIR,'file'),      mkdir(INI.FIGURES_DIR), end  %Create a figures dir in output
if ~exist(INI.FIGURES_DIR_TS,'file'),   mkdir(INI.FIGURES_DIR_TS), end
if ~exist(INI.FIGURES_DIR_EXC,'file'),  mkdir(INI.FIGURES_DIR_EXC), end
if ~exist(INI.FIGURES_DIR_MAPS,'file'), mkdir(INI.FIGURES_DIR_MAPS), end
% Set up LaTeX directory and supporting files
if ~exist(INI.LATEX_DIR,'file'),        mkdir(INI.LATEX_DIR);end;

fprintf('DIRECTORIES FOR STORING ANALYSIS:?\n');
fprintf('==========================\n');
fprintf('INI.SCRIPTDIR is %s\n',INI.SCRIPTDIR);
fprintf('INI.LATEX_DIR is %s\n',INI.LATEX_DIR);
fprintf('INI.ANALYSIS_DIR is %s\n',INI.ANALYSIS_DIR);
fprintf('INI.MATDIR is %s\n',INI.MATDIR);
fprintf('==========================\n');
% copyfile([INI.SCRIPTDIR '/latex/headV1.sty'],INI.LATEX_DIR );
% copyfile([INI.SCRIPTDIR '/latex/tail.sty'], INI.LATEX_DIR );
% copyfile([INI.SCRIPTDIR '/latex/blank.jpg'],INI.FIGURES_DIR );
% copyfile([INI.SCRIPTDIR '/latex/blank.bb'], INI.FIGURES_DIR );
% copyfile([INI.SCRIPTDIR '/latex/blank.png'],INI.FIGURES_DIR );
% copyfile([INI.SCRIPTDIR '/latex/figs-station_groups/APrimaryStationGroup.png'],INI.FIGURES_DIR_MAPS );
% copyfile([INI.SCRIPTDIR '/latex/figs-station_groups/BSecondaryStationGroup.png'],INI.FIGURES_DIR_MAPS );
% copyfile([INI.SCRIPTDIR '/latex/figs-station_groups/CBoundaryStationGroup.png'],INI.FIGURES_DIR_MAPS );
% copyfile([INI.SCRIPTDIR '/latex/figs-station_groups/DCanalNetworkStationGroup.png'],INI.FIGURES_DIR_MAPS );

% INI.SELECTED_STATION_LIST = [INI.ANALYSIS_DIR '/' INI.SELECTED_STATION_LIST];
% INI.FILE_OBSERVED = [INI.ANALYSIS_DIR '/' INI.FILE_OBSERVED]; %  all selected stations
% INI.STATION_DATA  = [INI.STATION_DATA INI.STATION_DATA];

INI.NSIMULATIONS = length(INI.MODEL_SIMULATION_SET);
for i = 1:INI.NSIMULATIONS
    MODEL_FULLPATH{i} = INI.MODEL_SIMULATION_SET{i}{1};
    MODEL_ALL_RUNS{i} = INI.MODEL_SIMULATION_SET{i}{2};
    MODEL_RUN_DESC{i} = INI.MODEL_SIMULATION_SET{i}{3};
end

INI.MODEL_ALL_RUNS = MODEL_ALL_RUNS;
INI.MODEL_RUN_DESC = MODEL_RUN_DESC;
INI.MODEL_FULLPATH = MODEL_FULLPATH;

INI.PostProcStartDay_int = double(int32(floor(datenum(INI.ANALYZE_DATE_I))));
INI.PostProcEndDay_int   = double(int32(floor(datenum(INI.ANALYZE_DATE_F))));
INI.NumPostProcDays = (INI.PostProcEndDay_int-INI.PostProcStartDay_int)+1;
INI.PostProcTime_vector   = datevec(linspace(INI.PostProcStartDay_int,INI.PostProcEndDay_int,INI.NumPostProcDays));


% SELECTED_STATION_LIST = [INI.ANALYSIS_DIR '/selected_station_list.txt'];

infile = INI.SELECTED_STATION_LIST;
if (exist(char(infile))~=2)
    %infile = SELECTED_STATION_LIST; 
    infile = [INI.DATADIR 'selected_station_list-MDR.txt']%listALL
    fprintf(' --> missing SELECTED_STATION_LIST\n')
    fprintf(' --> will use the general list in %s\n', infile)
end

INI.SELECTED_STATIONS = get_station_list(infile);

end