function val = set(dm,varargin)
%DFSManager/SET Set dfsManager properties.
%
%   Set a property of a dfsManager object.
%
%   You can not set all properties that can be retrieved by get. Try
%       a = set(dfs)
%   to see which properties can be set.
%
%   Usage:
%       val = set(dfs,'prop')       Retrieve value for property
%       set(dfs,'prop',val,...)     Set value for property
%       a = set(dfs)                Retrieve all property value pairs
%       set(dfs,a)                  Set all property value pairs
%
%   Note: 
%       Changes are first made to the file when save(dfs) is issued.
%
%   See also set, DFSTSO/GET

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

props = {};
vals  = {};

%% Print all setable properties
if nargin == 1

  % File properties
  val.FileName        = get(dm,'filename');
  if (dm.filetype ~= dm.FILETYPE_MESH)
    %val.FileTitle       = get(dm,'filetitle');
    %val.FileDescription = get(dm,'filedescription');
  end
  %val.ItemNames       = get(dm,'itemnames');
  
  if nargout == 0 
    disp(val);
    clear val;
  end

%% Handle input arguments
elseif (nargin == 2)

  % Read props and vals from structure
  if (isstruct(varargin{1}))
    A = varargin{1};
    props = fieldnames(A);
    for i = 1:length(props)
      vals{i} = (A.(props{i}));
    end
    
  % Property string, return value
  elseif (ischar(varargin{1}))
    val = get(dm,varargin{1});
    return;

  else
    error('dfsManager:UknownPropertyArgument',...
      'Second argument to set is of wrong type.')
  end

else

  % Read property-value pairs
  ip = 0;
  propertyArgIn = varargin;
  while length(propertyArgIn) >= 2,
    ip = ip+1;
    props{ip}     = propertyArgIn{1};
    vals{ip}      = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
  end
end

%% Set property values
for ip = 1:length(props)
  prop = props{ip};
  val  = vals{ip};

  switch lower(prop)

    case 'filename'
      calllib('DFSManLib', 'DMSetFileName', dm.fileid, val);
    case 'filetitle'
      if (dm.filetype == dm.FILETYPE_MESH)
        error('dfsManager:wrongType','FileTitle can not be edited for mesh files')
      end
      warning('dfsManager:notWorking','Setting this property has currently no effect');
      calllib('DFSManLib', 'DMSetFileTitle', dm.fileid, val);
    case 'filedescription'
      if (dm.filetype == dm.FILETYPE_MESH)
        error('dfsManager:wrongType','FileDescription can not be edited for mesh files')
      end
      warning('dfsManager:notWorking','Setting this property has currently no effect');
      calllib('DFSManLib', 'DMSetFileDescr', dm.fileid, val);

%     % Item information
%     case 'itemnames'
%       if (dm.filetype == dm.FILETYPE_MESH)
%         error('dfsManager:wrongType','Items can not be edited for mesh files')
%       end
%       %XXX
%     case 'items'
%       if (dm.filetype == dm.FILETYPE_MESH)
%         error('dfsManager:wrongType','Items can not be edited for mesh files')
%       end
%       %XXX
% 
%     % Time information
%     case 'startdate'
%       [timeaxistype] = readTemporalDef(dm);
%       if (timeaxistype == dm.TIME_UNDEF)
%         error('dfsManager:wrongType','StartDate can not be set for files with undefined time axis type')
%       elseif (timeaxistype == dm.TIME_NONEQ_CAL || timeaxistype == dm.TIME_NONEQ_REL)
%         error('dfsManager:wrongType','StartDate can not be set for files with nonequidistant time axis type')
%       end
%       %XXX
%     case 'timestepsec'
%       [timeaxistype] = readTemporalDef(dm);
%       if (timeaxistype == dm.TIME_UNDEF)
%         error('dfsManager:wrongType','Time step information can not be set for files with undefined time axis type')
%       elseif (timeaxistype == dm.TIME_NONEQ_CAL || timeaxistype == dm.TIME_NONEQ_REL)
%         error('dfsManager:wrongType','Time step information can not be set for files with nonequidistant time axis type')
%       end
%       %XXX
%       
%     case 'projection'
%       %XXX
%     case 'geographicalorigin'
%       if (dm.filetype~=dm.FILETYPE_DFS0 && dm.filetype~=dm.FILETYPE_DFS1 && dm.filetype~=dm.FILETYPE_DFS2 && dm.filetype~=dm.FILETYPE_DFS3)
%         error('dfsManager:wrongType','Geographical origin is only valid for files of type dfs0+1+2+3')
%       end
%       %calllib('DFSManLib', 'DMGetGeoOrigin', dm.fileid);
    case 'orientation'
      if (dm.filetype~=dm.FILETYPE_DFS0 && dm.filetype~=dm.FILETYPE_DFS1 && dm.filetype~=dm.FILETYPE_DFS2 && dm.filetype~=dm.FILETYPE_DFS3)
        error('dfsManager:wrongType','Orientation is only valid for files of type dfs0+1+2+3')
      end
      calllib('DFSManLib', 'DMSetOrientation', dm.fileid, val);
%     case 'gridorigin'
%       if (100 > dm.filetype || dm.filetype >= 104)
%         warning('dfsManager:wrongType','Size of grid is only valid for files of type dfs0+1+2+3')
%       end
%       %calllib('DFSManLib','DMGetRegOrigin', dm.fileid);
%     case 'gridspacing'
%       if (100 > dm.filetype || dm.filetype >= 104)
%         error('dfsManager:wrongType','Spacing of grid is only valid for files of type dfs0+1+2+3')
%       end
%       %calllib('DFSManLib','DMGetRegSpacing', dm.fileid);
% 
%     case 'deletevalue'
%       if (dm.filetype == dm.FILETYPE_MESH)
%         error('dfsManager:wrongType','Delete value can not be edited for mesh files')
%       end

    otherwise
      error('dfsManager:propertyError',['dfsManager property ' prop ' does not exist or cannot be set'])
    
  end
  
  clear val;
  
end
