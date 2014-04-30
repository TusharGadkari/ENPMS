function dm = dfsManager( a , create, ndim)
%DFSManager Create new dfsManager.
%
%   opens a new DFS file using filename and returns an object for handling
%   the file.
%
%   Usage:
%      dfs = dfsManager( filename )
%      dfs = dfsManager( filename , createnew)           % for dfs1+2+3
%      dfs = dfsManager( filename , createnew, datatype) % for dfs1+2+3
%      dfs = dfsManager( filename , createnew, ndim)     % for 3D dfsu
%
%   Inputs:
%      filename  : name of file
%      datatype  : Data type of the dfs file. If not set, 0 is used
%      createnew : Set to 1 if creating new file
%
%   Outputs:
%      dfs       : A matlab object holding the file
%
%   Note:
%      It is currently only possible to create dfs0 files, using the DFSTSO
%      object. 

% Copyright DHI 
% Version 0.4, 2007-11-21, JGR

% Assuming:
%  - equidistant time axis

if nargin >= 1 && isa(a,'dfsManager')
  dm = a;
  return;
end

if (nargin < 2)
  create = 0;
end

if (nargin < 3)
  datatype = 0;
else
  datatype = ndim;
end


% Define constants
% File constants are used in MatlabDM.dll
dm.FILETYPE_UNDEF   =  -1;
dm.FILETYPE_MESH    = 10;  % Experimental: Read, write, create support !!!
dm.FILETYPE_DFS0    = 100; % Supported by dfsTSO class
dm.FILETYPE_DFS1    = 101; % Read support, write, missing create
dm.FILETYPE_DFS2    = 102; % Read support, write, missing create
dm.FILETYPE_DFS3    = 103; % Read support, write, missing create
dm.FILETYPE_DFSU    = 200; % Preliminary type only
dm.FILETYPE_DFSU_2D = 202; % Read, write support, missing create
dm.FILETYPE_DFSU_3D = 203; % Read, write support, missing create
% Time axis constants, matching CTemporalDef.eTemporalAxisType
dm.TIME_UNDEF       = 0;   % Time axis undefined
dm.TIME_EQ_REL      = 1;   % Time axis equidistant relative time
dm.TIME_NONEQ_REL   = 2;   % Time axis non-equidistant relative time
dm.TIME_EQ_CAL      = 3;   % Time axis equidistant calendar time
dm.TIME_NONEQ_CAL   = 4;   % Time axis non-equidistant calendar time
dm.TIMEAXISTYPES    = {    % String names of time axis types
  'undefined';
  'Equidistant_Relative';
  'Non_Equidistant_Relative';
  'Equidistant_Calendar';
  'Non_Equidistant_Calendar'};

% Variables in object (new/empty file parameters)
dm.fileid           = -1; % Unique integer for the MatlabDM.dll
dm.filetype         = dm.FILETYPE_UNDEF;
dm.numdims          = -1;

filename = '';

if (nargin == 0)

elseif (nargin >= 1 && ischar(a))
   filename = a;
else
  error(id('InvalidArguments'),'Invalid input arguments - must be a string with a filename');
end


% Figure out file type
if     (strcmp(filename,''))
  
elseif (strfind(filename,'.mesh'))
  dm.numdims  = 2;
  dm.filetype = dm.FILETYPE_MESH;

elseif (strfind(filename,'.dfs0'))
  % Let the dfsTSO object handle dfs0 files
  error(id('dfs0UseTSO'),'dfs0 not supported by dfsManager, use dfsTSO instead');
%   if nargin == 1
%     dm = dfsTSO(filename);
%   else
%     dm = dfsTSO(filename,create);
%   end
%   return;

  dm.numdims  = 0;
  dm.filetype = dm.FILETYPE_DFS0;
  
elseif (strfind(filename,'.dfs1'))
  dm.numdims  = 1;
  dm.filetype = dm.FILETYPE_DFS1;
  
elseif (strfind(filename,'.dfs2'))
  dm.numdims  = 2;
  dm.filetype = dm.FILETYPE_DFS2;
  
elseif (strfind(filename,'.dfs3'))
  dm.numdims  = 3;
  dm.filetype = dm.FILETYPE_DFS3;
  
