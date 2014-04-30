function e = end(dm, k, n)
%DFSTSO/END Subscripted reference end.
%
%   Get last index of subscripted reference.
%

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

switch (k)
  case {1}
    items = get(dm,'items');
    e = size(items,1);
  case {2}
    [timeaxistype,numtimesteps,timestepsec] = readTemporalDef(dm);
    e = numtimesteps-1;
end
