function writeItemTimestep(dm, itemno, timestepno, data, transpose)
%DFSManager/WRITEITEMTIMESTEP Write item and timestep to dfs file.
%
%   Writes data for one item and one timestep to the dfs file.
%
%   writeItemTimestep(dfs, itemno, timestepno, data)
%
%   input:
%       dfs        : dfs file identifyer
%       itemno     : number of item to read. Item numbers start from 1
%       timestepno : numer of time step to read. Time step numbers
%                    start from 0
%       data       : A matrix/vector containing data values.
%       transpose  : transpose data in x-y before saving it. If not set,
%                    transpose = 1 is used
%
%   For all dfs file formats, data must be shaped as if it was read by
%   readItemTimestep.
%
%   Note: Data for dfs2+3 read with the transpose option must be written
%   with the same transpose option. See readItemTimestep for details.
%
%   Note: Data is first written to disc when close(dfs) is called.

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (nargin < 5)
  transpose = 1;
end

% Check input parameters
if timestepno < 0
  error(id('negativeTimestepNumber'),'timestep number can not be negative');
elseif itemno <= 0
  error(id('nonpositiveItemNumber'),'item number must be positive');
elseif ~isfloat(data)
  error(id('wrongDatatype'),'data must be float/double datatype');
else
  if (dm.filetype == dm.FILETYPE_DFS2)
    % Check shape of data
    gridsize = get(dm,'gridsize');
    datasize = size(data);
    if (numel(data) ~= prod(gridsize))
      error(id('dimensionMismatch'),'Dimension mismatch');
    end
    % If shape is column major, transpose
    if ( (sum(datasize-gridsize([2,1])) == 0) && transpose)
      data = data';
    end
  elseif (dm.filetype == dm.FILETYPE_DFS3)
    % Check shape of data
    gridsize = get(dm,'gridsize');
    datasize = size(data);
    if (numel(data) ~= prod(gridsize))
      error(id('dimensionMismatch'),'Dimension mismatch');
    end
    % If shape is column major order, transpose to row major order.
    if ( (sum(datasize([1,2])-gridsize([2,1])) == 0) && transpose)
      datanew = zeros(datasize([2,1,3]));
      for i = 1:datasize(3)
        datanew(:,:,i) = data(:,:,i)';
      end
      data = datanew;
    end
  end

  calllib('DFSManLib', 'DMSetItemTimestep',dm.fileid,itemno,timestepno,data);
end


function str = id(str)
str = ['dfsManager:writeItemTimestep:' str];