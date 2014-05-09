function writeBathymetry(dm,data,transpose)
%DFSManager/WRITEBATHYMETRY Write bathymetry data from dfs2+3 file.
%
%   Write bathymetry data for a dfs2+3 file. 
%
%   Only certain dfs2+3 files has a bathymetry, and it will return an error
%   if writing a bathymetry to a file not accepting one.
%
%   data = readBathymetry(dfs)
%   data = readBathymetry(dfs,transpose)
%
%   input:
%      dfs        : dfs file identifyer
%      transpose  : transpose data in x-y before returning it. If net set,
%                   transpose = 1 is used
%
%   output:
%       data      : A matrix containing bathymetry data
%
%   Data is a 2D or 3D matrix for dfs2 and dfs3 respectively. Note, that
%   the dfs file is row major ordered, while Matlab matrices are column
%   major ordered, hence to get plots correct, a transpose is automatically
%   applied in the x-y direction. You can disable this transpose by setting
%   the transpose argument to 0;

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (nargin < 3)
  transpose = 1;
end

if (dm.filetype ~= dm.FILETYPE_DFS2 && dm.filetype ~= dm.FILETYPE_DFS3)
  error(id('noBathymetry'),'Bathymetry only exist for dfs2+3 files')
end

if (dm.filetype == dm.FILETYPE_DFS2)
  % Transpose xy dimension (column major order)
  if (transpose)
    data = data';
  end
  
elseif (dm.filetype == dm.FILETYPE_DFS3)
  if (transpose)
    % Transpose xy dimension (column major order)
    datasize  = size(data);
    datatrans = zeros(datasize([2 1 3]));
    for il = 1:datasize(3)
      datatrans(:,:,il) = data(:,:,il)';
    end
    data = datatrans;
  end
end

calllib('DFSManLib', 'DMSetBathymetry',dm.fileid,data);




function str = id(str)
str = ['dfsManager:readBathymetry:' str];
