function [TS] = ReadDFS3makeDFS0v0(TS,dfs2,itm)

%{
Read items from a DFS3 file
%}
hall=zeros(TS.S.nsteps,length(TS.S.x),length(TS.S.y));
%htot=zeros(length(x),length(y));

for i=0:TS.S.nsteps-1
        % Read data for timestep, put in 3-d matrix
	h = double(dfs2.ReadItemTimeStep(itm,i).To3DArray());
    hall(i+1,:,:) = h;
    %htot = htot+ h;
end

return
sd = dfs3.FileInfo.TimeAxis.StartDateTime;
dfsstartdatetime=datenum(double([sd.Year sd.Month sd.Day sd.Hour sd.Minute sd.Second]));
DfsTime = double(dfsstartdatetime + TS.S.nsteps-1);
TS.ValueVector =  TSmerge(hall(:,TS.row,TS.col), TS.dlength, datenum(TS.startdate), datenum(TS.enddate), dfsstartdatetime, DfsTime);

TS.stationtype = TS.S.item(itm).itemdescription;
TS.stationunit = TS.S.item(itm).itemunit;
if (exist(TS.DFS0file{itm},'file') == 2)
   fprintf('... DFS0 file exists, replacing: %s\n', TS.DFS0file{itm});
   delete (TS.DFS0file{itm});
else
   fprintf('... Creating DFS0file %s\n', TS.DFS0file{itm});
end

%OutputDFS0v1(TS,itm)

end