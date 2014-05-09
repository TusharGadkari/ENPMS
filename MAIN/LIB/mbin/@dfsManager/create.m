function dm = create(dm)
%DFSManager/CREATE Create file structures.
%
%   Create the file structures and prepares it for data. This must be
%   called when creating a new file, after having added temporal, spatial
%   definitions and items, and before adding data to the file.
%
%   After create(dfs) has been called, no futher items can be added, and
%   temporal and spatial definition can not be changed.
%
%   create(dfs) can not be called twice on the same file.
%
%   Usage:
%     create(dfs)

calllib('DFSManLib','DMCreate',dm.fileid);
