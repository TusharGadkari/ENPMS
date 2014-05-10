function A1_load_computed_timeseries(INI)


fprintf('\n\n Beginning A1_load_computed_timeseries: %s \n\n',datestr(now));
format compact

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the file with elevation data
% MAP_ELEVATIONS are stored in the .matlab file
% % fprintf('... Loading elevations:\n %s\n', char(INI.FILE_ELEVATION));
% % load(INI.FILE_ELEVATION,'-mat');

%load the file with observed data
FILE_OBSERVED = INI.FILE_OBSERVED;
fprintf('... Loading observed data from file:\n\t %s\n', char(INI.FILE_OBSERVED));
DATA_OBSERVED = load(FILE_OBSERVED, '-mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read all files as specified in MODEL_ALL_RUNS and make a structure 
%for each station. The structures are stored in a map with station name as
%MAP KEY and computed+observed data as MAP VALUE. The structure is accessed
%by providing the key as a character string e.g. D = MAP_ALL_DATA('NP205')

i = 1;
for D = INI.MODEL_ALL_RUNS % iterate over selected model runs
   MODEL_RESULT_DIR = INI.MODEL_FULLPATH{i};

   FILE_MOLUZ         = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_OL.dfs0'];
   FILE_M11           = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_M11.dfs0'];
   FILE_MSHE          = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_SZ.dfs0'];
   FILE_OL            = [MODEL_RESULT_DIR '/' char(D) '_overland.dfs2'];          
   FILE_3DSZ          = [MODEL_RESULT_DIR '/' char(D) '_3DSZ.dfs3'];              
   FILE_3DSZQ         = [MODEL_RESULT_DIR '/' char(D) '_3DSZflow.dfs3'];          

   if INI.LOAD_MOLUZ
      MAP_COMPUTED_MOLUZ = {read_computed_timeseries(FILE_MOLUZ)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MOLUZ.MATLAB'],'MAP_COMPUTED_MOLUZ', '-v7.3');
      MAP_COMPUTED_MOLUZ_DATA(i) = MAP_COMPUTED_MOLUZ;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MOLUZ.MATLAB'],'-mat'); 
         MAP_COMPUTED_MOLUZ_DATA(i)=MAP_COMPUTED_MOLUZ;
      catch
         MAP_COMPUTED_MOLUZ_DATA(i) = {0};
      end;
   end
   
   if INI.LOAD_M11
      MAP_COMPUTED_M11 = {read_computed_timeseries(FILE_M11)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_M11.MATLAB'],'MAP_COMPUTED_M11', '-v7.3');
      MAP_COMPUTED_M11_DATA(i) = MAP_COMPUTED_M11;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_M11.MATLAB'],'-mat'); 
         MAP_COMPUTED_M11_DATA(i)=MAP_COMPUTED_M11;
      catch
         MAP_COMPUTED_M11_DATA(i) = 0;
      end;
   end
   
   if INI.LOAD_MSHE
      MAP_COMPUTED_MSHE = {read_computed_timeseries(FILE_MSHE)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MSHE.MATLAB'],'MAP_COMPUTED_MSHE', '-v7.3');
      MAP_COMPUTED_MSHE_DATA(i) = MAP_COMPUTED_MSHE;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MSHE.MATLAB'],'-mat'); 
         MAP_COMPUTED_MSHE_DATA(i)=MAP_COMPUTED_MSHE;
      catch
         MAP_COMPUTED_MSHE_DATA(i) = 0;
      end;
   end
   
   
   if INI.LOAD_OL
      MAP_COMPUTED_OL = {read_computed_timeseries(FILE_OL,INI.CELL_DEF_FILE_DIR,INI.CELL_DEF_FILE_SHEETNAME,INI.CELL_DEF_FILE_NAME_OL)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_OL.MATLAB'],'MAP_COMPUTED_OL', '-v7.3');
      MAP_COMPUTED_OL_DATA(i) = MAP_COMPUTED_OL;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_OL.MATLAB'],'-mat'); 
         MAP_COMPUTED_OL_DATA(i)=MAP_COMPUTED_OL;
      catch
         MAP_COMPUTED_OL_DATA(i) = {0};
      end;
   end
   
   if INI.LOAD_3DSZQ
      MAP_COMPUTED_3DSZQ = {read_computed_timeseries(FILE_3DSZQ,INI.CELL_DEF_FILE_DIR,INI.CELL_DEF_FILE_SHEETNAME,INI.CELL_DEF_FILE_NAME_3DSZQ)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZQ.MATLAB'],'MAP_COMPUTED_3DSZQ', '-v7.3');
      MAP_COMPUTED_3DSZQ_DATA(i) = MAP_COMPUTED_3DSZQ;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZQ.MATLAB'],'-mat'); 
         MAP_COMPUTED_3DSZQ_DATA(i)=MAP_COMPUTED_3DSZQ;
      catch
         MAP_COMPUTED_3DSZQ_DATA(i) = {0};
      end;
   end
   
   
   if INI.LOAD_3DSZ
      MAP_COMPUTED_3DSZ = {read_computed_timeseries(FILE_3DSZ,INI.CELL_DEF_FILE_DIR,INI.CELL_DEF_FILE_SHEETNAME,INI.CELL_DEF_FILE_NAME_3DSZ)};
      if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
      save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZ.MATLAB'],'MAP_COMPUTED_3DSZ', '-v7.3');
      MAP_COMPUTED_3DSZ_DATA(i) = MAP_COMPUTED_3DSZ;
   else
      try 
         load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZ.MATLAB'],'-mat'); 
         MAP_COMPUTED_3DSZ_DATA(i)=MAP_COMPUTED_3DSZ;
      catch
         MAP_COMPUTED_3DSZ_DATA(i) = {0};
      end;
   end
   
   i = i + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combine all above data arrays into one container, and trim or expand dates to
% requested start-end times

MAP_COMPUTED = combine_computed(...
   MAP_COMPUTED_MOLUZ_DATA, ...
   MAP_COMPUTED_M11_DATA, ...
   MAP_COMPUTED_MSHE_DATA, ...
   MAP_COMPUTED_OL_DATA, ...
   MAP_COMPUTED_3DSZQ_DATA, ...
   MAP_COMPUTED_3DSZ_DATA, ...
   INI); 
%   INI.ANALYZE_DATE_I, INI.ANALYZE_DATE_F); %for new - CHANGE TO DFS BEGINDAY AND DFS END DAY%
% fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum up computed data for flowlines or combined station groups
MAP_COMPUTED = combine_modeled_timeseries(MAP_COMPUTED);
% fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add observed data and elevations to container if we extracted them
MAP_ALL_DATA = add_observed(INI,MAP_COMPUTED,DATA_OBSERVED.DATA);
% fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum up observed data for flowlines or combined station groups
obs_index = INI.NSIMULATIONS + 1;
MAP_ALL_DATA = combine_observed_timeseries_v0(MAP_ALL_DATA,obs_index);
% fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save the structures which are subsequently used in other postprocessing
%scripts. The data are accessed using load(INI.FILESAVE_TS);

fprintf('\n... Creating and saving data file:\n\t %s\n', char(INI.FILESAVE_TS));
save(INI.FILESAVE_TS,'MAP_ALL_DATA', '-v7.3');

end


