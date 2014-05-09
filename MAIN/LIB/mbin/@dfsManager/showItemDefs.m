function showItemDefs(dm)
%DFSManager/SHOWITEMDEFS Command window show of DFS file items.
%
%   Prints item name, EUMType number and name, and 
%   EUMUnit number and name to display.
%   
%   showItemDefs(dm)
%

if (~calllib('DFSManLib','DMIsOpen',dm.fileid))
  error('dfsManager:FileNotOpen',...
    'Empty dfsManager object. File has been closed.')
end

items = get(dm,'items');
fprintf('   #items   : %i\n',size(items,1));
for i = 1:size(items,1)
fprintf('item %3i\n',i);
fprintf('   Name     : %s \n',char(items(i,1)));
fprintf('   EUMType  : %s (%i) \n',items{i,2},items{i,5});
fprintf('   EUMUnit  : %s (%i) \n',items{i,3},items{i,6});
end
