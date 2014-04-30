function [Elmts] = readElmtNodeConnectivity(dm)
%DFSManager/READELMTNODECONNECTIVITY Read element-node connectivity.
%
%   Read element-node connectivity, also called the element table, i.e.,
%   which nodes belongs to each element
%
%   Elmts = readElmtNodeConnectivity(dfs)
%
%   The result is a matrix having number-of-element rows and
%   nodes-in-element columns. For triangulated 2D data, Elmts is a
%   triangulation as returned by delaunay. For triangulated layered 3D
%   data, Elmts will have 6 columns. For mixed meshes, Elmts will have 4 or
%   8 columns for 2D and 3D respectively.
%
%   NOTE: This function can not be used for dfs0,1,2,3 files.

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

Elmts = calllib('DFSManLib', 'DMGetElmtNodeConnectivity',dm.fileid);
