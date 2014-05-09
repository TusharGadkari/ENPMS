function [datetime] = readTemporalStartEnd(dm,timeaxistype,numtimesteps,timestepsec)
%
%

if (nargin < 3)
  [timeaxistype,numtimesteps,timestepsec] = readTemporalDef(dm);
end

% Calendar type time axis
if (timeaxistype == dm.TIME_UNDEF)
  datetime =zeros(2,6);

elseif (timeaxistype >= 3)

  temporal       = calllib('DFSManLib', 'DMGetTemporalStartEnd', dm.fileid);
  startdate      = temporal(1:6);
  
  % Calculate enddate
  % Assuming equidistant time axis !!!
  startdatenum = datenum(startdate);
  % Calculate enddate, round to nearest millisecond
  enddatenum   = startdatenum+((numtimesteps-1)*timestepsec+0.0005)/(24*60*60);
  enddate      = datevec(enddatenum);
  enddate(6)   = floor(enddate(6)*1000)*0.001; 
  datetime = [startdate;enddate];

% Relative type time axis
else
  
  temporal       = calllib('DFSManLib', 'DMGetTemporalStartEnd', dm.fileid);
  startdate      = temporal(1:6);
  
  % Calculate enddate
  % Assuming equidistant time axis !!!
  startdate = datenum(startdate);
  enddate   = startdate+(numtimesteps-1)*timestepsec/(24*60*60);
  datetime = [startdate;enddate];
  
end
