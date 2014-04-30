function val = get(dm, propName)
%DFSManager/GET Get dfsManager properties.
%   Get properties from the specified object and return the value
%
%   get(dfs)            :  prints all get'able properties
%   a = get(dfs)        :  retrieves all get'able properties
%   a = get(dfs,'prop') :  retrieves property named 'prop'

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

%% Collect all getable properties in a struct
if nargin == 1


  val.FileName        = get(dm,'filename');
  if (dm.filetype ~= dm.FILETYPE_MESH)
    val.FileTitle       = get(dm,'filetitle');
    val.FileDescription = get(dm,'filedescription');
  end
  val.Dimensions      = dm.numdims;

  % Item information
  items        = get(dm,'items');
  val.NumItems = size(items,1);
  for i=1:size(items,1)
    val.ItemNames{i,1} = items{i,1};
  end
  val.Items    = items;

  % Time information
  val.TimeAxisType = get(dm,'timeaxistype');
  if (~strcmpi(val.TimeAxisType,dm.TIMEAXISTYPES{dm.TIME_UNDEF+1}))
    val.StartDate    = get(dm,'startdate');
    val.EndDate      = get(dm,'enddate');
    val.TimeStepSec  = get(dm,'timestepsec');
    %val.TimeStep = ???
    val.NumtimeSteps = get(dm,'numtimesteps');
  end

  % Spatial information
  val.Projection         = get(dm,'projection');
  if (dm.filetype==dm.FILETYPE_DFSU_2D || dm.filetype==dm.FILETYPE_DFSU_3D || dm.filetype==dm.FILETYPE_MESH)
    val.NumElmts = get(dm,'numelmts');
    val.NumNodes = get(dm,'numnodes');
  end
  if (dm.filetype==dm.FILETYPE_DFSU_3D)
    val.NumLayers  = get(dm,'numlayers');
  end
  if (100 <= dm.filetype && dm.filetype < 104)
    val.GeographicalOrigin = get(dm,'geographicalorigin');
    val.Orientation        = get(dm,'orientation');
    val.GridOrigin         = get(dm,'gridorigin');
    val.GridSize           = get(dm,'gridsize');
    val.GridSpacing        = get(dm,'gridspacing');
  end

  val.DeleteValue  = get(dm,'deletevalue');

  % File information
  val.FileID       = dm.fileid;

  if nargout==0
    disp(val)
    clear val
  end

