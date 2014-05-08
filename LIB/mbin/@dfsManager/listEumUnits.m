function l = listEumUnits(dm,itemno)
%DFSMANAGER/LISTEUMUNITS List EUM Units available for item.
%
%   List the EUM units that are available globally or for a speical
%   item-number given the type of the item.
%
%   Usage:
%     l = listEumUnits(dfs)          % all units globally
%     l = listEumUnits(dfs,itemno)   % units available for item
%     l = listEumUnits(dfs,eumtype)  % units available for item type
%
%   Input:
%     dfs     : DFS object
%     itemno  : Number of item to retrieve available units from
%     eumtype : Type description or identifier string
%
%   Output:
%     l      : A list of all available units (abbreviated)
%
%   See also DFSMANAGER/listEumTypes, DFSMANAGER/setItemEum


%% Get all available units
if (nargin < 2)
  % Read all unit identifiers
  s         = calllib('DFSManLib','DMUnitGetAll');
  allunitid = strread(s,'%s','delimiter',';');
  % find unit abbreviations
  l         = cell(size(allunitid));
  for i = 1:numel(allunitid)
    unitid = allunitid{i};
    % Get abbreviated unit
    l{i,1} = calllib('DFSManLib','DMUnitGetAbbr',unitid);
  end

  
%% Get units for item type descriptor/identifier
elseif (ischar(itemno))
  itemtype = itemno;

  % Check if itemtype is a eum item identifier
  if (strcmpi(itemno(1:3),'eum'))
    l = calllib('DFSManLib','DMItemTypeGetUnits',itemtype);
  else
    % Get all item type descriptions and identifiers.
    allitems = calllib('DFSManLib','DMItemTypeGetAll');
    i        = find(strcmpi(allitems(:,1),itemtype));
    % Take the item identification string
    if (numel(i)==0)
      error(id('typeNotExisting'),'Type ''%s'' does not exist',itemtype);
    end
    itemtype = allitems{i,2};  
    l = calllib('DFSManLib','DMItemTypeGetUnits',itemtype);
  end


%% Get units for specific item
else
  items    = get(dm,'items');
  if (itemno > size(items,1))
    error(id('outOfRange'),'Requesting item number %i, file has only %i items',itemno,size(items,1));
  end
  % Get all item type descriptions and identifiers.
  allitems = calllib('DFSManLib','DMItemTypeGetAll');
  % Search for the one matching item description
  i        = find(strcmpi(allitems(:,1),items(itemno,2)));
  % Take the item identification string
  itemtype = allitems{i,2};
  % Get all unit abbreviations available for this item type.
  l = calllib('DFSManLib','DMItemTypeGetUnits',itemtype);
end

%%
function str = id(str)
str = ['dfsManager:listEumUnits:' str];