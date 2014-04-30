function data = readSpatialItemTimestep(dm, itemno, timestepno)
%DFSManager/READSPATIALITEMTIMESTEP Read spatial item for timestep.
%
%   Reads data for one spatial item and one timestep of the dfs file.
%
%   Currently only dfsu 3D files has a spatial item, the Z coordinate.
%
%   data = readSpatialItemTimestep(dfs, itemno, timestepno)
%   data = readItemTimestep(dfs, itemno, timestepno, transpose)
%
%   input:
%      dfs        : dfs file identifyer
%      itemno     : number of spatial item to read, starting from 1.
%      timestepno : numer of time step to read. Time step numbers
%                   start from 0
%   output:
%       data      : A vector/matrix containing data values.
%
%   Data is a matrix with as many columns as number of elements/nodes in
%   2D, and as many rows as number of layers. Note that for node based
%   data, number of layers is one more than for element based data.
%

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error(id('FileNotOpen'),...
    'Empty dfsManager object. File has been closed.')
end

if (dm.filetype~=dm.FILETYPE_DFSU_3D)
  error(id('noSpatialItem'),'This file does not have a spatial item.');
end


% Check input parameters
if timestepno < 0
  error(id('negativeTimestepNumber'),'timestep number can not be negative');
elseif itemno <= 0
  error(id('nonpositiveItemNumber'),'item number must be positive');
elseif (itemno ~= 1)
  error(id('itemnoOutOfRange'),'Item number is out of range.');
else
  data = calllib('DFSManLib', 'DMGetSpatialItemTimestep',dm.fileid,itemno,timestepno);
end

if (dm.filetype == dm.FILETYPE_DFSU_3D)
  numnodes  = get(dm,'numnodes');
  numlayers = get(dm,'numlayers');

  % Reshape node based data
  if (round(numnodes/(numlayers+1))*(numlayers+1) == numel(data))
    data = reshape(data,numlayers+1,round(numnodes/(numlayers+1)));
  end

end  


function str = id(str)
str = ['dfsManager:readSpatialItemTimestep:' str];