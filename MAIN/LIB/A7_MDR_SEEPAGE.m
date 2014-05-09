function [] = A7_MDR_SEEPAGE(INI)

% open seepage codes

MAPF = 'MDR_SEEPAGE.dfs2';
SEEPAGEMAP = readSEEPAGEMAP(MAPF);
VUNIQUE = unique(SEEPAGEMAP)';
v = size(VUNIQUE);
VUNIQUE_V = v(2);
VUNIQUE_T = INI.NumPostProcDays;
VUNIQUE_N = INI.NSIMULATIONS;
VU_DFS3(1:VUNIQUE_T,1:VUNIQUE_V-1,1:VUNIQUE_N) = NaN;

i = 0;

for D = INI.MODEL_ALL_RUNS % iterate over selected model runs
   i = i + 1;
   MODEL_RESULT_DIR = INI.MODEL_FULLPATH{i};
   FILE_3DSZQ  = [MODEL_RESULT_DIR '/' char(D) '_3DSZflow.dfs3'];
   FILE_3DSZ  = [MODEL_RESULT_DIR '/' char(D) '_3DSZ.dfs3']
   VU_DFS3(:,:,i) = readSelectedCellsDFS3(D,FILE_3DSZQ,SEEPAGEMAP,INI);
end

TV_STR = getTimeVectorStr(INI);
fileXL = 'seepageValuesXL.xlsx';
saveSeepageValuesXL(VU_DFS3,INI,fileXL,TV_STR);

end

function [DS] = getTimeVectorStr(INI)
 i1 = datenum(INI.ANALYZE_DATE_I);
 i2 = datenum(INI.ANALYZE_DATE_F);
 DV = [i1:i2];
 DS = datestr(DV);

end


function extract_DATA(INI,DFS3);

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

