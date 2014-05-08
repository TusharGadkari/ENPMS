function createTemporalDef(dm,timeaxistype,starttime,numtimesteps,timestepsec)
%CREATETEMPORALDEF Create temporal definition for dfs file.
%
%   Usage
%       createTemporalDef(dfs,timeaxistype,starttime,numtimesteps,timestepsec)
%
%   inputs:
%       dfs          : DFS object.
%       timeaxistype : one of
%                          'undefined'
%                          'Equidistant_Relative'
%                          'Non_Equidistant_Relative'
%                          'Equidistant_Calendar'
%                          'Non_Equidistant_Calendar'
%       starttime    : for a calendar type time axis, a vector containing 
%                      [year month day hour minute seconds.millisecs]. For
%                      a relative time axis, a scalar number of seconds.
%       numtimesteps : Number of time steps.
%       timestepsec  : Number of seconds to use a time step for equidistant
%                      type time axis.
%

% Copyright, DHI 2006
% Version 0.4, 2007-11-21. Author: JGR

% For non-equidistant timeaxistypes, timestepsec can not be set
if (nargin < 5)
  timestepsec = -1;
end

%% Check time axis type
if (ischar(timeaxistype))
  i = find(strcmpi(dm.TIMEAXISTYPES,timeaxistype));
  if (numel(i) > 0)
    timeaxistype = i-1;
  else
    error(id('UnknownAxisType'),...
      'Unknown time axis type ''%s''.',timeaxistype);
  end
elseif (timeaxistype < 0 || timeaxistype > 4)
  error(id('UnknownAxisType'),...
    'Unknown time axis type ''%i'', must be between 0 and 4',timeaxistype);
end

%% Check starttime
if (timeaxistype == dm.TIME_EQ_CAL || timeaxistype == dm.TIME_NONEQ_CAL)
  if (numel(starttime) ~= 6)
    error(id('invalidStartTime'),...
      ['Start time is invalid for calendar type time axis.\n',...
       'Start time must have format [year month day hour minute second.millisecs]']);
  end
end
if (timeaxistype == dm.TIME_EQ_REL || timeaxistype == dm.TIME_NONEQ_REL)
  if (numel(starttime) ~= 1)
    error(id('invalidStartTime'),...
      ['Start time is invalid for relative type time axis.\n',...
       'Start time must be one value in seconds']);
  end
end

%% Create temporal def
calllib('DFSManLib','DMCreateTemporalDef',...
  dm.fileid,timeaxistype,starttime,numtimesteps,timestepsec);


%%
function str = id(str)
str = ['dfsManager:createTemporalDef:' str];
