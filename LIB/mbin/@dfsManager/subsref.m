function data = subsref(dm, S)
%DFSMANAGER/SUBSREF Subscripted reference.
%
%   Read data using subscripted referencing
%
%   Usage:
%       data = dfs(i,v)       Read only timesteps in v of item
%
%   input:
%      i          : Item number to read
%                   item numbers start from 1
%                   or itemname
%      v          : Timestep to read, timestep indeces start from 0
%
%   output:
%       data      : A vector containing data values for item
%
%   examples:
%       dfs(2,5)        : retrieve timestep 5 for item 2

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

if (strcmp(S(1).type,'()') || strcmp(S(1).type,'{}'))
  
  % Get item number
  if (~isnumeric(S(1).subs{1}))
      names = get(dm,'itemnames');
      found = false;
      for i=1:length(names)
          if strcmp(S(1).subs{1},names{i})
              S(1).subs{1} = i;
              found = true;
              break;
          end
      end
      if ~found
          possibleNames = '';
          for kk = 1:length(names)
              possibleNames = sprintf('%s\n%s',possibleNames,names{kk});
          end
        error('dfsManager:IndexError','First index must be an integer (item number) or an item name\nPossible names are: %s',possibleNames);
      end
  end
  itemno = S(1).subs{1};

  if (~isnumeric(S(1).subs{2}))
    error('dfsManager:IndexError','Second index must be an integer (timestep number)');
  end
  v = S(1).subs{2};
  if (numel(v)>1)
    error('dfsManager:IndexError',[...
      'Second index must be scalar. dfsManager can only retrieve one timestep\n'...
      'at a time']);
  end

  % Read item
  data = readItemTimestep(dm,itemno,v);
  
end

