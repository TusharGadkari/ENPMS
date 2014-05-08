function [TS] = ReadDFS2makeDFS0(TS,dfs2)

%{
Read items from a DFS2 file
%}
hall=zeros(TS.S.nsteps,length(TS.S.x),length(TS.S.y));
%htot=zeros(length(x),length(y));
for i=0:TS.S.nsteps-1
        % Read data for timestep, put in 3-d matrix
	h = double(dfs2.ReadItemTimeStep(1,i).To2DArray());
    hall(i+1,:,:) = h;
    %htot = htot+ h;
end
dfs2.Close();
sd = dfs2.FileInfo.TimeAxis.StartDateTime;
dfsstartdatetime=datenum(double([sd.Year sd.Month sd.Day sd.Hour sd.Minute sd.Second]));
DfsTime = double(dfsstartdatetime + TS.S.nsteps-1);
TS.ValueVector =  TSmerge(hall(:,TS.row,TS.col), TS.dlength, datenum(TS.startdate), datenum(TS.enddate), dfsstartdatetime, DfsTime);


TS.stationtype = TS.S.itemdescription;
TS.stationunit = TS.S.itemunit;
if (exist(TS.DFS0file,'file') == 2)
   fprintf('... DFS0 file exists, replacing: %s\n', char(TS.DFS0file));
   delete (char(TS.DFS0file));
else
   fprintf('... Creating DFS0file %s\n', char(TS.DFS0file));
end

OutputDFS0(TS)

end