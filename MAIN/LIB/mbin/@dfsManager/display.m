function display( dm )
%DFSManager/DISPLAY Command window display of DFS file.
%
% Prints information of dfs file to the display.
%
% Called whenever a dfs id is entered at the command prompt, or returned
% from a function.

disp([inputname(1),' = '])

if (dm.fileid < 0)
  fprintf('   Empty dfsManager object. Not initialized\n');
  return
elseif (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  fprintf('   Empty dfsManager object. File has been closed.\n');
  return
end

fprintf('   filename            : %s\n',get(dm,'filename'));

% Spatial information
fprintf('   dimensions          : %i\n',dm.numdims);
if (dm.filetype==dm.FILETYPE_DFSU_2D || dm.filetype==dm.FILETYPE_DFSU_3D || dm.filetype==dm.FILETYPE_MESH)
fprintf('   number of nodes     : %i\n',get(dm,'numnodes'));
fprintf('   number of elmts     : %i\n',get(dm,'numelmts'));
end
if (dm.filetype==dm.FILETYPE_DFSU_3D)
fprintf('   number of layers    : %i\n',get(dm,'numlayers'));
end
if (dm.filetype==dm.FILETYPE_DFS1)
fprintf('   size of dimensions  : %i\n',get(dm,'gridsize'));
end
if (dm.filetype==dm.FILETYPE_DFS2)
fprintf('   size of dimensions  : %i x %i\n',get(dm,'gridsize'));
end
if (dm.filetype==dm.FILETYPE_DFS3)
fprintf('   size of dimensions  : %i x %i x %i\n',get(dm,'gridsize'));
end

% Item information
items = get(dm,'items');
fprintf('   number of items     : %i\n',size(items,1));
for i = 1:size(items,1)
fprintf('            item %3i   : %-15s',i,items{i,1});
if (dm.filetype==dm.FILETYPE_DFSU_2D || dm.filetype==dm.FILETYPE_DFSU_3D || dm.filetype==dm.FILETYPE_MESH)
  base = items(i,6);
  if (base{1} == 0) % node based
    fprintf('   (node values)\n');
  else
    fprintf('   (elmt values)\n');
  end
else
    fprintf('\n');
end
end
if (dm.filetype==dm.FILETYPE_DFSU_3D)
  fprintf('   spatial item    1   : %-15s   (node values)\n','Z coordinate');
end

% Temporal information
[timeaxistype,numtimesteps,timestepsec] = readTemporalDef(dm);
[datetime] = readTemporalStartEnd(dm,timeaxistype,numtimesteps,timestepsec);

fprintf('   time axis type      : ');
switch (timeaxistype)
  case {dm.TIME_UNDEF}
fprintf('undefined time axis\n')
  case {dm.TIME_EQ_REL}
fprintf('Relative time axis, equidistant\n');
fprintf('   starttime           : %6.3f\n',datetime(1));
fprintf('   endtime             : %6.3f\n',datetime(end));
fprintf('   timestep interval   : %10.3f (seconds)\n',timestepsec);
  case {dm.TIME_NONEQ_REL}
fprintf('Relative time axis, non-equidistant\n');
fprintf('   starttime           : %6.3f\n',datetime(1));
fprintf('   endtime             : %6.3f\n',datetime(end));
fprintf('   timestep interval   : Varying\n');
  case {dm.TIME_EQ_CAL}
fprintf('Calendar time axis, equidistant\n');
fprintf('   startdate           : %04i-%02i-%02i %02i:%02i:%06.3f\n',datetime(1,:));
fprintf('   enddate             : %04i-%02i-%02i %02i:%02i:%06.3f\n',datetime(end,:));
fprintf('   timestep interval   : %10.3f (seconds)\n',timestepsec);
  case {dm.TIME_NONEQ_CAL}
fprintf('Calendar time axis, non-equidistant\n');
fprintf('   startdate           : %04i-%02i-%02i %02i:%02i:%06.3f\n',datetime(1,:));
fprintf('   enddate             : %04i-%02i-%02i %02i:%02i:%06.3f\n',datetime(end,:));
fprintf('   timestep interval   : Varying\n');
  otherwise
fprintf('undefined unknown time axis\n')
end
fprintf('   number of timesteps : %i\n',numtimesteps);

% Projection information
fprintf('   projection          : %s\n',get(dm,'projection'));

% Debug information
fprintf('   fileid              : %i (debug)\n',dm.fileid);

