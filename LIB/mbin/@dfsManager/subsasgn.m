function dm = subsasgn(dm, S, data)
%DFSMANAGER/SUBSASGN Subscripted reference assignment.
%
%   Write data using subscripted referencing
%
%   Usage:
%       dfs(i,v) = data       Write data to timesteps v of item i
%
%   input:
%      i          : Item number to write, item numbers start from 1
%      v          : Timestep number to write, timestep indeces start from 0
%      data       : A vector containing data values for item
%
%   See also DFSMANAGER/WRITEITEM

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (strcmp(S(1).type,'()') || strcmp(S(1).type,'{}'))
  
  % Get item number
  if (~isnumeric(S(1).subs{1}))
    error('dfsManager:IndexError','First index must be an integer (item number)');
  end
  itemno = S(1).subs{1};

  if (~isnumeric(S(1).subs{2}))
    error('dfsManager:IndexError','Second index must be an integer (timestep number)');
  end
  v = S(1).subs{2};
  if (numel(v)>1)
    error('dfsManager:IndexError',[...
      'Second index must be scalar. dfsManager can only write one timestep\n'...
      'at a time']);
  end

  % write data to item at timestep
  writeItemTimestep(dm,itemno,v,data);
  
end

