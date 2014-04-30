function l = listEumTypes(dm)
%DFSMANAGER/LISTEUMTYPES List available EUM Type strings.
%
%   List the EUM types that are available
%
%   Usage:
%       l = listEumTypes(dfs)
%
%   Input:
%       dfs    : DFS object
%
%   Output:
%       l      : A list of all available types
%
%   Example:
%       If you do not have a DFS object, you may use a new empty object as
%       the argument:
%           l = listEumTypes(dfsManager())
%
%   See also DFSMANAGER/listEumUnits, DFSMANAGER/setItemEum

s = calllib('DFSManLib','DMItemTypeGetAll');
if (ischar(s))
  l = strread(s,'%s','delimiter',';');
else
  l = s(:,1);
end