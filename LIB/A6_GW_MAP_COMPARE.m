function [] = A6_GW_MAP_COMPARE(INI)

i = 0;

for D = INI.MODEL_ALL_RUNS % iterate over selected model runs
   i = i + 1;
   MODEL_RESULT_DIR = INI.MODEL_FULLPATH{i};
   FILE_3DSZQ  = [MODEL_RESULT_DIR '/' char(D) '_3DSZflow.dfs3'];
   FILE_3DSZ  = [MODEL_RESULT_DIR '/' char(D) '_3DSZ.dfs3']
   DFS3(i) = inputDFS3(FILE_3DSZ);
end

a = datenum([2005 9 1 0 0 0]);%a_str = datestr(a,'yyyy-mm-dd');
b = datenum([2005 6 1 0 0 0]);
c = datenum([2008 10 10 0 0 0]);
d = datenum([2008 6 10 0 0 0]);
%e = datenum([2009 12 1 0 0 0]);

create_GW_DIFF(INI,a,DFS3);
create_GW_DIFF(INI,b,DFS3);
create_GW_DIFF(INI,c,DFS3);
create_GW_DIFF(INI,d,DFS3);
%create_GW_DIFF(INI,e,DFS3);

end

function create_GW_DIFF(INI,t,DFS3);

DATA0 = DFS3(1).MAPDATA(t);
LR = {'L1','L2','L3'};

for i = 2:length(DFS3)
   DATA = DFS3(i).MAPDATA(t);
   for k = 1:length(DATA0(1,1,:))
      DATA_DIFF = DATA0(:,:,k) - DATA(:,:,k);
      DT = DATA_DIFF';
      DT(DT==0)=-1e-035;
      FDT = flipdim(DT,1);
      LAYER = LR(k);
      F = ['DIFF_' char(datestr(t,'yyyy-mm-dd')) '_' char(LAYER) '_' char(INI.MODEL_ALL_RUNS(i)) '.xlsx']
      xlswrite(F,FDT);
   end
end

end