elseif (strfind(filename,'.dfsu'))
  dm.numdims  = -1;
  dm.filetype = dm.FILETYPE_DFSU;

else
  error(id('UnsupportedFileType'),'filetype is not supported (%s)',filename);
end


  
% Load library, if not already loaded, for all but dfs0 files
if (~libisloaded('DFSManLib'))

  DFSManPath    = fileparts(which('dfsManager'));
  DFSManLibPath = [DFSManPath '\lib'];
  MatlabDMdll   = [DFSManLibPath '\MatlabDM.dll'];
  %MatlabDMh     = [DFSManLibPath '\MatlabDM.h'];

  debug = 0;
  %MatlabDMdllDev= 'C:\Work\main\Products\Source\Matlab\MatLabDM\MatLabDM\Release\MatlabDM.dll';
  MatlabDMdllDev= 'C:\Work\main\Products\Source\Matlab\MatLabDM\MatLabDM\Debug\MatlabDMd.dll';
  %MatlabDMhDev  = 'C:\Work\main\Products\Source\Matlab\MatLabDM\MatLabDM\MatlabDM.h';

  if (exist(MatlabDMdll,'file') == 2)
  elseif (exist(MatlabDMdllDev,'file') == 2)
    debug = true;
    MatlabDMdll = MatlabDMdllDev;
  else
    error(id('LibNotFoundDLL'),'Can not find dfsManager library dll (MatlabDM.dll)')
  end

%   if (exist(MatlabDMh,'file') == 2)
%   elseif (exist(MatlabDMhDev,'file') == 2)
%     debug = true;
%     MatlabDMh = MatlabDMhDev;
%   else
%     error(id('LibNotFoundH'),'Can not find dfsManager library header file (MatlabDM.h)')
%   end

  if (debug)
    fprintf( 'DEBUG: Loading MatlabDM library.\n');
    fprintf(['DEBUG: Using library:\n'...
             '       MatlabDMdll = %s\n'],MatlabDMdll);
  end
  
  warning('off','MATLAB:loadlibrary:cppoutput');
  %[notfound,warnings] = loadlibrary(MatlabDMdll,MatlabDMh,'alias','DFSManLib');
  %[notfound,warnings] = loadlibrary(MatlabDMdll,@MatlabDM,'alias','DFSManLib');
  [notfound,warnings] = loadlibrary(MatlabDMdll,@dfsManTest,'alias','DFSManLib');
  warning('on','MATLAB:loadlibrary:cppoutput');

end


% Generic operations for all file types
if (nargin >= 1 && ischar(a))
  if (~create)
    if (exist(filename,'file'))
      dm.fileid = calllib('DFSManLib', 'DMOpen',filename,dm.filetype);
    else
      error(id('FileNotFound'),'file not found: %s\n',filename);
    end
  else
    if (dm.filetype == dm.FILETYPE_DFSU)
      if ndim == 2
        dm.filetype = dm.FILETYPE_DFSU_2D;
        dm.numdims  = 2;
      elseif ndim == 3
        dm.filetype = dm.FILETYPE_DFSU_3D;
        dm.numdims  = 3;
      else
         error(id('inputError'),'Dimension must be 2 or 3');
      end
    end
    dm.fileid   = calllib('DFSManLib','DMCreateSkeleton',filename,dm.filetype,datatype);
  end
end


% Speciel operations for each file type
if dm.filetype == dm.FILETYPE_DFSU
  dm.numdims  = calllib('DFSManLib', 'DMGetNumDims', dm.fileid);
  if     (dm.numdims == 2)
    dm.filetype = dm.FILETYPE_DFSU_2D;
  elseif (dm.numdims == 3) 
    dm.filetype  = dm.FILETYPE_DFSU_3D;
  else
    error(id('dfsuFileInvalid'),'dfsu file of dimension %i is not supported',dm.numdims);
  end
  
elseif dm.filetype == dm.FILETYPE_DFS1

elseif dm.filetype == dm.FILETYPE_DFS2

elseif dm.filetype == dm.FILETYPE_DFS3

end


dm = class(dm,'dfsManager');


function str = id(str)
str = ['dfsManager:dfsManager:' str];