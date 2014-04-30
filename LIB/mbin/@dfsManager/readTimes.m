function t = readTimes(dm,timestepno)
%DFSManager/READTIME Read time for timestep.
%
%   Reads time for a given timestep, or a set of timesteps.
%
%   Usage:
%     t = readTime(dfs,timestepno)
%
%   Inputs:
%     dfs        : dfsManager object
%     timestepno : A vector of timestep index numbers, index start from 0.
%
%   Output:
%     t          : A vector/matrix containing time values for each timestep
%                  For calendar type time axis, each row will contain 6
%                  columns (see help DATEVEC). For relative type time
%                  axis, each row will only contain 1 column.
%
%   Note:
%       Due to limitations in the data access layer, for non-equidistant
%       type time axis it is need to read data for an item also, hence
%       performance is not optimal.

timeaxistype = get(dm,'TimeAxisType');
if (isCalendar(timeaxistype))
  t = zeros(length(timestepno),6);
else
  t = zeros(length(timestepno),1);
end
for i = 1:numel(timestepno)
  tno   = timestepno(i);
  t(i,:) = calllib('DFSManLib','DMGetTime',dm.fileid,tno);
end
