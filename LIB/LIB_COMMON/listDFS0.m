function [n, LIST_DFS0 ] = listDFS0( DFS0_DIRECTORY )
%Lists all dfs files in a given directory

E = exist('DFS0_DIRECTORY','var');
if (E ~= 1)
    disp('Provide path to dir of dfs0 files, exiting');
    return;
end
DFS0 = dir([DFS0_DIRECTORY '/*.dfs0']);
n = length(DFS0);
if n == 0 
    disp('DFS0 files not found, returning with no list');
    return
end  
LIST_DFS0 = {DFS0.name};

end
