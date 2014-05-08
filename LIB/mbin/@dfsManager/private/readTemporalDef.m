function [timeaxistype,numtimesteps,timestepsec] = readTemporalDef(dm)
%
%

temporal     = calllib('DFSManLib', 'DMGetTemporalDef', dm.fileid);
timeaxistype = temporal(1);
numtimesteps = temporal(2);
timestepsec  = temporal(3);
