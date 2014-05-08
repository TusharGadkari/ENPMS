function dm = addItem(dm,itemname,eumtype,eumunit,elmtbased)
%DFSTSO/ADDITEM Adds item to file.
%
%   Adds one item to file. Items can only be added to new files, and only
%   until create(dfs) has been called.
%
%   Usage:
%     addItem(dfs,itemname)
%     addItem(dfs,itemname,eumtype)
%     addItem(dfs,itemname,eumtype,eumunit)
%
%   Inputs:
%     dfs       : DFS object
%     itemname  : String containing the name of the item
%     eumtype   : String containing the name of the EUM Type
%     eumunit   : String containing the name of the EUM Unit
%
%   Note:
%     eumtype must be a valid EUM Type string, see listEumTypes(dfs)
%     for a list of all valid strings. You can also use eum type
%     identification strings (those starting with eumIXXX).
%
%     eumunit must be a valid EUM Unit string (abbreviation) matching the
%     EUM Type, see listEumUnits(dfs,eumtype) for valid strings for a given
%     item EUM type. You can also use eum unit identification strings
%     (those starting with eumUXXX).
%
%     Unknown/incompatible types are not allowed and will raise an error.
%
%     Eum type and unit can be set/changed using setItemEum.
%
%     After create(dfs) has been called, no further items can be added.
%
%   See also DFSManager/setItemEum, DFSManager/listEumTypes,
%            DFSManager/listEumUnits
%

% Copyright DHI 
% Version 0.4, 2007-11-21, JGR

if (nargin < 3)
  eumtype = 'eumIItemUndefined';
end
if (nargin < 4)
  eumunit = 'eumUUnitUndefined';
end

% Set to zero if node based (z coordinate in 3D dfsu files)
if (nargin < 5)
  elmtbased = 1;
end

%% Check if eumtype is valid
alltypes = calllib('DFSManLib','DMItemTypeGetAll');

% Check if we have an eum type description or identifier
if (~strcmpi(eumtype(1:3),'eum'))
  % Search for a matching item description
  i = find(strcmpi(alltypes(:,1),eumtype),1);
  if (numel(i) == 0)
    error(id('typeNotExisting'),'Type ''%s'' does not exist.',eumtype);
  else
    % Take the type identification string
    eumtypeid = alltypes{i,2};
  end
else
  eumtypeid = eumtype;
  % Check if eum type identifier exist
  i = find(strcmpi(alltypes(:,2),eumtype));
  if (numel(i) == 0)
    warning(id('typeNotExisting'),'Type ''%s'' does not exist',eumtype);
  end
end


%% Check if eumunit is valid for eumtype

% Read all unit identifiers
s         = calllib('DFSManLib','DMUnitGetAll');
allunitid = strread(s,'%s','delimiter',';');
% Get all unit abbreviations
allunitab = cell(size(allunitid));
for i = 1:numel(allunitid)
  % Get abbreviated unit
  allunitab{i,1} = calllib('DFSManLib','DMUnitGetAbbr',allunitid{i});
end

% Check if unit is valid
if ((numel(eumunit) >= 3) && strcmpi(eumunit(1:3),'eum'))
  unitno = find(strcmpi(allunitid,eumunit),1);
else
  unitno = find(strcmpi(allunitab,eumunit),1);
end
if (numel(unitno) == 0)
  error(id('unitNotExisting'),'Unit ''%s'' does not exist.',eumunit);
else
  eumunitid = allunitid{unitno};
  eumunitab = allunitab{unitno};
end

% Get all available unit abbreviations for item
itemunitab = listEumUnits(dm,eumtypeid);
i = find(strcmpi(itemunitab,eumunitab));
if (numel(i) == 0)
  error(id('unitNotValidForItem'),'Unit ''%s'' is not valid for item ''%s''.',eumunit,eumtype);
end


%% Add item
calllib('DFSManLib','DMAddItem',dm.fileid,itemname,itemname,eumtypeid,eumunitid,elmtbased);


function str = id(str)
str = ['dfsManager:addItem:' str];
