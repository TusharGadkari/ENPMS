function close( dm )
%DFSManager/CLOSE Close dfsManager file without saving changes.
%
%   Close a dfs file without saving changes.
%
%   usage:
%     close( dfs )
%
%   Closes a dfsManager object, and releases memory storage associated with
%   the object, but does not save changes made to the dfs file.
%
%   NOTE: Use saveAndClose(dfs) if you want to save the changes to the
%   file.

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  warning('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (dm.fileid >= 0)
  calllib('DFSManLib', 'DMClose', dm.fileid);
  dm.fileid = -1;
end
