function [ ] = OutputDFS0v1(TS,itm)

%{
Create a dfs0 file, set the info and add the valuevector
Called by:
Createdfs0fromtext
%}

% Create the dfs0
dfs0 = dfsTSO(TS.DFS0file{itm},1);

%addTimesteps(dfs0,TS.dlength);
addTimesteps(dfs0,length(TS.ValueVector));
addItem(dfs0,TS.stationname,TS.stationtype,TS.stationunit);
set(dfs0,'filename',TS.DFS0file{itm});
set(dfs0,'filetitle',char(TS.title));
set(dfs0,'itemcoordinates',[TS.utmx{:},TS.utmy{:},TS.gridgse{:}]);
set(dfs0,'timeaxistype','Equidistant_Calendar');
set(dfs0,'startdate',TS.startdate);
set(dfs0,'timestep',[0 0 1 0 0 0]);
%set(dfs0,'deletevalue',delvalue);
set(dfs0,'deletevalue',-1.0e-035);
dfs0(1) = single(TS.ValueVector);

% Save and close files
save(dfs0);
dfs0.Close();

end