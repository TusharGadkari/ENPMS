function [RETURN_VU] = readSelectedCellsDFS3(DF,infile,SEEPAGEMAP,INI)

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
VU_DFS3(1:TS.S.nsteps,1:i2-1) = 0;

n_diff = datenum(INI.ANALYZE_DATE_I) - i1;

T = TS.S.TSTART - 1;
for i=0:TS.S.nsteps-1
    %ds = datestr(TIME(i,:),2);
    %fprintf('%s %s %i %s %i\n', ds, ' Step: ', i+1, '/', TS.S.nsteps);
    %HARDWIRED to item 3
    T = T + 1;
    i_1 = i+1;
    ds = datestr(T);
    fprintf('... Reading Seepage Values from %s: %s: %s %i %s %i\n',char(DF), ds, ' Step: ', i+1, '/', TS.S.nsteps) 
    D_X = double(TS.S.dfs2.ReadItemTimeStep(1,i).To3DArray());
    D_Y = double(TS.S.dfs2.ReadItemTimeStep(2,i).To3DArray());
    DATAZ = double(TS.S.dfs2.ReadItemTimeStep(3,i).To3DArray());
    for ii = 0:TS.S.z-1
        DATAX = D_X(:,:,ii+1);
        DATAY = D_Y(:,:,ii+1);
        for v = VUNIQUE(2:end)
            %A = DATA(SEEPAGEMAP==v)
            switch v
                case 1
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,1) = VU_DFS3(i_1,1) + nansum(A);
                case 2
                    A = DATAY(SEEPAGEMAP==v);
                    VU_DFS3(i_1,2) = VU_DFS3(i_1,2) + nansum(A);
                case 3
                    A = DATAY(SEEPAGEMAP==v);
                    VU_DFS3(i_1,3) = VU_DFS3(i_1,3) + nansum(A);
                case 4
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,4) = VU_DFS3(i_1,4) + nansum(A);
                case 5
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,5) = VU_DFS3(i_1,5) + nansum(A);
                case 6
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,6) = VU_DFS3(i_1,6) + nansum(A);
                case 7
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,7) = VU_DFS3(i_1,7) + nansum(A);
                case 8
                    A = DATAY(SEEPAGEMAP==v);
                    VU_DFS3(i_1,8) = VU_DFS3(i_1,8) + nansum(A);
                case 9
                    A = DATAY(SEEPAGEMAP==v);
                    VU_DFS3(i_1,9) = VU_DFS3(i_1,9) + nansum(A);
                case 10
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,10) = VU_DFS3(i_1,10) + nansum(A);
                case 11
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,11) = VU_DFS3(i_1,11) + nansum(A);
                case 12
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,12) = VU_DFS3(i_1,12) + nansum(A);
                case 13
                    if ii == 2
                        A = DATAZ(SEEPAGEMAP==v);
                        VU_DFS3(i_1,13) = nansum(A);
                    end
                case 14
                    A = DATAX(SEEPAGEMAP==v);
                    VU_DFS3(i_1,14) = VU_DFS3(i_1,14) + nansum(A);
            end
            
            %TS.MAPDATA(T) = DATA;
        end
    end
end

RETURN_VU = VU_DFS3(1+n_diff:TS.S.nsteps,:);

end