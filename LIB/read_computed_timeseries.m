function [MAP_COMPUTED_DFS] = read_computed_timeseries(FILE_DFS,CELL_DEF_FILE_DIR,CELL_DEF_FILE_SHEETNAME,CELL_DEF_FILE_NAME);

%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% This function will open dfs0, dfs2, and dfs3 files and read data within.
% Extracts data for stations defined in CELL_DEF_FILE (an Excel spreadsheet - details in function 'get_cells_from_xls'
% Files are read for all timesteps but only DAILY values are saved.
% Units are converted here - see ~line 184
% It saves the data in a container called MAP_COMPUTED_DFS.
% Can read dfs3 files but is HARDCODED to read only the FIRST LAYER.
% 
% ARGUMENTS:
% FILE_DFS: file containing timeseries data you want to extract
% (optional)CELL_DEF_FILE_DIR: directory containing file CELL_DEF_FILE_NAMES
% (optional)CELL_DEF_FILE_SHEETNAME: Sheet within CELL_DEF_FILE_NAMES your cell data is in
% (optional)CELL_DEF_FILE_NAME: Excel spreadsheet specifying cells you want data for
% MAP_COMPUTED_DFS: container with station names for keys and timeseries and metadata as values
%
% EXAMPLES:
% dfs0 example: read_computed_timeseries(FILE_MSHE)
% dfs2 example: read_computed_timeseries(FILE_OL,INI.CELL_DEF_FILE_DIR,INI.CELL_DEF_FILE_SHEETNAME,CELL_DEF_FILE_NAMES)
% dfs2 example: read_computed_timeseries(FILE_OL,datadir,['data'],{'cells2load-3DSZ'})
%
% BUGS:
% -needs to be fixed so can read all layers of dfs3 files (this is fixed in get_dfs23_timeseries_v0.m)
%
% COMMENTS:
%
%----------------------------------------
% REVISION HISTORY:
%
% changes introduced to v1:  (keb 8/2011)
%  -uses the 2011 version of the DHI MATLAB Toolbox instead of 2008 version.
%  -added function 'get_dfs23_timeseries_v0' to process dfs2 and dfs3 files
%  -added function 'get_cells_from_xls_v0' to read .xls cell list of desired cells to extract
%   from dfs2 and dfs3 files
%  -added working area at end of script
%
% changes introduced to v2:  (keb 10/2011)
%  -removed INI.PostProcTimeVector input argument - now extracts entire time series present in file
%   (I checked and it takes the same amount of time to extract 1 day as 1
%   year - the time commitment seems to depend on number of
%   stations requested... it is possible some looping order needs to be
%   rearranged, didn't check)
%  -added code to create and save DfsTimeVector
%  -added/edited comments
%  -changed variable name CELL_DEF_FILE_NAMES to CELL_DEF_FILE_NAME
%
% FUTURE REVISIONS:
% -keb: plan to add functionality to read res11 files (some code written and in working area below)
% -keb: plan to add functionality to read dfs2&3 files with no time axis (this could become fixed/irrelevant in v2 - didn't check yet)
% -keb: should probably make unit conversions explicit or part of input arguments somehow
% -keb: might be nice to use text files instead of Excel spreadsheets (k.i.s.s.)
%----------------------------------------

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

FT2M = 0.3048;
CFS2M3 = (0.3048^3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 1: try opening file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find file type: dfs0 or dfs2 or dfs3
ns = length(FILE_DFS);
MyFileExtension = FILE_DFS(ns-4:ns);

% try to open file with appropriate utility, get spatial dimension
try
   if strcmp(MyFileExtension,'.dfs0')
      import DHI.Generic.MikeZero.DFS.dfs0.*;
      MyDfsFile=DfsFileFactory.DfsGenericOpen(FILE_DFS);
      MyDfsFileDim = MyDfsFile.ItemInfo.Item(0).SpatialAxis.Dimension;
   elseif strcmp(MyFileExtension,'.dfs2') 
      MyDfsFile=DfsFileFactory.Dfs2FileOpen(FILE_DFS);
      MyDfsFileDim = MyDfsFile.SpatialAxis.Dimension;
   elseif strcmp(MyFileExtension,'.dfs3') 
      MyDfsFile=DfsFileFactory.Dfs3FileOpen(FILE_DFS);
      MyDfsFileDim = MyDfsFile.SpatialAxis.Dimension;
   else
      MAP_COMPUTED_DFS = containers.Map;  % return an empty structure
      fprintf('\nWARNING - file extension not .dfs0, .dfs2, or .dfs3: %s\n', char(FILE_DFS));
      return;
   end
catch
   MAP_COMPUTED_DFS = containers.Map;  % return an empty structure
   fprintf('\nWARNING - FILE NOT FOUND or DfsFileFactory CANNOT OPEN FILE: %s - skipping\n', char(FILE_DFS));
   return;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 2: read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('...%s: Reading file: %s\n', datestr(now), char(FILE_DFS));

%---------------------------------------------------------------
% dfs0 files: read ALL items and ALL timesteps in file
%---------------------------------------------------------------
if MyDfsFileDim == 0
   % Use the Dfs0Util for bulk-reading all data and timesteps
   % Data is 2-D array with times as first item, and item values after
   % THIS is HARDCODED to read ALL timesteps from file. So far it still goes fast, so maybe no need to fix.
   AllFileData = double(Dfs0Util.ReadDfs0DataDouble(MyDfsFile)); % read all data in file
   
   TimeseriesData = AllFileData(:,2:end); % parse out item timeseries data from array
   TimesInSeconds = AllFileData(:,1);     % parse out timestamp array (seconds since startdate)

   % set up station name array
   num_stns = MyDfsFile.ItemInfo.Count;
   for i=1:num_stns
      MyRequestedStnNames(:,i) = {char(MyDfsFile.ItemInfo.Item(i-1).Name)};
   end
   
   % set up start date vector
   sd=MyDfsFile.FileInfo.TimeAxis.StartDateTime;
   dfsstartdatetime=datenum(double([sd.Year sd.Month sd.Day sd.Hour sd.Minute sd.Second]));
   
   % transfer timestamp array (in seconds since startdate) to time vectors
   for t=1:length(TimesInSeconds)
      DfsTime = datenum(double([0 0 0 0 0 TimesInSeconds(t)]));
      DfsTimeVector(t,:) = datevec(DfsTime + dfsstartdatetime);
   end
   
%---------------------------------------------------------------------
% dfs2 and dfs3 files: read SELECTED items and ALL timesteps in file
%---------------------------------------------------------------------
elseif MyDfsFileDim == 2 || MyDfsFileDim == 3
   
   % read excel file of cells
   [MyRequestedStnNames,MyRequestedStns] = get_cells_from_xls_v0(...
      CELL_DEF_FILE_DIR,CELL_DEF_FILE_SHEETNAME,CELL_DEF_FILE_NAME);
   
   % get vector of system.datetime-type timesteps in dfs file
   dfstimes=DfsExtensions.GetDateTimes(MyDfsFile.FileInfo.TimeAxis);

   % get number of timesteps in file
   NumDfsSteps = double(MyDfsFile.FileInfo.TimeAxis.NumberOfTimeSteps);

   % transfer system.datetime-type timestamp array to datetime-type vectors
   for t=1:NumDfsSteps
      MyDateTime=dfstimes(t);
      thistimestep=datenum(double([MyDateTime.Year MyDateTime.Month MyDateTime.Day MyDateTime.Hour MyDateTime.Minute MyDateTime.Second]));
      DfsTimeVector(t,:) = datevec(thistimestep);
   end

   %extract selected timeseries data for entire timeperiod from dfs file
   [TimeseriesData] = get_dfs23_timeseries_v0(MyDfsFile,MyRequestedStns,1,NumDfsSteps);
   [num_stns,trash] = size(MyRequestedStns);
   
  
%---------------------------------------------------------------
% if file dimension is not 0, 2, or 3, print error and exit
%---------------------------------------------------------------
else
    fprintf('ERROR: File not determined to be DFS0, DFS2 or DFS3: %s ', FILE_DFS);
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 3: save data structure arrays into container and exit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_dfs_steps = length(DfsTimeVector);
dfs_day_begin = floor(datenum(DfsTimeVector(1,:)));
dfs_day_end   = floor(datenum(DfsTimeVector(num_dfs_steps,:)));
num_dfs_days  = dfs_day_end - dfs_day_begin;
%DfsDatesVector = datevec(linspace(dfs_day_begin,dfs_day_end,num_dfs_days));
DfsDatesVector = datevec([dfs_day_begin:dfs_day_end]);
%DfsDatesVector = int32(DfsTimeVector); % The purpose of DfsDatesVector is not clear, seems it has to be DfsTimeVector

for i=1:num_stns
      
      % get item metadata
      if MyDfsFileDim == 0
         myitem = i;
      elseif MyDfsFileDim == 2 || MyDfsFileDim == 3
         myitem = MyRequestedStns{i,4};
      end
      
      DFSTYPE = char(MyDfsFile.ItemInfo.Item(myitem-1).Quantity.ItemDescription);
      UNIT  =   char(MyDfsFile.ItemInfo.Item(myitem-1).Quantity.UnitDescription);
      iNAME =  MyRequestedStnNames(i);
      
      % put data into a 1-D array for get_daily_data function
      D = TimeseriesData(:,i);
      
      % convert units
      if strcmp(UNIT,'m^3/s'), D = D/CFS2M3; UNIT = 'ft^3/s'; end;
      if strcmp(UNIT,'meter'), D = D/FT2M;   UNIT = 'feet';   end;
      
      % extract daily values
      D_DAILY = get_daily_data(D,DfsTimeVector,num_dfs_days);
      
      % save info in DATA_COMPUTED structure
      DATA_COMPUTED(i).TIMESERIES = D_DAILY;
      DATA_COMPUTED(i).NAME = {iNAME};
      DATA_COMPUTED(i).DFSTYPE = DFSTYPE;
      DATA_COMPUTED(i).UNIT = UNIT;
      DATA_COMPUTED(i).TIMEVECTOR = DfsDatesVector;
      
      % prep data to be saved into container
      NAME(i) = iNAME; %keys
      MAP_SIM(i) = {DATA_COMPUTED(i)}; %cells containing structures
end

fprintf('...%s: Closing file: %s\n', datestr(now), char(FILE_DFS));
MyDfsFile.Close(); 

% save data into container
MAP_COMPUTED_DFS = containers.Map(NAME,MAP_SIM);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kiren's working area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------------
%---------------------------------------------------------------
%---------------------------------------------------------------
% res11 stuff:
%---------------------------------------------------------------
%---------------------------------------------------------------
%---------------------------------------------------------------
%    elseif strcmp(MyFileExtension,'res11') 
%       MyDfsFileDim = 11;
% 
% %---------------------------------------------------------------
% % res11 files: 
% %---------------------------------------------------------------
% if MyDfsFileDim == 11
%    % Data to extract, quantity, branch name and chainages
%    extractPoints{1}.branchName = 'C-111';
%    extractPoints{1}.quantity = 'Water Level';
%    extractPoints{1}.chainages = [0,14,90,90,156,3767,8977,9008,9925,14323,15129,15129,17685,18490,18540,19438,23378,23378,26876,26876,28259,28415];
%    extractPoints{2}.branchName = 'C-111';
%    extractPoints{2}.quantity = 'Discharge';
%    extractPoints{2}.chainages = [8,52,123,1962,6372,8992,9466,12124,14726,16407,18087,18517,18989,21408,25127,27568,28335];
% 
%    [values, outInfos] = res11read(FILE_DFS, extractPoints);
%       
