function saveAndClose( dm , force)
%DFSManager/SAVEANDCLOSE Save and close dfsManager file.
%
%   File is saved and closed, modified/new data is written to disc. If you
%   do not want to save changes, use close(dfs) instead.
%
%   usage:
%     saveAndClose(dfs)          
%     saveAndClose(dfs,force)
%
%   inputs:
%     dfs    : DFS object
%     force  : if set to 1, forces an overwrite of any existing file
%              without asking the user. Default is zero (ask user
%              before overwriting).
%
%   Note: there is no undo functionality!
%
%   Remark: File is first truly saved when close is issued, therefor there
%   is no seperate save function.

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (nargin == 1)
  force = 0;
end

if (dm.fileid >= 0)
  filename = get(dm,'filename');
  if (~force && exist(filename,'file'))
    button = questdlg(sprintf('File %s exists!\nOverwrite?',filename),'File exists','Yes','Cancel','Cancel');
    if (strcmp(button,'Cancel'))
      return
    end
  end

  calllib('DFSManLib', 'DMSave', dm.fileid, filename);

end

% File is first really saved when close is issued.
close(dm);
