function closeAll( dm )
%DFSManager/CLOSEALL Close all dfsManager files.
%
%   closeAll(dfsManager)
%
%   Closes all open files. You need to have the dfsManager as argument,
%   otherwise closeAll is not called.
%
%   NOTE: Remember to save the file by calling save(dfs) before closing. If
%   not, changes are discarded.


calllib('DFSManLib', 'DMCloseAll');
