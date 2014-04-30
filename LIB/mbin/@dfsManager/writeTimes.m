function writeTimes(dm,timestepno,t)
%DFSManager/WRITETIMES Write time for timestep.
%
%   Writes time for a given timestep, or a set of timesteps. 
%
%   For equidistant time axis types, timestep times are controlled by the
%   startdate and timestep parameters. See dfsTSO/SET for how to
%   update timestep times for equidistant time axis files.
%
%   Setting a time value bigger than or equal to the next Timestep time
%   value or smaller than or equal to the previous Timestep time value is
%   not possible.
%
%   Usage:
%     writeTimes(dfs,timestepno,t)
%
%   Inputs:
%     dfs        : dfsManager object
%     timestepno : A vector of timestep index numbers, index start from 0.
%     t          : A vector/matrix containing time values for each timestep
%                  For calendar type time axis, each row will contain 6
%                  columns (see help DATEVEC). For relative type time
%                  axis, each row will only contain 1 column.

if (numel(timestepno) ~= size(t,1))
  error(id('Size mismatch'),'Inputs timestepno and t size mismatch')
end

for i = 1:numel(timestepno)
  tno   = timestepno(i);
  tdate = t(i,:);
  calllib('DFSManLib','DMSetTime',dm.fileid,tno,tdate);
end

function str = id(str)
str = ['dfsManager:writeTimes:' str];
