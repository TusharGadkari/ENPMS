function data = readItemTimestep(dm, itemno, timestepno, transpose)
%DFSManager/READITEMTIMESTEP Read item and timestep in dfs file.
%
%   Reads data for one item and one timestep of the dfs file.
%
%   data = readItemTimestep(dfs, itemno, timestepno)
%   data = readItemTimestep(dfs, itemno, timestepno, transpose)
%
%   input:
%      dfs        : dfs file identifyer
%      itemno     : number of item to read. Item numbers start from 1
%      timestepno : numer of time step to read. Time step numbers
%                   start from 0
%      transpose  : transpose data in x-y before returning it. If net set,
%                   transpose = 1 is used
%
%   output:
%       data      : A vector/matrix containing data values.
%
%   For dfsu 2D files, data will be a vector. For dfsu 3D files, data will
%   be a matrix with as many columns as number of elements/nodes in 2D, and
%   as many rows as number of layers. Note that for node based data, number
%   of layers is one more than for element based data.
%
%   For dfs1, data will be a vector. For dfs2 and dfs3, data will be a 2D
%   or 3D matrix respectively. Note, that the dfs file is row major
%   ordered, while Matlab matrices are column major ordered, hence to get
%   plots correct, a transpose is automatically applied in the x-y
%   direction. You can disable this transpose by setting the transpose
%   argument to 0;

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (nargin < 4)
  transpose = 1;
end

% Check input parameters
if timestepno < 0
  error(id('negativeTimestepNumber'),'timestep number can not be negative');
elseif itemno <= 0
  error(id('nonpositiveItemNumber'),'item number must be positive');
else
  data = calllib('DFSManLib', 'DMGetItemTimestep',dm.fileid,itemno,timestepno);
end

% Specific operations for some of the filetypes
if (dm.filetype == dm.FILETYPE_DFS2)
  % Reshape data
  regsize = get(dm,'gridsize');
  if (prod(regsize) == numel(data))
    data = reshape(data,regsize);
  end
  % Transpose xy dimension (column major order)
  if (transpose)
    data = data';
  end
  
elseif (dm.filetype == dm.FILETYPE_DFS3)
  % Reshape data
  regsize = get(dm,'gridsize');
  if (prod(regsize) == numel(data))
    data = reshape(data,regsize);
  end
  if (transpose)
    % Transpose xy dimension (column major order)
    datasize  = size(data);
    datatrans = zeros(datasize([2 1 3]));
    for il = 1:datasize(3)
      datatrans(:,:,il) = data(:,:,il)';
    end
    data = datatrans;
  end

elseif (dm.filetype == dm.FILETYPE_DFSU_3D)
  numelmts  = get(dm,'numelmts');
  numnodes  = get(dm,'numnodes');
  numlayers = get(dm,'numlayers');
  items     = get(dm,'items');

  % Reshape element based data
  if (items{itemno,4} == 1 && ...
      round(numelmts/numlayers)*numlayers == numel(data))
    data = reshape(data,numlayers,round(numelmts/numlayers));
  end

  % Reshape node based data
  if (items{itemno,4} == 0 && ...
      round(numnodes/(numlayers+1))*(numlayers+1) == numel(data))
    data = reshape(data,numlayers+1,round(numnodes/(numlayers+1)));
  end

end  

function str = id(str)
str = ['dfsManager:readItemTimestep:' str];