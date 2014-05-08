function writeSpatialItemTimestep(dm, itemno, timestepno, data, s, layers)
%DFSManager/WRITESPATIALITEMTIMESTEP Write spatial item and timestep.
%
%   Writes data for one spatial item and one timestep to the dfs file.
%
%   Currently only DFSU 3D file has a spatial item (Z coordinate)
%
%     writeSpatialItemTimestep(dfs, itemno, timestepno, data)
%     writeSpatialItemTimestep(dfs, itemno, timestepno, d, s, layers)
%
%   input:
%       dfs        : dfs file identifyer
%       itemno     : number of item to read. Item numbers start from 1
%       timestepno : numer of time step to read. Time step numbers
%                    start from 0
%       data       : A matrix/vector containing data values.
%       z_bot      : 2D bathymetry, Z coordinate at bottom, node based 
%                    data.
%       s          : 2D surface elevation information, node based data, 
%                    or a constant value.
%       layers     : a vector of relative layers thickness, the number of 
%                    elements in layers becomes the number layers, and the
%                    vector must sum to one. Bottom layer is first.
%
%   Note: Both d and s are node based. Often s comes element based and need
%   to be interpolated to the nodes, using mzCalcNodeValues.
%
%   Note: Data is first written to disc when close(dfs) is called.
%
%   See also: DFSManager/READSPATIALITEMTIMESTEP

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

% Create 3D Z data from s, z_bot, and relative layer thicknesses
if (numel(data) ~= get(dm,'numnodes') && nargin == 6)
  nlayers = numel(layers);
  % find layer boundaries
  layerb = [0 cumsum(layers)];
  % Make them row vectors
  z_bot   = data';
  s       = s';
  % Find total water depth
  h       = s - z_bot;
  h(h<0)  = 0;
  % Create Z coordinate
  Z = repmat(z_bot,nlayers+1,1);
  for i = 1:nlayers+1
    Z(i,:) = z_bot + layerb(i)*h;
  end
  data = Z(:);
end

if (dm.filetype~=dm.FILETYPE_DFSU_3D)
  error(id('noSpatialItem'),'This file does not have a spatial item.');
end

% Check input parameters
if timestepno < 0
  error(id('negativeTimestepNumber'),'timestep number can not be negative');
end
if itemno <= 0
  error(id('nonpositiveItemNumber'),'item number must be positive');
end
if (itemno ~= 1)
  error(id('itemnoOutOfRange'),'Item number is out of range.');
end
if ~isfloat(data)
  error(id('wrongDatatype'),'data must be float/double datatype');
end




calllib('DFSManLib', 'DMSetSpatialItemTimestep',dm.fileid,itemno,timestepno,data);


function str = id(str)
str = ['dfsManager:writeSpatialItemTimestep:' str];
