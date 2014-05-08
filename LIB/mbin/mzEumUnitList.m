function C = mzEumUnitList()

% mzUnitGetAll depends on the dfsManager
if (~libisloaded('DFSManLib'))
  dfsManager();
end

s = calllib('DFSManLib','DMUnitGetAll');
C = strread(s,'%s','delimiter',';');