function [S] = InputDFS3v0(infile)

%{
Open and read info from a DFS2 file
%}
NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;
import DHI.Generic.MikeZero.DFS.dfs123.*;
S.dfs2 = DfsFileFactory.Dfs3FileOpen(infile);

% % Read coordinates from file. Note that values are element center values
% % and therefor 0.5*Dx/y is added to all coordinates
% %S.x = saxis.X0 + saxis.Dx*(0.5+(0:(saxis.XCount-1)))';
% %S.y = saxis.Y0 + saxis.Dy*(0.5+(0:(saxis.YCount-1)))';
% %X0 = 494889.2;
% %Y0 = 2790267;
saxis = S.dfs2.SpatialAxis;
%TODO: check x,y are these centers?
S.x = saxis.X0 + saxis.Dx*((0:(saxis.XCount-1)))';
S.y = saxis.Y0 + saxis.Dy*((0:(saxis.YCount-1)))';
S.dx = saxis.Dx;
S.dy = saxis.Dy;

for i = 0:S.dfs2.ItemInfo.Count-1
    S.item(i+1).itemname = char(S.dfs2.ItemInfo.Item(i).Name);
    S.item(i+1).itemtype = char(S.dfs2.ItemInfo.Item(i).DataType);
    %S.item(i+1).itemvalue = char(S.dfs2.ItemInfo.Item(i).ValueType); % Instantaneous
    S.item(i+1).itemunit = char(S.dfs2.ItemInfo.Item(i).Quantity.UnitAbbreviation);
    S.item(i+1).itemdescription=char(S.dfs2.ItemInfo.Item(i).Quantity.ItemDescription);
    %S.item(i+1).unitdescription=char(S.dfs2.ItemInfo.Item(i).Quantity.UnitDescription);
end
S.count = S.dfs2.ItemInfo.Count;
S.deltat   = S.dfs2.FileInfo.TimeAxis.TimeStep;
S.unitt   = char(S.dfs2.FileInfo.TimeAxis.TimeUnit);
S.nsteps   = S.dfs2.FileInfo.TimeAxis.NumberOfTimeSteps;

end