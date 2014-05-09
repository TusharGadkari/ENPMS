function C = mzEumItemTypeList()

% mzUnitGetAll depends on the dfsManager
if (~libisloaded('DFSManLib'))
  dfsManager();
end

s = calllib('DFSManLib','DMItemTypeGetAll');
C = strread(s,'%s','delimiter',';');