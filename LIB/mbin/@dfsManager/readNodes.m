function [x,y,z,c] = readNodes(dm)
%DFSManager/READNODES Read node information from dfs file.
%
%   Read node coordinates and code from dfs file for unstructured files.
%
%   Usage:
%     xyzc         = readNodes(dfs)
%     [x,y,z]      = readNodes(dfs)
%     [x,y,z,c]    = readNodes(dfs)
%
%   Input:
%     dfs          : dfsManager object
%
%   Output:
%     xyzc         : A matrix with 4 columns, with x, y, z coordinates and 
%                    boundary code for each node.
%     x,y,z        : A vector with x, y or z coordinates for each node.
%     code         : A vector with boundary code for each node.
%
%   For regular grids grids the nodes are not available! Use readElmts
%   instead.
%
%   See also:
%      readElmts

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

Nodes = calllib('DFSManLib', 'DMGetNodes',dm.fileid);
if (nargout>1)
  x = Nodes(:,1);
  y = Nodes(:,2);
  z = Nodes(:,3);
  if (nargout>3)
    c = Nodes(:,4);
  end
else
  x = Nodes;
end