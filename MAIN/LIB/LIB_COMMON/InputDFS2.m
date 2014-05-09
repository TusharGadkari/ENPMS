function [S] = InputDFS2(infile,itm)

%{
Open and read info from a DFS2 file
%}
NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;
S.dfs2 = DfsFileFactory.Dfs2FileOpen(infile);
S.dfs2.ItemInfo.Count
% fprintf('   #items   : %i\n',S.dfs2.TSO.Count);
 for i = 0:S.dfs2.ItemInfo.Count-1
 fprintf('item %3i\n',i);
 fprintf('   Name     : %s \n',char(S.dfs2.ItemInfo.Item(i).Name));
% fprintf('   EUMType  : %s \n',dm.TSO.Item(i).EumTypeDescription);
% fprintf('   EUMUnit  : %s \n',dm.TSO.Item(i).EumUnitAbbreviation);
 end
itm
itm=i-1
% Read coordinates from file. Note that values are element center values
% and therefor 0.5*Dx/y is added to all coordinates
%S.x = saxis.X0 + saxis.Dx*(0.5+(0:(saxis.XCount-1)))';
%S.y = saxis.Y0 + saxis.Dy*(0.5+(0:(saxis.YCount-1)))';
%X0 = 494889.2;
%Y0 = 2790267;
saxis = S.dfs2.SpatialAxis;
%TODO: check x,y centers?
S.x = saxis.X0 + saxis.Dx*((0:(saxis.XCount-1)))';
S.y = saxis.Y0 + saxis.Dy*((0:(saxis.YCount-1)))';
S.dx = saxis.Dx;
S.dy = saxis.Dy;

S.itemname = char(S.dfs2.ItemInfo.Item(itm).Name);
S.itemtype = char(S.dfs2.ItemInfo.Item(itm).DataType);
%itemvalue = char(S.dfs2.ItemInfo.Item(itm).ValueType); % Instantaneous
S.itemunit = char(S.dfs2.ItemInfo.Item(itm).Quantity.UnitAbbreviation);
S.itemdescription=char(S.dfs2.ItemInfo.Item(itm).Quantity.ItemDescription);
%S.unitdescription=char(S.dfs2.ItemInfo.Item(itm).Quantity.UnitDescription);

S.deltat   = S.dfs2.FileInfo.TimeAxis.TimeStep;
S.unitt   = char(S.dfs2.FileInfo.TimeAxis.TimeUnit);
S.nsteps   = S.dfs2.FileInfo.TimeAxis.NumberOfTimeSteps;

end