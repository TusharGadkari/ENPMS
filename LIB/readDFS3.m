function [TS] = readDFS3(infile,SEEPAGEMAP)

%{
Open and read info from a DFS2 file
%}

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;
import DHI.Generic.MikeZero.DFS.dfs123.*;
TS.S.dfs2 = DfsFileFactory.Dfs3FileOpen(infile);

% % Read coordinates from file. Note that values are element center values
% % and therefor 0.5*Dx/y is added to all coordinates
% %S.x = saxis.X0 + saxis.Dx*(0.5+(0:(saxis.XCount-1)))';
% %S.y = saxis.Y0 + saxis.Dy*(0.5+(0:(saxis.YCount-1)))';
% %X0 = 494889.2;
% %Y0 = 2790267;
saxis = TS.S.dfs2.SpatialAxis;
%TODO: check x,y are these centers?
TS.S.x = saxis.X0 + saxis.Dx*((0:(saxis.XCount-1)))';
TS.S.y = saxis.Y0 + saxis.Dy*((0:(saxis.YCount-1)))';
TS.S.z = saxis.ZCount;
TS.S.dx = saxis.Dx;
TS.S.dy = saxis.Dy;

for i = 0:TS.S.dfs2.ItemInfo.Count-1
    TS.S.item(i+1).itemname = char(TS.S.dfs2.ItemInfo.Item(i).Name);
    TS.S.item(i+1).itemtype = char(TS.S.dfs2.ItemInfo.Item(i).DataType);
    %TS.S.item(i+1).itemvalue = char(TS.S.dfs2.ItemInfo.Item(i).ValueType); % Instantaneous
    TS.S.item(i+1).itemunit = char(TS.S.dfs2.ItemInfo.Item(i).Quantity.UnitAbbreviation);
    TS.S.item(i+1).itemdescription=char(TS.S.dfs2.ItemInfo.Item(i).Quantity.ItemDescription);
    %TS.S.item(i+1).unitdescription=char(TS.S.dfs2.ItemInfo.Item(i).Quantity.UnitDescription);
end
TS.S.count = TS.S.dfs2.ItemInfo.Count;
TS.S.deltat   = TS.S.dfs2.FileInfo.TimeAxis.TimeStep;
TS.S.unitt   = char(TS.S.dfs2.FileInfo.TimeAxis.TimeUnit);
TS.S.nsteps   = TS.S.dfs2.FileInfo.TimeAxis.NumberOfTimeSteps;
D = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Day;
M = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Month;
Y = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Year;
H = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Hour;
m = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Minute;
S = TS.S.dfs2.FileInfo.TimeAxis.StartDateTime.Second;

TS.S.TSTART = datenum(double([Y M D H m S]));
TV = (TS.S.TSTART:TS.S.TSTART+TS.S.nsteps);
% TS.MAPDATA = containers.Map(TV);

DATA(1:saxis.XCount,1:saxis.YCount,1:saxis.ZCount) = NaN;
TS.MAPDATA = containers.Map(double(1),DATA);
remove(TS.MAPDATA,1);

%TS.DATA(1:TS.S.nsteps) = DATA;

VUNIQUE = unique(SEEPAGEMAP)';
a = size(VUNIQUE)

i1 = TS.S.TSTART; % length of time vector
i2 = a(2); % length of extracted cells
i3 = TS.S.z; % codes of extracted cells

T = TS.S.TSTART - 1;
L01=NaN(TS.S.nsteps,TS.S.z);
L02=L01;L03=L01;L04=L01;L05=L01;L06=L01;L10=L01;
for i=0:TS.S.nsteps-1
    %ds = datestr(TIME(i,:),2);
    %fprintf('%s %s %i %s %i\n', ds, ' Step: ', i+1, '/', TS.S.nsteps);
    %HARDWIRED to item 3
    DATAX = double(TS.S.dfs2.ReadItemTimeStep(1,i).To3DArray());
    DATAY = double(TS.S.dfs2.ReadItemTimeStep(2,i).To3DArray());
    DATAZ = double(TS.S.dfs2.ReadItemTimeStep(3,i).To3DArray());
    for ii = 0:TS.S.z-1
        for v = VUNIQUE(2:end)
            %A = DATA(SEEPAGEMAP==v)
            switch v
                case 1
                    A = DATAX(SEEPAGEMAP==v);
                    L01(i+1,ii+1) = nansum(A);
                case 2
                    A = DATAX(SEEPAGEMAP==v);
                    L02(i+1,ii+1) = nansum(A);
                case 3
                    A = DATAX(SEEPAGEMAP==v);
                    L03(i+1,ii+1) = nansum(A);
                case 4
                    A = DATAX(SEEPAGEMAP==v);
                    L04(i+1,ii+1) = nansum(A);
                case 5
                    A = DATAY(SEEPAGEMAP==v);
                    L05(i+1,ii+1) = nansum(A);
                case 6
                    A = DATAY(SEEPAGEMAP==v);
                    L06(i+1,ii+1) = nansum(A);
                case 10
                    A = DATAZ(SEEPAGEMAP==v);
                    L10(i+1,ii+1) = nansum(A);
            end
            
            %TS.MAPDATA(T) = DATA;
        end
    end
end

end