%% Return each getable property individually
else
  
  switch lower(propName)
      
    case 'filename'
      val = calllib('DFSManLib', 'DMGetFileName', dm.fileid);
    case 'filetitle'
      val = calllib('DFSManLib', 'DMGetFileTitle', dm.fileid);
    case 'filedescription'
      val = calllib('DFSManLib', 'DMGetFileDescr', dm.fileid);


    % Item information
    case 'numitems'
      items = get(dm,'items');
      val = size(items,1);
    case 'itemnames'
      items = get(dm,'items');
      for i=1:size(items,1)
        val{i,1} = items{i,1};
      end
    case 'items'
      val = calllib('DFSManLib', 'DMGetItemDefs', dm.fileid);

      
    % Time information
    case 'timeaxistype'
      [timeaxistype] = readTemporalDef(dm);
      val = dm.TIMEAXISTYPES{timeaxistype+1};
    case 'startdate'
      [timeaxistype] = readTemporalDef(dm);
      if (timeaxistype ~= dm.TIME_UNDEF)
        [datetime] = readTemporalStartEnd(dm);
        val = datetime(1,:);
      else
        warning('dfsManager:wrongType','Date/Time information is not available for files with undefined time axis type')
        val = [0,0,0,0,0,0];
      end
    case 'enddate'
      [timeaxistype] = readTemporalDef(dm);
      if (timeaxistype ~= dm.TIME_UNDEF)
        [datetime] = readTemporalStartEnd(dm);
        val = datetime(end,:);
      else
        warning('dfsManager:wrongType','Date/Time information is not available for files with undefined time axis type')
        val = [0,0,0,0,0,0];
      end
    case 'timestepsec'
      [timeaxistype] = readTemporalDef(dm);
      if (timeaxistype == dm.TIME_UNDEF)
        warning('dfsManager:wrongType','Timestep information is not available for files with undefined time axis type')
        val = -1;
      elseif (timeaxistype == dm.TIME_NONEQ_CAL || timeaxistype == dm.TIME_NONEQ_REL)
        warning('dfsManager:wrongType','Timestep information is not available for files with non-equidistant time axis type')
        val = -1;
      else
        [timeaxistype,numtimesteps,timestepsec] = readTemporalDef(dm);
        val = timestepsec;
      end
    %case 'timestep'
    case 'numtimesteps'
      [timeaxistype] = readTemporalDef(dm);
      if (timeaxistype == dm.TIME_UNDEF)
        warning('dfsManager:wrongType','Number of timesteps information is not available for files with undefined time axis type');
      end
      [timeaxistype,numtimesteps] = readTemporalDef(dm);
      val = numtimesteps;
    
      
    % Spatial information
    case 'dimensions'
      val = dm.numdims;
    case 'projection'
      val = calllib('DFSManLib', 'DMGetProjection', dm.fileid);
    case 'numelmts'
      if (dm.filetype~=dm.FILETYPE_DFSU_2D && dm.filetype~=dm.FILETYPE_DFSU_3D && dm.filetype~=dm.FILETYPE_MESH)
        warning('dfsManager:wrongType','Number of elements is only valid for files of type dfsu')
        val = -1;
        return;
      end
      val = calllib('DFSManLib', 'DMGetNumElmts', dm.fileid);
    case 'numnodes'
      if (dm.filetype~=dm.FILETYPE_DFSU_2D && dm.filetype~=dm.FILETYPE_DFSU_3D && dm.filetype~=dm.FILETYPE_MESH)
        warning('dfsManager:wrongType','Number of nodes is only valid for files of type dfsu')
        val = -1;
        return;
      end
      val = calllib('DFSManLib', 'DMGetNumNodes', dm.fileid);
    case 'numlayers'
      if (dm.filetype~=dm.FILETYPE_DFSU_3D)
        warning('dfsManager:wrongType','Number of layers is only valid for files of type dfsu 3D')
        val = -1;
        return;
      end
      val = calllib('DFSManLib', 'DMGetNumLayers', dm.fileid);
    case 'geographicalorigin'
      if (dm.filetype~=dm.FILETYPE_DFS0 && dm.filetype~=dm.FILETYPE_DFS1 && dm.filetype~=dm.FILETYPE_DFS2 && dm.filetype~=dm.FILETYPE_DFS3)
        warning('dfsManager:wrongType','Geographical origin is only valid for files of type dfs0+1+2+3')
        val = [0,0];
        return;
      end
      tmp = calllib('DFSManLib', 'DMGetGeoOrigin', dm.fileid);
      val = tmp(1:2);
    case 'orientation'
      if (dm.filetype~=dm.FILETYPE_DFS0 && dm.filetype~=dm.FILETYPE_DFS1 && dm.filetype~=dm.FILETYPE_DFS2 && dm.filetype~=dm.FILETYPE_DFS3)
        warning('dfsManager:wrongType','Orientation is only valid for files of type dfs0+1+2+3')
        val = -1;
        return;
      end
      val = calllib('DFSManLib', 'DMGetOrientation', dm.fileid);
    case 'gridorigin'
      if (100 > dm.filetype || dm.filetype >= 104)
        warning('dfsManager:wrongType','Grid origin is only valid for files of type dfs0+1+2+3')
        val = -1;
        return;
      end
      if (dm.numdims == 0)
        val = 0;
      else
        regsize = calllib('DFSManLib','DMGetRegOrigin', dm.fileid);
        val = regsize(1:0+dm.numdims);
      end
    case 'gridsize'
      if (100 > dm.filetype || dm.filetype >= 104)
        warning('dfsManager:wrongType','Size of grid is only valid for files of type dfs0+1+2+3')
        val = -1;
        return;
      end
      if (dm.numdims == 0)
        val = 1;
      else
        regsize = calllib('DFSManLib','DMGetRegSizes', dm.fileid);
        val = regsize(1:0+dm.numdims);
        % val contains number of points in x and y, not row-col sizes!
      end
    case 'gridspacing'
      if (100 > dm.filetype || dm.filetype >= 104)
        warning('dfsManager:wrongType','Spacing of grid is only valid for files of type dfs0+1+2+3')
        val = -1;
        return;
      end
      if (dm.numdims == 0)
        val = -1;
      else
        tmp = calllib('DFSManLib','DMGetRegSpacing', dm.fileid);
        val = tmp(1:0+dm.numdims);
      end

    case 'deletevalue'
      items = get(dm,'items');
      val = items{1,7};
      
    case 'fileid'
      val = dm.fileid;

    otherwise
      error('dfsManager:propertyError',[propName,' is not a valid dfsManager property'])
  end
end
