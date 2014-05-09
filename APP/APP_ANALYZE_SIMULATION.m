function [] =  A0_INITIALIZE_M_VERIFICATION()
% CHOOSE TAG FOR THIS POSTPROC RUN
INI.ANALYSIS_TAG = 'PHASE3A_ALL';
% CHOOSE BEGIN(I) AND END(F) DATES FOR POSTPROC   % note this makes black pngs for timespan<9 days
INI.ANALYZE_DATE_I = [1996 1 1 0 0 0];
INI.ANALYZE_DATE_F = [2005 12 31 0 0 0];
% CHOOSE WHICH MODULES TO RUN  1=yes, 0=no
A1 = 1 ;A2 = 1; A2a = 1; A3 = 1; A3a = 1; A3exp = 1; A4 = 1; A5 = 1; A6=1; A7=1;
%A1=Load TS, A2=TS stat, A2a=Flows, A3=FIG TS, A3a=BOX PLOT, A4=PE FIG, A5=LATEX
% SET MODELS DIRECTORY 
address = java.net.InetAddress.getLocalHost();
if (regexp(char(address), 'ENP-PC'))
    INI.PATHDIR     = 'N:/ENP/MODELS/';
else
    INI.PATHDIR     = 'N:/ENP/MODELS/';
    
end
path(path,[INI.PATHDIR 'MATLAB/postproc/LIB']);
% ResultDirHome = ['Z:/ENP/MODELS/Result/'];
ResultDirHome = ['N:\PROJ_W_INP\2013_07052013_AG_MDRESERVOIR\PHASE_IIIA\MODEL\ALTERNATIVES\Result\'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHOOSE SIMULATIONS TO BE ANALYZED 
% 1st cell: Results Directory, 2nd cell: simulation run, 3rd cell: legend entry
i = 0; % initialize simulation count
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'V8ND08b', 'V8ND08b'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'V8ND020', 'V8ND020'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'ALT000_BL', 'BL'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'ALT01P_BL_BNP25', 'BL BNP'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'ALT02P_TT_BNP50', 'TT BNP'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'ALT03P_FC_BNP50', 'FC BNP'};
%i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'AGV9004BR200Q0050', 'Reservoir Discarge 50 cfs'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'AGV9004BR200Q0100', 'Reservoir Discarge 100 cfs'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'AGV9004BR200Q0200', 'Reservoir Discarge 200 cfs'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'AGV9004BR200Q0300', 'Reservoir Discarge 300 cfs'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'AGV9004BR200Q5000', 'Reservoir Discarge 500 cfs'};
%i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {ResultDirHome, 'V8050ND', 'ND'};

% STATIONS TO BE ANALYZED/EXTRACTED, the default is to check current dir for selected_station_list.txt
INI.SELECTED_STATION_LIST = 'selected_station_list-MDR.txt'; 
% The observed station data (gets loaded automatically?)
INI.FILE_OBSERVED = 'DATA_OBSERVED20130519.MATLAB'; %  all selected stations
%INI.STATION_DATA   = [datadir '/monptsV14-7.xlsx'];
INI.STATION_DATA   = 'monptsV14-11.xlsx';
% NOT SURE HOW THESE ARE IMPLEMENTED YET:
INI.INCLUDE_OBSERVED      = 'YES'; %Include observed in the output figs and tables. Check if this switch works
INI.COMPUTE_SENSITIVITES  = 'YES'; %Compute statistics and generate tables in Latex? Check if this switch works
INI.MAKE_STATISTICS_TABLE = 'NO'; %Make the statistics tables in Latex
INI.MAKE_EXCEEDANCE_PLOTS = 'YES'; %Generate exceedance curve plots? Also generates the exceedance table.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHOOSE WHICH MODEL/OBS OUTPUT FILE TYPES TO EXTRACT DATA FOR (A1 script only)
% 1=yes, 0=no
INI.LOAD_MOLUZ    = 1;  % Detailed Timeseries stored on UZ/OC timesteps (loads all items)
INI.LOAD_M11      = 1;  % Detailed Timeseries (loads all items)
INI.LOAD_MSHE     = 1;  % Detailed Timeseries (loads all items)
INI.LOAD_OL       = 0;  % Overland dfs2 file (loads cells defined in xls spreadsheet)
INI.LOAD_3DSZ     = 0;  % Saturated zone dfs3 file (loads cells defined in xls spreadsheet)
INI.LOAD_3DSZQ    = 0;  % Saturated zone dfs3 flow file (loads cells defined in xls spreadsheet)

%%%%%%%%%%%%%  INITIALILIZE STRUCTURE INI %%%%%%%%%%%%%%%%%%%
INI = get_INI(INI);
%%%%%%%%%%%%%  RUN SCRIPTS %%%%%%%%%%%%%%%%%%%
if A1 ; A1_load_computed_timeseries(INI); end
if A2 ; A2_generate_timeseries_stat(INI); end
if A2a ; A2a_cumulative_flows(INI); end
if A3 ; A3_create_figures_timeseries(INI); end
if A3a ; A3a_boxmat(INI); end
if A3exp ; A3a_boxmatEXP(INI); end
if A4 ; A4_create_figures_exceedance(INI); end
if A5 ; A5_create_summary_stat(INI); end
if A6; A6_GW_MAP_COMPARE(INI); end
if A7; A7_MDR_SEEPAGE(INI); end
%%%%%%%%%%%%%  END RUN SCRIPTS %%%%%%%%%%%%%%%%%%%
fclose('all');
end

