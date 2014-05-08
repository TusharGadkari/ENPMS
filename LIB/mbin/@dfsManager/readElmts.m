function [x,y,z] = readElmts(dm,dres)
%DFSManager/READELMTS Read element information from dfs file.
%
%   Read element center coordinates from dfs file.
%
%   Usage, dfsu:
%     xyz     = readElmts(dfs)
%     [x,y,z] = readElmts(dfs)
%
%   Usage, dfs1+2+3:
%     d       = readElmts(dfs,1)   % for equidistant dfs1+2+3 files
%     x       = readElmts(dfs)     % for equidistant dfs1
%     [x,y]   = readElmts(dfs)     % for equidistant dfs2 
%     [x,y,z] = readElmts(dfs)     % for equidistant dfs3
%
%   Inputs:
%     dfs     : dfsManager object
%
%   Outputs:
%     xyz     : a matrix with x, y, z coordinates in column 1, 2 and 3 of
%               the center of the element.
%     x,y,z   : a vector with x, y, z coordinates respectively.
%     d       : a matrix of size 3 x 3 containing:
%                 [ x_start , x_increment , x_count
%                   y_start , y_increment , y_count
%                   z_start , z_increment , z_count ]

%   Not working usages:
%     xyz     = readElmts(dfs)     % for non-equidistant dfs1
%     [x,y,z] = readElmts(dfs)     % for non-equidistant dfs1

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (nargin==1)
  dres = 0;
end

elmts = calllib('DFSManLib', 'DMGetElmts',dm.fileid);

% For dfs1+2+3
if ( 100 <= dm.filetype && dm.filetype <= 199)

  % if dres, just return elmts
  if (dres == 1)
    x = elmts;
    return
  end

  % NOT WORKING - If non equidistant dfs1 file, return coordinates
  if (false && dm.numdims == 1 && norm(elmts(2:end,:)) ~= 0)
    if (nargout == 3)
      x = elmts(:,1);
      y = elmts(:,2);
      z = elmts(:,3);
    else
      x = elmts;
    end
    return
  end

  % Equidistant dfs files
  if (dm.numdims >= 1 && elmts(1,3) ~= 0)
    x = elmts(1,1) + elmts(1,2)*(0:(elmts(1,3)-1))';
  else
    x = [];
  end
  if (dm.numdims >= 2 && elmts(2,3) ~= 0)
    y = elmts(2,1) + elmts(2,2)*(0:(elmts(2,3)-1))';
  else
    y = [];
  end
  if (dm.numdims >= 3 && elmts(3,3) ~= 0)
    z = elmts(3,1) + elmts(3,2)*(0:(elmts(3,3)-1))';
  else
    z = [];
  end
  return
end

% For dfsu files
if (nargout == 3)
  x = elmts(:,1);
  y = elmts(:,2);
  z = elmts(:,3);
else
  x = elmts;
end